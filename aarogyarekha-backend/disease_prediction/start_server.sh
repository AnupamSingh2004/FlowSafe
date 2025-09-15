#!/bin/bash

# Disease Prediction API Server
# This script starts the Flask API server for disease prediction

echo "Starting Disease Prediction API Server..."
echo "========================================"

# Check if required files exist
if [ ! -f "xgb_disease_prediction_model.pkl" ]; then
    echo "Error: Model file 'xgb_disease_prediction_model.pkl' not found!"
    echo "Please run the Predictive_model.ipynb notebook first to train and save the model."
    exit 1
fi

if [ ! -f "delhi_disease_data_10000.csv" ]; then
    echo "Error: Data file 'delhi_disease_data_10000.csv' not found!"
    exit 1
fi

# Install requirements if needed
echo "Installing requirements..."
pip install -r requirements.txt

# Start the Flask server
echo "Starting Flask server on http://localhost:5001"
echo "Press Ctrl+C to stop the server"
echo "========================================"

python app.py
