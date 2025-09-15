import requests
import json

# API base URL
BASE_URL = "http://localhost:5001"

def test_api():
    print("Testing Disease Prediction API")
    print("=" * 40)
    
    # Test 1: Health check
    print("\n1. Testing health endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/health")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 2: Single prediction
    print("\n2. Testing single prediction...")
    sample_data = {
        "Week": "2025-W25",
        "Location": "Karol Bagh",
        "NDVI": 0.5,
        "WaterIndex": 0.3,
        "Rainfall_mm": 15.5,
        "Humidity_pct": 65.0,
        "FeverCases": 8,
        "Absenteeism_pct": 12.5,
        "ToiletUsage_pct": 85.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=sample_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 3: Batch prediction
    print("\n3. Testing batch prediction...")
    batch_data = {
        "data": [
            {
                "Week": "2025-W25",
                "Location": "Karol Bagh",
                "NDVI": 0.5,
                "WaterIndex": 0.3,
                "Rainfall_mm": 15.5,
                "Humidity_pct": 65.0,
                "FeverCases": 8,
                "Absenteeism_pct": 12.5,
                "ToiletUsage_pct": 85.0
            },
            {
                "Week": "2025-W26",
                "Location": "Chanakyapuri",
                "NDVI": 0.7,
                "WaterIndex": 0.4,
                "Rainfall_mm": 20.0,
                "Humidity_pct": 70.0,
                "FeverCases": 15,
                "Absenteeism_pct": 18.0,
                "ToiletUsage_pct": 75.0
            }
        ]
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict/batch", json=batch_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")

def test_disease_specific_scenarios():
    print("\n" + "=" * 50)
    print("TESTING DISEASE-SPECIFIC SCENARIOS")
    print("=" * 50)
    
    # Test 4: Dengue scenario (High rainfall + high fever cases)
    print("\n4. Testing potential Dengue scenario...")
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
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
            print(f"Top probabilities: {sorted(result['probabilities'].items(), key=lambda x: x[1], reverse=True)[:3]}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 5: Typhoid scenario (High humidity + low toilet usage)
    print("\n5. Testing potential Typhoid scenario...")
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
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
            print(f"Top probabilities: {sorted(result['probabilities'].items(), key=lambda x: x[1], reverse=True)[:3]}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 6: Malaria scenario (High water index + low NDVI)
    print("\n6. Testing potential Malaria scenario...")
    malaria_data = {
        "Week": "2025-W40",
        "Location": "Najafgarh",
        "NDVI": 0.3,            # Low NDVI
        "WaterIndex": 0.7,      # High water index
        "Rainfall_mm": 45.0,
        "Humidity_pct": 75.0,
        "FeverCases": 18,
        "Absenteeism_pct": 20.0,
        "ToiletUsage_pct": 80.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=malaria_data)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
            print(f"Top probabilities: {sorted(result['probabilities'].items(), key=lambda x: x[1], reverse=True)[:3]}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 7: Healthy scenario (Low fever + low absenteeism)
    print("\n7. Testing Healthy scenario...")
    healthy_data = {
        "Week": "2025-W28",
        "Location": "Greater Kailash",
        "NDVI": 0.8,
        "WaterIndex": 0.9,
        "Rainfall_mm": 8.0,
        "Humidity_pct": 55.0,
        "FeverCases": 5,        # Low fever cases
        "Absenteeism_pct": 3.0, # Low absenteeism
        "ToiletUsage_pct": 95.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=healthy_data)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
            print(f"Top probabilities: {sorted(result['probabilities'].items(), key=lambda x: x[1], reverse=True)[:3]}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")

def test_edge_cases():
    print("\n" + "=" * 50)
    print("TESTING EDGE CASES")
    print("=" * 50)
    
    # Test 8: Missing required fields
    print("\n8. Testing missing required fields...")
    incomplete_data = {
        "Week": "2025-W25",
        "Location": "Karol Bagh",
        "NDVI": 0.5,
        # Missing other required fields
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=incomplete_data)
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 9: Invalid location
    print("\n9. Testing invalid location...")
    invalid_location_data = {
        "Week": "2025-W25",
        "Location": "Invalid Location",
        "NDVI": 0.5,
        "WaterIndex": 0.3,
        "Rainfall_mm": 15.5,
        "Humidity_pct": 65.0,
        "FeverCases": 8,
        "Absenteeism_pct": 12.5,
        "ToiletUsage_pct": 85.0
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=invalid_location_data)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 10: Extreme values
    print("\n10. Testing extreme values...")
    extreme_data = {
        "Week": "2025-W25",
        "Location": "Karol Bagh",
        "NDVI": 1.0,           # Maximum NDVI
        "WaterIndex": 0.0,     # Minimum water index
        "Rainfall_mm": 200.0,  # Very high rainfall
        "Humidity_pct": 100.0, # Maximum humidity
        "FeverCases": 50,      # Very high fever cases
        "Absenteeism_pct": 50.0, # Very high absenteeism
        "ToiletUsage_pct": 0.0   # Minimum toilet usage
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=extreme_data)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Prediction: {result['prediction']}")
            print(f"Confidence: {result['confidence']:.3f}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 11: Empty request
    print("\n11. Testing empty request...")
    try:
        response = requests.post(f"{BASE_URL}/predict", json={})
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")

def test_info_endpoint():
    print("\n" + "=" * 50)
    print("TESTING INFO ENDPOINT")
    print("=" * 50)
    
    # Test 12: Info endpoint
    print("\n12. Testing info endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/info")
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"Available locations: {len(data['available_locations'])}")
            print(f"Sample locations: {data['available_locations'][:5]}")
            print(f"Available weeks: {len(data['available_weeks'])}")
            print(f"Sample weeks: {data['available_weeks'][:5]}")
            print(f"Possible predictions: {data['possible_predictions']}")
            print(f"Model features: {data['model_features']}")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")

def test_batch_edge_cases():
    print("\n" + "=" * 50)
    print("TESTING BATCH EDGE CASES")
    print("=" * 50)
    
    # Test 13: Empty batch
    print("\n13. Testing empty batch...")
    try:
        response = requests.post(f"{BASE_URL}/predict/batch", json={"data": []})
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 14: Mixed valid and invalid data in batch
    print("\n14. Testing mixed valid/invalid data in batch...")
    mixed_batch = {
        "data": [
            {
                "Week": "2025-W25",
                "Location": "Karol Bagh",
                "NDVI": 0.5,
                "WaterIndex": 0.3,
                "Rainfall_mm": 15.5,
                "Humidity_pct": 65.0,
                "FeverCases": 8,
                "Absenteeism_pct": 12.5,
                "ToiletUsage_pct": 85.0
            },
            {
                "Week": "2025-W26",
                "Location": "Chanakyapuri",
                # Missing required fields
                "NDVI": 0.7,
                "WaterIndex": 0.4
            },
            {
                "Week": "2025-W27",
                "Location": "Dwarka",
                "NDVI": 0.6,
                "WaterIndex": 0.5,
                "Rainfall_mm": 25.0,
                "Humidity_pct": 70.0,
                "FeverCases": 12,
                "Absenteeism_pct": 10.0,
                "ToiletUsage_pct": 80.0
            }
        ]
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict/batch", json=mixed_batch)
        print(f"Status Code: {response.status_code}")
        if response.status_code == 200:
            result = response.json()
            print(f"Total predictions: {result['total_predictions']}")
            print(f"Successful predictions: {result['successful_predictions']}")
            for i, res in enumerate(result['results']):
                if 'error' in res:
                    print(f"  Item {i}: Error - {res['error']}")
                else:
                    print(f"  Item {i}: {res['prediction']} (confidence: {res['confidence']:.3f})")
        else:
            print(f"Error Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")

def test_invalid_endpoints():
    print("\n" + "=" * 50)
    print("TESTING INVALID ENDPOINTS")
    print("=" * 50)
    
    # Test 15: Invalid endpoint
    print("\n15. Testing invalid endpoint...")
    try:
        response = requests.get(f"{BASE_URL}/invalid-endpoint")
        print(f"Status Code: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Test 16: Wrong HTTP method
    print("\n16. Testing wrong HTTP method...")
    try:
        response = requests.get(f"{BASE_URL}/predict")  # Should be POST
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.text}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_api()
    test_disease_specific_scenarios()
    test_edge_cases()
    test_info_endpoint()
    test_batch_edge_cases()
    test_invalid_endpoints()
    
    print("\n" + "=" * 50)
    print("ALL TESTS COMPLETED")
    print("=" * 50)
