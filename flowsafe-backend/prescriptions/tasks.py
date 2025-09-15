from celery import shared_task
from django.contrib.auth import get_user_model
from .models import Prescription, PrescriptionImage, Medicine
import logging

User = get_user_model()

logger = logging.getLogger(__name__)


@shared_task
def process_prescription_images(prescription_id):
    """
    Background task to process prescription images
    """
    try:
        prescription = Prescription.objects.get(id=prescription_id)
        prescription.processing_status = 'processing'
        prescription.save()
        
        from .utils import ImageProcessor, MedicineExtractor
        image_processor = ImageProcessor()
        medicine_extractor = MedicineExtractor()
        
        all_extracted_text = []
        
        # Process each image
        for prescription_image in prescription.images.all():
            try:
                # Compress image if not already done
                if not prescription_image.compressed_image:
                    compressed_image = image_processor.compress_image(
                        prescription_image.original_image
                    )
                    if compressed_image:
                        prescription_image.compressed_image.save(
                            f"compressed_{prescription_image.id}.jpg",
                            compressed_image,
                            save=False
                        )
                
                # Enhance image for OCR if not already done
                if not prescription_image.processed_image:
                    enhanced_image = image_processor.enhance_image_for_ocr(
                        prescription_image.original_image
                    )
                    if enhanced_image:
                        prescription_image.processed_image.save(
                            f"processed_{prescription_image.id}.jpg",
                            enhanced_image,
                            save=False
                        )
                
                # Extract text using OCR
                extracted_text, confidence = image_processor.extract_text_combined(
                    prescription_image.original_image
                )
                
                prescription_image.extracted_text = extracted_text
                prescription_image.confidence_score = confidence
                prescription_image.save()
                
                if extracted_text:
                    all_extracted_text.append(extracted_text)
                
            except Exception as e:
                logger.error(f"Error processing image {prescription_image.id}: {str(e)}")
                continue
        
        # Extract medicines from all text
        if all_extracted_text:
            combined_text = ' '.join(all_extracted_text)
            medicines_data = medicine_extractor.extract_medicines(combined_text)
            
            # Clear existing medicines
            prescription.medicines.all().delete()
            
            # Create new medicine objects
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
        from .models import PrescriptionAnalytics
        analytics, created = PrescriptionAnalytics.objects.get_or_create(
            user=prescription.user
        )
        analytics.update_analytics()
        
        logger.info(f"Successfully processed prescription {prescription_id}")
        return f"Prescription {prescription_id} processed successfully"
        
    except Prescription.DoesNotExist:
        logger.error(f"Prescription {prescription_id} not found")
        return f"Prescription {prescription_id} not found"
        
    except Exception as e:
        logger.error(f"Error processing prescription {prescription_id}: {str(e)}")
        
        # Update prescription status to failed
        try:
            prescription = Prescription.objects.get(id=prescription_id)
            prescription.processing_status = 'failed'
            prescription.save()
        except:
            pass
        
        return f"Error processing prescription {prescription_id}: {str(e)}"


@shared_task
def update_user_analytics(user_id):
    """
    Background task to update user analytics
    """
    try:
        user = User.objects.get(id=user_id)
        from .models import PrescriptionAnalytics
        
        analytics, created = PrescriptionAnalytics.objects.get_or_create(user=user)
        analytics.update_analytics()
        
        logger.info(f"Analytics updated for user {user_id}")
        return f"Analytics updated for user {user_id}"
        
    except User.DoesNotExist:
        logger.error(f"User {user_id} not found")
        return f"User {user_id} not found"
        
    except Exception as e:
        logger.error(f"Error updating analytics for user {user_id}: {str(e)}")
        return f"Error updating analytics for user {user_id}: {str(e)}"


@shared_task
def cleanup_old_prescription_images():
    """
    Background task to cleanup old prescription images (optional)
    """
    # Implementation for cleaning up old images if needed
    pass
