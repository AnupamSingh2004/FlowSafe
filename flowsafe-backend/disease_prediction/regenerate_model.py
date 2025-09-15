#!/usr/bin/env python3
"""
Script to regenerate the ML model with compatible NumPy version
"""

import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import xgboost as xgb
import joblib
import os

def assign_disease(row):
    """Assign disease based on environmental and health factors"""
    # Primary conditions for specific diseases
    if row['Rainfall_mm'] > 100 and row['FeverCases'] > 25:
        return 'Dengue'
    elif row['Humidity_pct'] > 85 and row['ToiletUsage_pct'] < 75:
        return 'Typhoid'
    elif row['WaterIndex'] > 0.6 and row['NDVI'] < 0.4:
        return 'Malaria'
    elif row['FeverCases'] < 10 and row['Absenteeism_pct'] < 5:
        return 'Healthy'
    
    # Secondary conditions - more relaxed criteria
    elif row['Rainfall_mm'] > 50 and row['FeverCases'] > 15:
        return 'Dengue'
    elif row['Humidity_pct'] > 70 and row['ToiletUsage_pct'] < 80:
        return 'Typhoid'
    elif row['WaterIndex'] > 0.4 and row['NDVI'] < 0.5:
        return 'Malaria'
    elif row['FeverCases'] < 15 and row['Absenteeism_pct'] < 10:
        return 'Healthy'
    
    # Tertiary conditions - even more relaxed
    elif row['FeverCases'] > 20 or row['Rainfall_mm'] > 75:
        return 'Dengue'
    elif row['Humidity_pct'] > 80 or row['ToiletUsage_pct'] < 70:
        return 'Typhoid'
    elif row['WaterIndex'] > 0.5 or row['NDVI'] < 0.6:
        return 'Malaria'
    else:
        return 'Healthy'  # Default to Healthy

def regenerate_model():
    """Regenerate the ML model with current NumPy version"""
    print("Regenerating ML model with current NumPy version...")
    print(f"NumPy version: {np.__version__}")
    
    # Check if data file exists
    if not os.path.exists('delhi_disease_data_10000.csv'):
        print("Error: Data file 'delhi_disease_data_10000.csv' not found!")
        return False
    
    # Load data
    print("Loading data...")
    df = pd.read_csv('delhi_disease_data_10000.csv')
    
    # Assign diseases
    print("Assigning disease labels...")
    df['Disease'] = df.apply(assign_disease, axis=1)
    
    # Print disease distribution
    print("\nDisease distribution:")
    print(df['Disease'].value_counts())
    
    # Prepare features
    feature_columns = ['Week', 'Location', 'NDVI', 'WaterIndex', 'Rainfall_mm', 
                      'Humidity_pct', 'FeverCases', 'Absenteeism_pct', 'ToiletUsage_pct']
    
    X = df[feature_columns].copy()
    y = df['Disease']
    
    # Encode categorical features
    label_encoders = {}
    for col in ['Week', 'Location']:
        le = LabelEncoder()
        X[col] = le.fit_transform(X[col])
        label_encoders[col] = le
    
    # Encode target
    le_disease = LabelEncoder()
    y_encoded = le_disease.fit_transform(y)
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(
        X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
    )
    
    # Train XGBoost model
    print("Training XGBoost model...")
    model = xgb.XGBClassifier(
        n_estimators=100,
        max_depth=6,
        learning_rate=0.1,
        random_state=42,
        eval_metric='mlogloss'  # Explicitly set eval_metric to avoid warnings
    )
    
    model.fit(X_train, y_train)
    
    # Evaluate
    train_accuracy = model.score(X_train, y_train)
    test_accuracy = model.score(X_test, y_test)
    
    print(f"Train accuracy: {train_accuracy:.4f}")
    print(f"Test accuracy: {test_accuracy:.4f}")
    
    # Save model
    model_path = "xgb_disease_prediction_model.pkl"
    print(f"Saving model to {model_path}...")
    joblib.dump(model, model_path)
    
    # Test loading
    print("Testing model loading...")
    try:
        loaded_model = joblib.load(model_path)
        print("✓ Model loaded successfully")
        
        # Test prediction
        sample_prediction = loaded_model.predict(X_test[:1])
        print(f"✓ Sample prediction: {le_disease.inverse_transform(sample_prediction)[0]}")
        
    except Exception as e:
        print(f"✗ Error loading model: {e}")
        return False
    
    print("\n✓ Model regeneration completed successfully!")
    return True

if __name__ == "__main__":
    success = regenerate_model()
    if success:
        print("\n🎉 Model is ready for use!")
    else:
        print("\n❌ Model regeneration failed!")
