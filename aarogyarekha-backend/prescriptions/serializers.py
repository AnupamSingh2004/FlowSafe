from rest_framework import serializers
from .models import Prescription, PrescriptionImage, Medicine, PrescriptionAnalytics


class PrescriptionImageSerializer(serializers.ModelSerializer):
    """Serializer for prescription images"""
    
    class Meta:
        model = PrescriptionImage
        fields = [
            'id', 'original_image', 'compressed_image', 'processed_image',
            'extracted_text', 'confidence_score', 'file_size', 'width', 
            'height', 'format', 'created_at'
        ]
        read_only_fields = [
            'compressed_image', 'processed_image', 'extracted_text', 
            'confidence_score', 'file_size', 'width', 'height', 'format'
        ]


class MedicineSerializer(serializers.ModelSerializer):
    """Serializer for medicine information"""
    potential_savings = serializers.ReadOnlyField()
    
    class Meta:
        model = Medicine
        fields = [
            'id', 'name', 'generic_name', 'dosage', 'frequency', 'duration',
            'quantity', 'instructions', 'estimated_cost', 'generic_available',
            'generic_cost', 'potential_savings', 'extraction_confidence',
            'created_at', 'updated_at'
        ]


class PrescriptionSerializer(serializers.ModelSerializer):
    """Serializer for prescriptions"""
    images = PrescriptionImageSerializer(many=True, read_only=True)
    medicines = MedicineSerializer(many=True, read_only=True)
    total_medicines = serializers.ReadOnlyField()
    estimated_total_cost = serializers.ReadOnlyField()
    uploaded_images = serializers.ListField(
        child=serializers.ImageField(),
        write_only=True,
        required=False
    )
    
    class Meta:
        model = Prescription
        fields = [
            'id', 'title', 'description', 'doctor_name', 'hospital_name',
            'prescription_date', 'created_at', 'updated_at', 'is_processed',
            'processing_status', 'images', 'medicines', 'total_medicines',
            'estimated_total_cost', 'uploaded_images'
        ]
        read_only_fields = ['user', 'is_processed', 'processing_status']

    def create(self, validated_data):
        uploaded_images = validated_data.pop('uploaded_images', [])
        prescription = Prescription.objects.create(**validated_data)
        
        # Create prescription images
        for image in uploaded_images:
            PrescriptionImage.objects.create(
                prescription=prescription,
                original_image=image
            )
        
        return prescription


class PrescriptionListSerializer(serializers.ModelSerializer):
    """Simplified serializer for prescription lists"""
    total_medicines = serializers.ReadOnlyField()
    estimated_total_cost = serializers.ReadOnlyField()
    image_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Prescription
        fields = [
            'id', 'title', 'doctor_name', 'hospital_name', 'prescription_date',
            'created_at', 'processing_status', 'total_medicines', 
            'estimated_total_cost', 'image_count'
        ]
    
    def get_image_count(self, obj):
        return obj.images.count()


class PrescriptionAnalyticsSerializer(serializers.ModelSerializer):
    """Serializer for prescription analytics"""
    
    class Meta:
        model = PrescriptionAnalytics
        fields = [
            'total_prescriptions', 'total_medicines_searched', 'total_savings',
            'stores_visited', 'schemes_applied', 'updated_at'
        ]


class PrescriptionUploadSerializer(serializers.Serializer):
    """Serializer for prescription upload"""
    images = serializers.ListField(
        child=serializers.ImageField(),
        min_length=1,
        max_length=10,
        help_text="Upload 1-10 prescription images"
    )
    title = serializers.CharField(max_length=200, required=False)
    description = serializers.CharField(required=False)
    doctor_name = serializers.CharField(max_length=100, required=False)
    hospital_name = serializers.CharField(max_length=200, required=False)
    prescription_date = serializers.DateField(required=False)
    
    def validate_images(self, value):
        """Validate uploaded images"""
        for image in value:
            # Check file size (max 10MB per image)
            if image.size > 10 * 1024 * 1024:
                raise serializers.ValidationError(
                    f"Image {image.name} is too large. Maximum size is 10MB."
                )
            
            # Check file type
            allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf']
            if hasattr(image, 'content_type') and image.content_type not in allowed_types:
                raise serializers.ValidationError(
                    f"Image {image.name} has unsupported format. "
                    f"Allowed formats: JPEG, PNG, PDF"
                )
        
        return value
