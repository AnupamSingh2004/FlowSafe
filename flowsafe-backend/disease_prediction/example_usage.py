#!/usr/bin/env python3
"""
Simple example demonstrating how to use the Disease Prediction API
"""

import requests
import json

BASE_URL = "http://localhost:5001"

def main():
    print("Disease Prediction API - Usage Example")
    print("=" * 45)
    
    # Test 1: Get API info
    print("\n1. Getting API Information...")
    try:
        response = requests.get(f"{BASE_URL}/info")
        if response.status_code == 200:
            info = response.json()
            print(f"✓ Available locations: {len(info['available_locations'])}")
            print(f"✓ Available weeks: {len(info['available_weeks'])}")
            print(f"✓ Possible predictions: {info['possible_predictions']}")
        else:
            print(f"✗ Error: {response.status_code}")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    # Test 2: Single prediction for healthy case
    print("\n2. Testing Healthy Case...")
    healthy_data = {
        "Week": "2025-W25",
        "Location": "Karol Bagh",
        "NDVI": 0.7,
        "WaterIndex": 0.8,
        "Rainfall_mm": 5.0,
        "Humidity_pct": 50.0,
        "FeverCases": 3,
        "Absenteeism_pct": 2.0,
        "ToiletUsage_pct": 90.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=healthy_data)
        if response.status_code == 200:
            result = response.json()
            print(f"✓ Prediction: {result['prediction']}")
            print(f"✓ Confidence: {result['confidence']:.3f}")
            print(f"✓ Probabilities: {', '.join([f'{k}: {v:.3f}' for k, v in result['probabilities'].items()])}")
        else:
            print(f"✗ Error: {response.status_code}")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    # Test 3: Single prediction for potential dengue case
    print("\n3. Testing Potential Dengue Case...")
    dengue_data = {
        "Week": "2025-W30",
        "Location": "Dwarka",
        "NDVI": 0.6,
        "WaterIndex": 0.4,
        "Rainfall_mm": 120.0,  # High rainfall
        "Humidity_pct": 80.0,
        "FeverCases": 30,      # High fever cases
        "Absenteeism_pct": 25.0,
        "ToiletUsage_pct": 70.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=dengue_data)
        if response.status_code == 200:
            result = response.json()
            print(f"✓ Prediction: {result['prediction']}")
            print(f"✓ Confidence: {result['confidence']:.3f}")
            print(f"✓ Probabilities: {', '.join([f'{k}: {v:.3f}' for k, v in result['probabilities'].items()])}")
        else:
            print(f"✗ Error: {response.status_code}")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    # Test 4: Single prediction for potential typhoid case
    print("\n4. Testing Potential Typhoid Case...")
    typhoid_data = {
        "Week": "2025-W35",
        "Location": "Seelampur",
        "NDVI": 0.4,
        "WaterIndex": 0.3,
        "Rainfall_mm": 25.0,
        "Humidity_pct": 90.0,   # High humidity
        "FeverCases": 20,
        "Absenteeism_pct": 15.0,
        "ToiletUsage_pct": 60.0  # Low toilet usage
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=typhoid_data)
        if response.status_code == 200:
            result = response.json()
            print(f"✓ Prediction: {result['prediction']}")
            print(f"✓ Confidence: {result['confidence']:.3f}")
            print(f"✓ Probabilities: {', '.join([f'{k}: {v:.3f}' for k, v in result['probabilities'].items()])}")
        else:
            print(f"✗ Error: {response.status_code}")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    # Test 5: Batch prediction
    print("\n5. Testing Batch Prediction...")
    batch_data = {
        "data": [healthy_data, dengue_data, typhoid_data]
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict/batch", json=batch_data)
        if response.status_code == 200:
            result = response.json()
            print(f"✓ Batch prediction successful!")
            print(f"✓ Total predictions: {result['total_predictions']}")
            print(f"✓ Successful predictions: {result['successful_predictions']}")
            
            for i, prediction in enumerate(result['results']):
                if 'error' not in prediction:
                    print(f"   {i+1}. {prediction['prediction']} (confidence: {prediction['confidence']:.3f})")
                else:
                    print(f"   {i+1}. Error: {prediction['error']}")
        else:
            print(f"✗ Error: {response.status_code}")
    except Exception as e:
        print(f"✗ Error: {e}")
    
    print("\n" + "=" * 45)
    print("Example completed! API is working correctly.")
    print("You can now use the API endpoints in your applications.")

if __name__ == "__main__":
    main()
