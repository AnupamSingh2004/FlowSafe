from rest_framework import generics, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from django.shortcuts import get_object_or_404
from django.db import transaction
from django.contrib.auth import get_user_model
import logging

User = get_user_model()

from .models import Prescription, PrescriptionImage, Medicine, PrescriptionAnalytics
from .serializers import (
    PrescriptionSerializer, PrescriptionListSerializer,
    PrescriptionImageSerializer, MedicineSerializer,
    PrescriptionAnalyticsSerializer, PrescriptionUploadSerializer
)
from .tasks import process_prescription_images

logger = logging.getLogger(__name__)


class PrescriptionViewSet(viewsets.ModelViewSet):
    """ViewSet for managing prescriptions"""
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def get_queryset(self):
        return Prescription.objects.filter(user=self.request.user)
    
    def get_serializer_class(self):
        if self.action == 'list':
            return PrescriptionListSerializer
        elif self.action == 'upload':
            return PrescriptionUploadSerializer
        return PrescriptionSerializer
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
    
    @action(detail=False, methods=['post'])
    def upload(self, request):
        """Upload prescription images with OCR processing"""
        serializer = PrescriptionUploadSerializer(data=request.data)
        
        if serializer.is_valid():
            try:
                with transaction.atomic():
                    # Create prescription
                    prescription_data = {
                        'user': request.user,
                        'title': serializer.validated_data.get('title', ''),
                        'description': serializer.validated_data.get('description', ''),
                        'doctor_name': serializer.validated_data.get('doctor_name', ''),
                        'hospital_name': serializer.validated_data.get('hospital_name', ''),
                        'prescription_date': serializer.validated_data.get('prescription_date'),
                        'processing_status': 'processing'
                    }
                    
                    prescription = Prescription.objects.create(**prescription_data)
                    
                    # Process and save images
                    from .utils import ImageProcessor, MedicineExtractor
                    image_processor = ImageProcessor()
                    medicine_extractor = MedicineExtractor()
                    
                    processed_images = []
                    all_extracted_text = []
                    
                    for image_file in serializer.validated_data['images']:
                        # Create prescription image
                        prescription_image = PrescriptionImage.objects.create(
                            prescription=prescription,
                            original_image=image_file
                        )
                        
                        # Compress image
                        compressed_image = image_processor.compress_image(image_file)
                        if compressed_image:
                            prescription_image.compressed_image.save(
                                f"compressed_{prescription_image.id}.jpg",
                                compressed_image,
                                save=False
                            )
                        
                        # Enhance image for OCR
                        enhanced_image = image_processor.enhance_image_for_ocr(image_file)
                        if enhanced_image:
                            prescription_image.processed_image.save(
                                f"processed_{prescription_image.id}.jpg",
                                enhanced_image,
                                save=False
                            )
                        
                        # Extract text using OCR
                        extracted_text, confidence = image_processor.extract_text_combined(image_file)
                        prescription_image.extracted_text = extracted_text
                        prescription_image.confidence_score = confidence
                        prescription_image.save()
                        
                        if extracted_text:
                            all_extracted_text.append(extracted_text)
                        
                        processed_images.append(prescription_image)
                    
                    # Extract medicines from all text
                    combined_text = ' '.join(all_extracted_text)
                    medicines_data = medicine_extractor.extract_medicines(combined_text)
                    
                    # Create medicine objects
                    for med_data in medicines_data:
                        Medicine.objects.create(
                            prescription=prescription,
                            **med_data
                        )
                    
                    # Update prescription status
                    prescription.is_processed = True
                    prescription.processing_status = 'completed'
                    prescription.save()
                    
                    # Update user analytics
                    analytics, created = PrescriptionAnalytics.objects.get_or_create(
                        user=request.user
                    )
                    analytics.update_analytics()
                    
                    # Return response
                    response_serializer = PrescriptionSerializer(prescription)
                    return Response({
                        'message': 'Prescription uploaded and processed successfully',
                        'data': response_serializer.data
                    }, status=status.HTTP_201_CREATED)
                    
            except Exception as e:
                logger.error(f"Error processing prescription: {str(e)}")
                # Update prescription status to failed
                if 'prescription' in locals():
                    prescription.processing_status = 'failed'
                    prescription.save()
                
                return Response({
                    'error': 'Failed to process prescription',
                    'details': str(e)
                }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail=True, methods=['post'])
    def reprocess(self, request, pk=None):
        """Reprocess prescription images"""
        prescription = self.get_object()
        
        try:
            prescription.processing_status = 'processing'
            prescription.save()
            
            # Trigger background processing
            process_prescription_images.delay(prescription.id)
            
            return Response({
                'message': 'Prescription reprocessing started'
            })
            
        except Exception as e:
            return Response({
                'error': 'Failed to start reprocessing',
                'details': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['get'])
    def analytics(self, request):
        """Get user prescription analytics"""
        analytics, created = PrescriptionAnalytics.objects.get_or_create(
            user=request.user
        )
        
        if not created:
            analytics.update_analytics()
        
        serializer = PrescriptionAnalyticsSerializer(analytics)
        return Response(serializer.data)


class MedicineViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing medicines"""
    serializer_class = MedicineSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return Medicine.objects.filter(prescription__user=self.request.user)
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        """Search medicines by name"""
        query = request.query_params.get('q', '')
        if query:
            medicines = self.get_queryset().filter(name__icontains=query)
        else:
            medicines = self.get_queryset()
        
        serializer = self.get_serializer(medicines, many=True)
        return Response(serializer.data)


class PrescriptionImageViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet for viewing prescription images"""
    serializer_class = PrescriptionImageSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return PrescriptionImage.objects.filter(prescription__user=self.request.user)


# API Views for specific endpoints
class PrescriptionUploadView(generics.CreateAPIView):
    """Dedicated view for prescription upload"""
    serializer_class = PrescriptionUploadSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]
    
    def create(self, request, *args, **kwargs):
        """Handle prescription upload"""
        return PrescriptionViewSet().upload(request)


class UserAnalyticsView(generics.RetrieveAPIView):
    """View for user analytics"""
    serializer_class = PrescriptionAnalyticsSerializer
    permission_classes = [IsAuthenticated]
    
    def get_object(self):
        analytics, created = PrescriptionAnalytics.objects.get_or_create(
            user=self.request.user
        )
        
        if not created:
            analytics.update_analytics()
        
        return analytics
