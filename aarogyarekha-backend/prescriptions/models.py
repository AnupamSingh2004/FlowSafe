import os
import uuid
from django.db import models
from django.contrib.auth import get_user_model
from django.core.validators import FileExtensionValidator
from PIL import Image

User = get_user_model()


def prescription_upload_path(instance, filename):
    """Generate upload path for prescription images"""
    ext = filename.split('.')[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    return os.path.join('prescriptions', str(instance.user.id), filename)


class Prescription(models.Model):
    """Model for storing prescription information"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='prescriptions')
    title = models.CharField(max_length=200, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    doctor_name = models.CharField(max_length=100, blank=True, null=True)
    hospital_name = models.CharField(max_length=200, blank=True, null=True)
    prescription_date = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_processed = models.BooleanField(default=False)
    processing_status = models.CharField(
        max_length=20,
        choices=[
            ('pending', 'Pending'),
            ('processing', 'Processing'),
            ('completed', 'Completed'),
            ('failed', 'Failed'),
        ],
        default='pending'
    )

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Prescription {self.id} - {self.user.username}"

    @property
    def total_medicines(self):
        return self.medicines.count()

    @property
    def estimated_total_cost(self):
        return sum(med.estimated_cost or 0 for med in self.medicines.all())


class PrescriptionImage(models.Model):
    """Model for storing prescription images with OCR processing"""
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='images')
    original_image = models.ImageField(
        upload_to=prescription_upload_path,
        validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png', 'pdf'])]
    )
    compressed_image = models.ImageField(upload_to=prescription_upload_path, blank=True, null=True)
    processed_image = models.ImageField(upload_to=prescription_upload_path, blank=True, null=True)
    
    # OCR Results
    extracted_text = models.TextField(blank=True, null=True)
    confidence_score = models.FloatField(default=0.0)
    
    # Image metadata
    file_size = models.IntegerField(default=0)  # in bytes
    width = models.IntegerField(default=0)
    height = models.IntegerField(default=0)
    format = models.CharField(max_length=10, blank=True, null=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        if self.original_image:
            # Get image metadata
            img = Image.open(self.original_image)
            self.width, self.height = img.size
            self.format = img.format
            self.file_size = self.original_image.size
            
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Image for Prescription {self.prescription.id}"


class Medicine(models.Model):
    """Model for storing extracted medicine information"""
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='medicines')
    name = models.CharField(max_length=200)
    generic_name = models.CharField(max_length=200, blank=True, null=True)
    dosage = models.CharField(max_length=100, blank=True, null=True)
    frequency = models.CharField(max_length=100, blank=True, null=True)
    duration = models.CharField(max_length=100, blank=True, null=True)
    quantity = models.CharField(max_length=50, blank=True, null=True)
    instructions = models.TextField(blank=True, null=True)
    
    # Pricing information
    estimated_cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    generic_available = models.BooleanField(default=False)
    generic_cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    
    # Extraction confidence
    extraction_confidence = models.FloatField(default=0.0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} - {self.dosage}"

    @property
    def potential_savings(self):
        if self.estimated_cost and self.generic_cost:
            return self.estimated_cost - self.generic_cost
        return 0


class PrescriptionAnalytics(models.Model):
    """Model for tracking user prescription analytics"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='prescription_analytics')
    total_prescriptions = models.IntegerField(default=0)
    total_medicines_searched = models.IntegerField(default=0)
    total_savings = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    stores_visited = models.IntegerField(default=0)
    schemes_applied = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Analytics for {self.user.username}"

    def update_analytics(self):
        """Update analytics based on user's prescriptions"""
        prescriptions = self.user.prescriptions.all()
        self.total_prescriptions = prescriptions.count()
        
        medicines = Medicine.objects.filter(prescription__user=self.user)
        self.total_medicines_searched = medicines.count()
        
        # Calculate total savings from generic alternatives
        total_savings = sum(med.potential_savings for med in medicines if med.potential_savings > 0)
        self.total_savings = total_savings
        
        self.save()
