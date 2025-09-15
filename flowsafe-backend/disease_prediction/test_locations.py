import requests
import json

BASE_URL = "http://localhost:5001"

def test_info_endpoint():
    """Test the info endpoint to get available locations"""
    print("=" * 50)
    print("TESTING INFO ENDPOINT")
    print("=" * 50)
    
    try:
        response = requests.get(f"{BASE_URL}/info")
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"\nAvailable Locations ({len(data['available_locations'])}):")
            for i, location in enumerate(data['available_locations'], 1):
                print(f"  {i:2d}. {location}")
            
            print(f"\nAvailable Weeks ({len(data['available_weeks'])}):")
            for i, week in enumerate(data['available_weeks'][:10], 1):  # Show first 10
                print(f"  {i:2d}. {week}")
            if len(data['available_weeks']) > 10:
                print(f"  ... and {len(data['available_weeks']) - 10} more")
            
            print(f"\nPossible Predictions: {data['possible_predictions']}")
            
            return data
        else:
            print(f"Error: {response.text}")
            return None
            
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_predictions_for_different_locations(locations):
    """Test predictions for different locations"""
    print("\n" + "=" * 50)
    print("TESTING PREDICTIONS FOR DIFFERENT LOCATIONS")
    print("=" * 50)
    
    # Base data template
    base_data = {
        "Week": "2025-W25",
        "NDVI": 0.5,
        "WaterIndex": 0.3,
        "Rainfall_mm": 15.5,
        "Humidity_pct": 65.0,
        "FeverCases": 8,
        "Absenteeism_pct": 12.5,
        "ToiletUsage_pct": 85.0
    }
    
    results = []
    
    for location in locations[:5]:  # Test first 5 locations
        print(f"\nTesting location: {location}")
        print("-" * 30)
        
        test_data = base_data.copy()
        test_data["Location"] = location
        
        try:
            response = requests.post(f"{BASE_URL}/predict", json=test_data)
            print(f"Status Code: {response.status_code}")
            
            if response.status_code == 200:
                result = response.json()
                prediction = result["prediction"]
                probabilities = result["probabilities"]
                
                print(f"Prediction: {prediction}")
                print("Probabilities:")
                for class_name, prob in probabilities.items():
                    print(f"  {class_name}: {prob:.3f}")
                
                results.append({
                    "location": location,
                    "prediction": prediction,
                    "probabilities": probabilities
                })
            else:
                print(f"Error: {response.text}")
                
        except Exception as e:
            print(f"Error: {e}")
    
    return results

def test_batch_predictions():
    """Test batch predictions with multiple locations"""
    print("\n" + "=" * 50)
    print("TESTING BATCH PREDICTIONS")
    print("=" * 50)
    
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
                "Week": "2025-W30",
                "Location": "Chanakyapuri",
                "NDVI": 0.7,
                "WaterIndex": 0.4,
                "Rainfall_mm": 20.0,
                "Humidity_pct": 70.0,
                "FeverCases": 15,
                "Absenteeism_pct": 18.0,
                "ToiletUsage_pct": 75.0
            },
            {
                "Week": "2025-W35",
                "Location": "Dwarka",
                "NDVI": 0.4,
                "WaterIndex": 0.6,
                "Rainfall_mm": 25.0,
                "Humidity_pct": 80.0,
                "FeverCases": 20,
                "Absenteeism_pct": 22.0,
                "ToiletUsage_pct": 70.0
            }
        ]
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict/batch", json=batch_data)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print(f"Total records processed: {result['total_records']}")
            
            for i, record_result in enumerate(result["results"]):
                print(f"\nRecord {i+1}:")
                print(f"  Location: {record_result['input_data']['Location']}")
                print(f"  Prediction: {record_result['prediction']}")
                print(f"  Probabilities:")
                for class_name, prob in record_result['probabilities'].items():
                    print(f"    {class_name}: {prob:.3f}")
        else:
            print(f"Error: {response.text}")
            
    except Exception as e:
        print(f"Error: {e}")

def test_high_risk_scenario():
    """Test a high risk scenario"""
    print("\n" + "=" * 50)
    print("TESTING HIGH RISK SCENARIO")
    print("=" * 50)
    
    high_risk_data = {
        "Week": "2025-W40",
        "Location": "Karol Bagh",
        "NDVI": 0.3,  # Low vegetation
        "WaterIndex": 0.8,  # High water index
        "Rainfall_mm": 100.0,  # High rainfall
        "Humidity_pct": 90.0,  # High humidity
        "FeverCases": 35,  # High fever cases
        "Absenteeism_pct": 25.0,  # High absenteeism
        "ToiletUsage_pct": 60.0  # Poor sanitation
    }
    
    try:
        response = requests.post(f"{BASE_URL}/predict", json=high_risk_data)
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print(f"High Risk Scenario Prediction: {result['prediction']}")
            print("Probabilities:")
            for class_name, prob in result['probabilities'].items():
                print(f"  {class_name}: {prob:.3f}")
        else:
            print(f"Error: {response.text}")
            
    except Exception as e:
        print(f"Error: {e}")

def main():
    print("DISEASE PREDICTION API TESTING")
    print("=" * 50)
    
    # Test info endpoint
    info_data = test_info_endpoint()
    
    if info_data:
        # Test predictions for different locations
        locations = info_data['available_locations']
        prediction_results = test_predictions_for_different_locations(locations)
        
        # Test batch predictions
        test_batch_predictions()
        
        # Test high risk scenario
        test_high_risk_scenario()
        
        # Summary
        print("\n" + "=" * 50)
        print("SUMMARY")
        print("=" * 50)
        print(f"Total locations available: {len(locations)}")
        print(f"Locations tested: {len(prediction_results)}")
        
        if prediction_results:
            print("\nPrediction distribution:")
            prediction_counts = {}
            for result in prediction_results:
                pred = result['prediction']
                prediction_counts[pred] = prediction_counts.get(pred, 0) + 1
            
            for pred, count in prediction_counts.items():
                print(f"  {pred}: {count} location(s)")

if __name__ == "__main__":
    main()
