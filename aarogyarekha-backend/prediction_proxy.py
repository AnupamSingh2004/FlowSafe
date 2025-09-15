"""
Prediction Proxy View for Django Backend
Forwards prediction requests to Flask ML service
"""

import requests
import json
import os
from django.conf import settings
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
import logging

logger = logging.getLogger(__name__)

# Flask ML service URL - use Docker service name when in containers
FLASK_ML_SERVICE_URL = os.getenv('PREDICTION_SERVICE_URL', "http://prediction-service:5001")

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def predict_disease(request):
    """
    Proxy endpoint for disease prediction
    Forwards requests to Flask ML service
    """
    try:
        # Forward request to Flask service
        response = requests.post(
            f"{FLASK_ML_SERVICE_URL}/predict",
            json=request.data,
            headers={'Content-Type': 'application/json'},
            timeout=30
        )
        
        if response.status_code == 200:
            return Response(response.json(), status=status.HTTP_200_OK)
        else:
            return Response({
                'error': 'Prediction service unavailable',
                'details': response.text
            }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Error calling prediction service: {str(e)}")
        return Response({
            'error': 'Failed to connect to prediction service',
            'details': str(e)
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
    except Exception as e:
        logger.error(f"Unexpected error in prediction proxy: {str(e)}")
        return Response({
            'error': 'Internal server error',
            'details': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def predict_batch(request):
    """
    Proxy endpoint for batch disease prediction
    """
    try:
        response = requests.post(
            f"{FLASK_ML_SERVICE_URL}/predict/batch",
            json=request.data,
            headers={'Content-Type': 'application/json'},
            timeout=60
        )
        
        if response.status_code == 200:
            return Response(response.json(), status=status.HTTP_200_OK)
        else:
            return Response({
                'error': 'Prediction service unavailable',
                'details': response.text
            }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Error calling batch prediction service: {str(e)}")
        return Response({
            'error': 'Failed to connect to prediction service',
            'details': str(e)
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def prediction_info(request):
    """
    Get prediction model information
    """
    try:
        response = requests.get(
            f"{FLASK_ML_SERVICE_URL}/info",
            timeout=10
        )
        
        if response.status_code == 200:
            return Response(response.json(), status=status.HTTP_200_OK)
        else:
            return Response({
                'error': 'Prediction service unavailable'
            }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            
    except requests.exceptions.RequestException as e:
        logger.error(f"Error getting prediction info: {str(e)}")
        return Response({
            'error': 'Failed to connect to prediction service'
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)

@api_view(['GET'])
@permission_classes([])
def prediction_health_check(request):
    """
    Health check for prediction service
    """
    try:
        response = requests.get(
            f"{FLASK_ML_SERVICE_URL}/health",
            timeout=5
        )
        
        if response.status_code == 200:
            return Response({
                'status': 'healthy',
                'prediction_service': response.json()
            }, status=status.HTTP_200_OK)
        else:
            return Response({
                'status': 'unhealthy',
                'error': 'Prediction service not responding'
            }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
            
    except requests.exceptions.RequestException as e:
        return Response({
            'status': 'unhealthy',
            'error': f'Cannot connect to prediction service: {str(e)}'
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
