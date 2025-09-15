# Disease Prediction API

This API provides disease outbreak predictions using a trained XGBoost model based on environmental and health indicators for Delhi.

## Features

- Single prediction endpoint
- Batch prediction endpoint  
- Health check endpoint
- Info endpoint with available locations and weeks
- Comprehensive error handling
- JSON request/response format
- Probability scores for all disease classes

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Ensure the model file `xgb_disease_prediction_model.pkl` and data file `delhi_disease_data_10000.csv` are in the project directory

3. Run the API:
```bash
python app.py
```
Or use the provided script:
```bash
./start_server.sh
```

The API will be available at `http://localhost:5001`

## API Endpoints

### 1. Health Check
- **URL:** `/health`
- **Method:** GET
- **Description:** Check if the API is running and model is loaded

**Response:**
```json
{
  "status": "healthy",
  "model_loaded": true,
  "timestamp": "2025-07-16T10:30:00"
}
```

### 2. Info
- **URL:** `/info`
- **Method:** GET
- **Description:** Get available locations, weeks, and possible predictions

**Response:**
```json
{
  "available_locations": ["Karol Bagh", "Chanakyapuri", "..."],
  "available_weeks": ["2025-W01", "2025-W02", "..."],
  "possible_predictions": ["Dengue", "Typhoid", "Malaria", "Healthy", "Other"],
  "model_features": ["Week", "Location", "NDVI", "WaterIndex", "Rainfall_mm", "Humidity_pct", "FeverCases", "Absenteeism_pct", "ToiletUsage_pct"]
}
```

### 3. Single Prediction
- **URL:** `/predict`
- **Method:** POST
- **Description:** Make a single disease outbreak prediction

**Request Body:**
```json
{
  "Week": 25,
  "Location": 1,
  "NDVI": 0.5,
  "WaterIndex": 0.3,
  "Rainfall_mm": 15.5,
  "Humidity_pct": 65.0,
  "FeverCases": 8,
  "Absenteeism_pct": 12.5,
  "ToiletUsage_pct": 85.0
}
```

**Response:**
```json
{
  "prediction": "Low",
  "probabilities": {
    "High": 0.1,
    "Low": 0.8,
    "Medium": 0.1
  },
  "input_data": { ... },
  "timestamp": "2025-07-15T10:30:00"
}
```

### 3. Batch Prediction
- **URL:** `/predict/batch`
- **Method:** POST
- **Description:** Make predictions for multiple records

**Request Body:**
```json
{
  "data": [
    {
      "Week": 25,
      "Location": 1,
      "NDVI": 0.5,
      "WaterIndex": 0.3,
      "Rainfall_mm": 15.5,
      "Humidity_pct": 65.0,
      "FeverCases": 8,
      "Absenteeism_pct": 12.5,
      "ToiletUsage_pct": 85.0
    },
    {
      "Week": 26,
      "Location": 2,
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
```

**Response:**
```json
{
  "results": [
    {
      "record_index": 0,
      "prediction": "Low",
      "probabilities": {
        "High": 0.1,
        "Low": 0.8,
        "Medium": 0.1
      },
      "input_data": { ... }
    },
    {
      "record_index": 1,
      "prediction": "Medium",
      "probabilities": {
        "High": 0.3,
        "Low": 0.2,
        "Medium": 0.5
      },
      "input_data": { ... }
    }
  ],
  "total_records": 2,
  "timestamp": "2025-07-15T10:30:00"
}
```

## Required Input Features

All prediction endpoints require the following features:

- **Week**: Week number (integer)
- **Location**: Location identifier (integer)
- **NDVI**: Normalized Difference Vegetation Index (float, 0-1)
- **WaterIndex**: Water availability index (float, 0-1)
- **Rainfall_mm**: Rainfall in millimeters (float)
- **Humidity_pct**: Humidity percentage (float, 0-100)
- **FeverCases**: Number of fever cases (integer)
- **Absenteeism_pct**: Absenteeism percentage (float, 0-100)
- **ToiletUsage_pct**: Toilet usage percentage (float, 0-100)

## Testing

Run the test script to verify the API:

```bash
python test_api.py
```

Make sure the API is running before executing the test script.

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- **400 Bad Request**: Missing or invalid input data
- **500 Internal Server Error**: Model loading or prediction errors
- **404 Not Found**: Invalid endpoint

## Example Usage with curl

```bash
# Health check
curl -X GET http://localhost:5000/health

# Single prediction
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "Week": 25,
    "Location": 1,
    "NDVI": 0.5,
    "WaterIndex": 0.3,
    "Rainfall_mm": 15.5,
    "Humidity_pct": 65.0,
    "FeverCases": 8,
    "Absenteeism_pct": 12.5,
    "ToiletUsage_pct": 85.0
  }'
```

## Model Information

The API uses an XGBoost model trained on disease outbreak data with environmental and health indicators. The model predicts outbreak levels: High, Medium, or Low.
