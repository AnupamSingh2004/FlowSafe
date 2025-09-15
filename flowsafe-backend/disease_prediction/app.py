from flask import Flask, request, jsonify
import joblib
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
import os
import logging
from datetime import datetime

# Configure logging
log_level = logging.INFO if os.getenv('DEBUG', 'False').lower() == 'true' else logging.WARNING
logging.basicConfig(
    level=log_level,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/app/logs/prediction_service.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configure Flask app
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

# Global variables for model and encoders
model = None
label_encoders = None
le_disease = None
available_locations = None
available_weeks = None

def load_model_and_encoders():
    """Load the trained model and prepare encoders"""
    global model, label_encoders, le_disease, available_locations, available_weeks
    
    try:
        # Load the trained model
        model_path = "xgb_disease_prediction_model.pkl"
        if not os.path.exists(model_path):
            raise FileNotFoundError(f"Model file {model_path} not found")
        
        model = joblib.load(model_path)
        logger.info("Model loaded successfully")
        
        # Load original data to get encoder information
        df = pd.read_csv('delhi_disease_data_10000.csv')
        
        # Create disease labels based on the same logic used in training
        def assign_disease(row):
            # Primary conditions for specific diseases
            if row['Rainfall_mm'] > 100 and row['FeverCases'] > 25:
                return 'Dengue'
            elif row['Humidity_pct'] > 85 and row['ToiletUsage_pct'] < 75:
                return 'Typhoid'
            elif row['WaterIndex'] > 0.6 and row['NDVI'] < 0.4:
                return 'Malaria'
            elif row['FeverCases'] < 10 and row['Absenteeism_pct'] < 5:
                return 'Healthy'
            
            # Secondary conditions - more relaxed criteria to avoid "Other"
            elif row['Rainfall_mm'] > 50 and row['FeverCases'] > 15:
                return 'Dengue'
            elif row['Humidity_pct'] > 70 and row['ToiletUsage_pct'] < 80:
                return 'Typhoid'
            elif row['WaterIndex'] > 0.4 and row['NDVI'] < 0.5:
                return 'Malaria'
            elif row['FeverCases'] < 15 and row['Absenteeism_pct'] < 10:
                return 'Healthy'
            
            # Tertiary conditions - even more relaxed to capture remaining cases
            elif row['FeverCases'] > 20 or row['Rainfall_mm'] > 75:
                return 'Dengue'
            elif row['Humidity_pct'] > 80 or row['ToiletUsage_pct'] < 70:
                return 'Typhoid'
            elif row['WaterIndex'] > 0.5 or row['NDVI'] < 0.6:
                return 'Malaria'
            else:
                return 'Healthy'  # Default to Healthy instead of Other
        
        df['Disease'] = df.apply(assign_disease, axis=1)
        
        # Recreate the label encoders used during training
        label_encoders = {}
        for col in ['Week', 'Location']:
            le = LabelEncoder()
            le.fit(df[col])
            label_encoders[col] = le
        
        # Disease label encoder
        le_disease = LabelEncoder()
        le_disease.fit(df['Disease'])
        
        # Store available values
        available_locations = sorted(df['Location'].unique().tolist())
        available_weeks = sorted(df['Week'].unique().tolist())
        
        logger.info("Encoders initialized successfully")
        
    except Exception as e:
        logger.error(f"Error loading model and encoders: {str(e)}")
        raise

def preprocess_input(data):
    """Preprocess input data for prediction"""
    try:
        # Create DataFrame from input
        df = pd.DataFrame([data])
        
        # Encode categorical features
        for col in ['Week', 'Location']:
            if col in df.columns:
                if col in label_encoders:
                    # Handle unseen categories
                    try:
                        df[col] = label_encoders[col].transform(df[col])
                    except ValueError:
                        # If unseen category, use the most common one
                        df[col] = 0  # Default to first category
                        logger.warning(f"Unseen category in {col}, using default")
        
        # Ensure correct column order (same as training)
        expected_columns = ['Week', 'Location', 'NDVI', 'WaterIndex', 'Rainfall_mm', 
                          'Humidity_pct', 'FeverCases', 'Absenteeism_pct', 'ToiletUsage_pct']
        
        # Reorder columns
        df = df[expected_columns]
        
        return df
        
    except Exception as e:
        logger.error(f"Error preprocessing input: {str(e)}")
        raise

# Initialize model and encoders when app starts
load_model_and_encoders()

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    try:
        return jsonify({
            "status": "healthy",
            "service": "disease-prediction-ml",
            "version": "1.0.0",
            "model_loaded": model is not None,
            "encoders_loaded": label_encoders is not None,
            "available_locations": len(available_locations) if available_locations else 0,
            "available_weeks": len(available_weeks) if available_weeks else 0,
            "timestamp": datetime.now().isoformat(),
            "environment": os.getenv('FLASK_ENV', 'production')
        }), 200
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return jsonify({
            "status": "unhealthy",
            "error": str(e),
            "timestamp": datetime.now().isoformat()
        }), 500

@app.route('/info', methods=['GET'])
def info():
    """Get information about available locations, weeks, and possible predictions"""
    return jsonify({
        "available_locations": available_locations,
        "available_weeks": available_weeks,
        "possible_predictions": le_disease.classes_.tolist(),
        "model_features": ['Week', 'Location', 'NDVI', 'WaterIndex', 'Rainfall_mm', 
                          'Humidity_pct', 'FeverCases', 'Absenteeism_pct', 'ToiletUsage_pct']
    })

@app.route('/predict', methods=['POST'])
def predict():
    """Single prediction endpoint"""
    try:
        # Get JSON data
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "No data provided"}), 400
        
        # Validate required fields
        required_fields = ['Week', 'Location', 'NDVI', 'WaterIndex', 'Rainfall_mm', 
                          'Humidity_pct', 'FeverCases', 'Absenteeism_pct', 'ToiletUsage_pct']
        
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({"error": f"Missing required fields: {missing_fields}"}), 400
        
        # Preprocess input
        processed_data = preprocess_input(data)
        
        # Make prediction
        prediction = model.predict(processed_data)[0]
        prediction_proba = model.predict_proba(processed_data)[0]
        
        # Convert prediction back to disease name
        disease_name = le_disease.inverse_transform([prediction])[0]
        
        # Create probability dictionary
        probabilities = {}
        for i, class_name in enumerate(le_disease.classes_):
            probabilities[class_name] = float(prediction_proba[i])
        
        return jsonify({
            "prediction": disease_name,
            "confidence": float(max(prediction_proba)),
            "probabilities": probabilities,
            "input_data": data
        })
        
    except Exception as e:
        logger.error(f"Error during prediction: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/predict/batch', methods=['POST'])
def predict_batch():
    """Batch prediction endpoint"""
    try:
        # Get JSON data
        request_data = request.get_json()
        
        if not request_data or 'data' not in request_data:
            return jsonify({"error": "No data provided or missing 'data' field"}), 400
        
        data_list = request_data['data']
        
        if not isinstance(data_list, list):
            return jsonify({"error": "Data must be a list"}), 400
        
        results = []
        
        for i, data in enumerate(data_list):
            try:
                # Validate required fields
                required_fields = ['Week', 'Location', 'NDVI', 'WaterIndex', 'Rainfall_mm', 
                                  'Humidity_pct', 'FeverCases', 'Absenteeism_pct', 'ToiletUsage_pct']
                
                missing_fields = [field for field in required_fields if field not in data]
                if missing_fields:
                    results.append({
                        "index": i,
                        "error": f"Missing required fields: {missing_fields}",
                        "input_data": data
                    })
                    continue
                
                # Preprocess input
                processed_data = preprocess_input(data)
                
                # Make prediction
                prediction = model.predict(processed_data)[0]
                prediction_proba = model.predict_proba(processed_data)[0]
                
                # Convert prediction back to disease name
                disease_name = le_disease.inverse_transform([prediction])[0]
                
                # Create probability dictionary
                probabilities = {}
                for j, class_name in enumerate(le_disease.classes_):
                    probabilities[class_name] = float(prediction_proba[j])
                
                results.append({
                    "index": i,
                    "prediction": disease_name,
                    "confidence": float(max(prediction_proba)),
                    "probabilities": probabilities,
                    "input_data": data
                })
                
            except Exception as e:
                results.append({
                    "index": i,
                    "error": str(e),
                    "input_data": data
                })
        
        return jsonify({
            "results": results,
            "total_predictions": len(results),
            "successful_predictions": len([r for r in results if "error" not in r])
        })
        
    except Exception as e:
        logger.error(f"Error during batch prediction: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Endpoint not found"}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Internal server error"}), 500

if __name__ == '__main__':
    try:
        # Ensure model is loaded before starting server
        if model is None:
            logger.error("Model failed to load. Exiting.")
            exit(1)
        
        debug_mode = os.getenv('DEBUG', 'False').lower() == 'true'
        port = int(os.getenv('PORT', 5001))
        
        logger.info(f"Starting Flask ML service on port {port}")
        logger.info(f"Debug mode: {debug_mode}")
        logger.info(f"Model loaded: {model is not None}")
        logger.info(f"Available locations: {len(available_locations) if available_locations else 0}")
        
        app.run(debug=debug_mode, host='0.0.0.0', port=port)
    except Exception as e:
        logger.error(f"Failed to start application: {str(e)}")
        exit(1)
