from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    PrescriptionViewSet, MedicineViewSet, PrescriptionImageViewSet,
    PrescriptionUploadView, UserAnalyticsView
)

router = DefaultRouter()
router.register(r'prescriptions', PrescriptionViewSet, basename='prescription')
router.register(r'medicines', MedicineViewSet, basename='medicine')
router.register(r'images', PrescriptionImageViewSet, basename='prescription-image')

urlpatterns = [
    path('', include(router.urls)),
    
    # Dedicated upload endpoint
    path('upload/', PrescriptionUploadView.as_view(), name='prescription-upload'),
    
    # Analytics endpoint
    path('analytics/', UserAnalyticsView.as_view(), name='user-analytics'),
    
    # Additional endpoints
    path('prescriptions/<int:pk>/reprocess/', 
         PrescriptionViewSet.as_view({'post': 'reprocess'}), 
         name='prescription-reprocess'),
]
