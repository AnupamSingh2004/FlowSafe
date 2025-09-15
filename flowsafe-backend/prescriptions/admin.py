from django.contrib import admin
from .models import Prescription, PrescriptionImage, Medicine, PrescriptionAnalytics


@admin.register(Prescription)
class PrescriptionAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'user', 'title', 'doctor_name', 'prescription_date', 
        'processing_status', 'total_medicines', 'created_at'
    ]
    list_filter = ['processing_status', 'is_processed', 'created_at']
    search_fields = ['title', 'doctor_name', 'hospital_name', 'user__username', 'user__email']
    readonly_fields = ['created_at', 'updated_at', 'total_medicines', 'estimated_total_cost']
    
    fieldsets = (
        ('Basic Information', {
            'fields': ('user', 'title', 'description')
        }),
        ('Prescription Details', {
            'fields': ('doctor_name', 'hospital_name', 'prescription_date')
        }),
        ('Processing Status', {
            'fields': ('is_processed', 'processing_status')
        }),
        ('Analytics', {
            'fields': ('total_medicines', 'estimated_total_cost'),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )


@admin.register(PrescriptionImage)
class PrescriptionImageAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'prescription', 'confidence_score', 'file_size', 
        'width', 'height', 'format', 'created_at'
    ]
    list_filter = ['format', 'created_at']
    search_fields = ['prescription__title', 'prescription__user__username']
    readonly_fields = [
        'file_size', 'width', 'height', 'format', 'confidence_score',
        'created_at', 'updated_at'
    ]
    
    fieldsets = (
        ('Images', {
            'fields': ('prescription', 'original_image', 'compressed_image', 'processed_image')
        }),
        ('OCR Results', {
            'fields': ('extracted_text', 'confidence_score')
        }),
        ('Image Metadata', {
            'fields': ('file_size', 'width', 'height', 'format'),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )


@admin.register(Medicine)
class MedicineAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'name', 'dosage', 'prescription', 'estimated_cost', 
        'generic_available', 'potential_savings', 'extraction_confidence'
    ]
    list_filter = ['generic_available', 'created_at']
    search_fields = ['name', 'generic_name', 'prescription__title']
    readonly_fields = ['potential_savings', 'created_at', 'updated_at']
    
    fieldsets = (
        ('Medicine Information', {
            'fields': ('prescription', 'name', 'generic_name', 'dosage')
        }),
        ('Usage Instructions', {
            'fields': ('frequency', 'duration', 'quantity', 'instructions')
        }),
        ('Pricing', {
            'fields': ('estimated_cost', 'generic_available', 'generic_cost', 'potential_savings')
        }),
        ('Extraction Details', {
            'fields': ('extraction_confidence',),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )


@admin.register(PrescriptionAnalytics)
class PrescriptionAnalyticsAdmin(admin.ModelAdmin):
    list_display = [
        'user', 'total_prescriptions', 'total_medicines_searched', 
        'total_savings', 'stores_visited', 'schemes_applied', 'updated_at'
    ]
    search_fields = ['user__username', 'user__email']
    readonly_fields = ['created_at', 'updated_at']
    
    fieldsets = (
        ('User', {
            'fields': ('user',)
        }),
        ('Statistics', {
            'fields': (
                'total_prescriptions', 'total_medicines_searched', 
                'total_savings', 'stores_visited', 'schemes_applied'
            )
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    
    actions = ['update_analytics']
    
    def update_analytics(self, request, queryset):
        """Admin action to update analytics"""
        for analytics in queryset:
            analytics.update_analytics()
        self.message_user(request, f"Updated analytics for {queryset.count()} users.")
    
    update_analytics.short_description = "Update selected analytics"
