#!/bin/bash

# Disease Prediction Service Startup Script
# This script handles the startup of the ML prediction service in Docker

echo "Starting Disease Prediction Service..."
echo "========================================"

# Check if required files exist
if [ ! -f "xgb_disease_prediction_model.pkl" ]; then
    echo "Error: Model file 'xgb_disease_prediction_model.pkl' not found!"
    echo "Please ensure the model file is present in the container."
    exit 1
fi

if [ ! -f "delhi_disease_data_10000.csv" ]; then
    echo "Error: Data file 'delhi_disease_data_10000.csv' not found!"
    echo "Please ensure the data file is present in the container."
    exit 1
fi

# Create logs directory if it doesn't exist
mkdir -p /app/logs

# Set environment variables
export FLASK_APP=app.py
export FLASK_ENV=${FLASK_ENV:-production}
export PYTHONPATH=/app

# Start the Flask application
echo "Starting Flask ML service on port 5001..."
echo "Health check available at: http://localhost:5001/health"
echo "========================================"

# Run the application
python app.py
