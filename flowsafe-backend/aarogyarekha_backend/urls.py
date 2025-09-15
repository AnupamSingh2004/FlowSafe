from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

# Import prediction proxy views
from prediction_proxy import (
    predict_disease, predict_batch, prediction_info, prediction_health_check
)

@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def health_check(request):
    """Health check endpoint"""
    return Response({'status': 'ok', 'message': 'AarogyaRekha API is running'})

@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def simple_test(request):
    """Simple test endpoint that doesn't require database"""
    import os
    return Response({
        'status': 'success',
        'message': 'Django is working!',
        'environment': 'Azure' if os.getenv('AZURE_APP_SERVICE') else 'Development',
        'database_host': os.getenv('DATABASE_HOST', 'Not set'),
        'debug': os.getenv('DEBUG', 'Not set')
    })

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/auth/', include('authentication.urls')),
    path('api/prescriptions/', include('prescriptions.urls')),
    path('api/health/', health_check, name='health_check'),
    path('api/test/', simple_test, name='simple_test'),
    path('accounts/', include('allauth.urls')),
    
    # Prediction proxy endpoints
    path('api/predict/', predict_disease, name='predict_disease'),
    path('api/predict/batch/', predict_batch, name='predict_batch'),
    path('api/predict/info/', prediction_info, name='prediction_info'),
    path('api/predict/health/', prediction_health_check, name='prediction_health_check'),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)