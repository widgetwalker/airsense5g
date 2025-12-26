import os
import json
import logging
import threading
import pandas as pd
import numpy as np
import joblib
import paho.mqtt.client as mqtt
from dotenv import load_dotenv
from flask_cors import CORS
from flask import Flask, jsonify
from datetime import datetime, timedelta

# -----------------------------
# Logging setup
# -----------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger(__name__)

# -----------------------------
# Load environment variables
# -----------------------------
load_dotenv("am3.env")

# MQTT settings
MQTT_BROKER = os.getenv("MQTT_BROKER")
MQTT_PORT = int(os.getenv("MQTT_PORT", "1883"))
MQTT_TOPIC = os.getenv("MQTT_TOPIC")
MQTT_USERNAME = os.getenv("MQTT_USERNAME")
MQTT_PASSWORD = os.getenv("MQTT_PASSWORD")

if not all([MQTT_BROKER, MQTT_TOPIC, MQTT_USERNAME, MQTT_PASSWORD]):
    logger.error("❌ Missing MQTT configuration in am3.env")
    exit(1)

# Global storage
EXCEL_FILE = "sensor_data.xlsx"

# Load existing data if file exists
if os.path.exists(EXCEL_FILE):
    try:
        existing_df = pd.read_excel(EXCEL_FILE)
        
        # Ensure timestamp column is datetime for sorting
        if 'timestamp' in existing_df.columns:
            existing_df['timestamp'] = pd.to_datetime(existing_df['timestamp'])
            existing_df = existing_df.sort_values(by='timestamp', ascending=True)
            
            # Save the sorted data back to the file to "reorganize" it
            existing_df.to_excel(EXCEL_FILE, index=False)
            logger.info(f"✅ Reorganized (sorted) {len(existing_df)} records in {EXCEL_FILE}")
            
        sensor_data_history = existing_df.to_dict('records')
        
        if sensor_data_history:
             # Find the last row that has valid sensor data (not all NaN)
             latest_sensor_data = {}
             for row in reversed(sensor_data_history):
                 # Check if this row has at least one valid sensor value
                 if (pd.notna(row.get('pm2_5')) or 
                     pd.notna(row.get('pm10')) or 
                     pd.notna(row.get('co2'))):
                     # Extract only the sensor-related fields
                     latest_sensor_data = {
                         'timestamp': row.get('timestamp'),
                         'pm2_5': row.get('pm2_5') if pd.notna(row.get('pm2_5')) else 0,
                         'pm10': row.get('pm10') if pd.notna(row.get('pm10')) else 0,
                         'co2': row.get('co2') if pd.notna(row.get('co2')) else 0,
                         'tvoc': row.get('tvoc') if pd.notna(row.get('tvoc')) else 0,
                         'humidity': row.get('humidity') if pd.notna(row.get('humidity')) else 0,
                         'temperature': row.get('temperature') if pd.notna(row.get('temperature')) else 0,
                     }
                     logger.info(f"🔄 Initialized latest data from history: {latest_sensor_data.get('timestamp', 'Unknown Time')}")
                     break
             
             if not latest_sensor_data:
                 logger.warning("⚠ No valid sensor data found in Excel file")
        else:
             latest_sensor_data = {}
             
        logger.info(f"📂 Loaded {len(sensor_data_history)} historical records from {EXCEL_FILE}")
    except Exception as e:
        logger.warning(f"⚠ Found existing Excel file but failed to load it: {e}")
        sensor_data_history = []
        latest_sensor_data = {}
else:
    logger.info("ℹ No existing data file found. Starting fresh.")
    sensor_data_history = []

# -----------------------------
# Load ML Models
# -----------------------------
ml_models = {}
ml_scalers = {}
ml_features = {}

MODELS_DIR = 'models_lr'
if os.path.exists(MODELS_DIR):
    try:
        sensor_targets = ['pm2_5', 'pm10', 'co2', 'tvoc', 'temperature', 'humidity']
        for target in sensor_targets:
            model_path = os.path.join(MODELS_DIR, f'{target}_model.pkl')
            scaler_path = os.path.join(MODELS_DIR, f'{target}_scaler.pkl')
            features_path = os.path.join(MODELS_DIR, f'{target}_features.pkl')
            
            if os.path.exists(model_path) and os.path.exists(scaler_path) and os.path.exists(features_path):
                ml_models[target] = joblib.load(model_path)
                ml_scalers[target] = joblib.load(scaler_path)
                ml_features[target] = joblib.load(features_path)
                logger.info(f"✅ Loaded ML model for {target}")
        
        if ml_models:
            logger.info(f"🤖 Loaded {len(ml_models)} ML models for predictions")
        else:
            logger.warning("⚠️  No ML models found. Run train_model.py first.")
    except Exception as e:
        logger.error(f"❌ Error loading ML models: {e}")
else:
    logger.warning(f"⚠️  Models directory '{MODELS_DIR}' not found. Predictions will be unavailable.")


# -----------------------------
# Flask App
# -----------------------------
app = Flask(__name__)
CORS(app) # Enable CORS for all routes

@app.route('/api/data', methods=['GET'])
def get_latest_data():
    """Returns the latest sensor data."""
    # Create a copy to avoid modifying the global directly in a way that might affect other threads if we were deeper
    # But for simple replacement it's fine.
    response_data = latest_sensor_data.copy() if isinstance(latest_sensor_data, dict) else {}
    
    # Calculate AQI if not present
    if 'aqi' not in response_data or response_data['aqi'] is None or response_data['aqi'] == 0:
        pm25 = float(response_data.get('pm2_5', 0) or 0)
        pm10 = float(response_data.get('pm10', 0) or 0)
        
        # Simple AQI calc (US EPA style approximation)
        def calc_aqi(pm25, pm10):
            aqi_pm25 = 0
            if pm25 <= 12.0: aqi_pm25 = ((50 - 0) / (12.0 - 0)) * (pm25 - 0) + 0
            elif pm25 <= 35.4: aqi_pm25 = ((100 - 51) / (35.4 - 12.1)) * (pm25 - 12.1) + 51
            elif pm25 <= 55.4: aqi_pm25 = ((150 - 101) / (55.4 - 35.5)) * (pm25 - 35.5) + 101
            elif pm25 <= 150.4: aqi_pm25 = ((200 - 151) / (150.4 - 55.5)) * (pm25 - 55.5) + 151
            else: aqi_pm25 = 300 # Rough cap for simplification
            
            aqi_pm10 = 0
            if pm10 <= 54: aqi_pm10 = ((50 - 0) / (54 - 0)) * (pm10 - 0) + 0
            elif pm10 <= 154: aqi_pm10 = ((100 - 51) / (154 - 55)) * (pm10 - 55) + 51
            elif pm10 <= 254: aqi_pm10 = ((150 - 101) / (254 - 155)) * (pm10 - 155) + 101
            else: aqi_pm10 = 300
            
            return max(aqi_pm25, aqi_pm10)

        response_data['aqi'] = int(calc_aqi(pm25, pm10))

    # helper to clean NaN
    def clean_nans(d):
        cleaned = {}
        for k, v in d.items():
            if isinstance(v, float) and (v != v): # check for NaN
                cleaned[k] = None
            elif isinstance(v, dict):
                cleaned[k] = clean_nans(v)
            else:
                cleaned[k] = v
        return cleaned

    cleaned_data = clean_nans(response_data)
    return jsonify(cleaned_data)

# Helper function to prepare features for prediction
def prepare_features_for_prediction(current_data, target_col, feature_names):
    """Prepare feature vector for ML prediction"""
    try:
        # Get historical data for lag features
        if len(sensor_data_history) < 3:
            return None
        
        recent_data = sensor_data_history[-3:]
        
        # Create a temporary dataframe with recent data
        df_temp = pd.DataFrame(recent_data)
        
        # Add current data as the latest row
        current_row = {k: v for k, v in current_data.items() if k in ['pm2_5', 'pm10', 'co2', 'tvoc', 'temperature', 'humidity']}
        df_temp = pd.concat([df_temp, pd.DataFrame([current_row])], ignore_index=True)
        
        # Create lag features
        df_temp[f'{target_col}_lag1'] = df_temp[target_col].shift(1)
        df_temp[f'{target_col}_lag2'] = df_temp[target_col].shift(2)
        
        # Create rolling mean features
        rolling_window = 3
        for col in ['pm2_5', 'pm10', 'co2', 'tvoc', 'temperature', 'humidity']:
            if col != target_col and col in df_temp.columns:
                rolling_col = f'{col}_rolling_mean_{rolling_window}'
                df_temp[rolling_col] = df_temp[col].rolling(window=rolling_window, min_periods=1).mean()
        
        # Get the last row (current data with features)
        feature_row = df_temp.iloc[-1]
        
        # Extract features in the correct order
        feature_values = []
        for feat in feature_names:
            if feat in feature_row:
                val = feature_row[feat]
                feature_values.append(val if pd.notna(val) else 0)
            else:
                feature_values.append(0)
        
        return np.array(feature_values).reshape(1, -1)
    
    except Exception as e:
        logger.error(f"Error preparing features: {e}")
        return None

@app.route('/api/predict', methods=['GET'])
def predict_next():
    """Predict next values for all pollutants"""
    if not ml_models:
        return jsonify({'error': 'ML models not loaded. Run train_model.py first.'}), 503
    
    if not latest_sensor_data:
        return jsonify({'error': 'No sensor data available'}), 404
    
    predictions = {}
    
    for target, model in ml_models.items():
        try:
            # Prepare features
            features = prepare_features_for_prediction(latest_sensor_data, target, ml_features[target])
            if features is None:
                predictions[target] = None
                continue
            
            # Scale features
            features_scaled = ml_scalers[target].transform(features)
            
            # Predict
            pred_value = model.predict(features_scaled)[0]
            predictions[target] = round(float(pred_value), 2)
            
        except Exception as e:
            logger.error(f"Error predicting {target}: {e}")
            predictions[target] = None
    
    return jsonify({
        'predictions': predictions,
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/forecast/24h', methods=['GET'])
def forecast_24h():
    """Generate 24-hour hourly forecast"""
    if not ml_models:
        return jsonify({'error': 'ML models not loaded'}), 503
    
    if not latest_sensor_data or len(sensor_data_history) < 3:
        return jsonify({'error': 'Insufficient data for forecasting'}), 404
    
    forecast_hours = []
    current_values = latest_sensor_data.copy()
    
    # Generate hourly predictions
    for hour in range(1, 25):
        hour_predictions = {}
        timestamp = datetime.now() + timedelta(hours=hour)
        
        for target in ml_models.keys():
            try:
                features = prepare_features_for_prediction(current_values, target, ml_features[target])
                if features is not None:
                    features_scaled = ml_scalers[target].transform(features)
                    pred_value = ml_models[target].predict(features_scaled)[0]
                    hour_predictions[target] = round(float(pred_value), 2)
                    current_values[target] = pred_value  # Update for next iteration
                else:
                    hour_predictions[target] = current_values.get(target, 0)
            except:
                hour_predictions[target] = current_values.get(target, 0)
        
        forecast_hours.append({
            'hour': hour,
            'timestamp': timestamp.isoformat(),
            'values': hour_predictions
        })
    
    return jsonify({'forecast': forecast_hours})

@app.route('/api/forecast/week', methods=['GET'])
def forecast_week():
    """Generate 7-day daily forecast"""
    if not ml_models:
        return jsonify({'error': 'ML models not loaded'}), 503
    
    if not latest_sensor_data or len(sensor_data_history) < 3:
        return jsonify({'error': 'Insufficient data for forecasting'}), 404
    
    forecast_days = []
    current_values = latest_sensor_data.copy()
    
    # Generate daily predictions (24 hours per day, averaged)
    for day in range(1, 8):
        day_predictions_sum = {target: 0 for target in ml_models.keys()}
        
        # Predict 24 hours and average
        for hour in range(24):
            for target in ml_models.keys():
                try:
                    features = prepare_features_for_prediction(current_values, target, ml_features[target])
                    if features is not None:
                        features_scaled = ml_scalers[target].transform(features)
                        pred_value = ml_models[target].predict(features_scaled)[0]
                        day_predictions_sum[target] += pred_value
                        current_values[target] = pred_value
                    else:
                        day_predictions_sum[target] += current_values.get(target, 0)
                except:
                    day_predictions_sum[target] += current_values.get(target, 0)
        
        # Average the 24 hourly predictions
        day_avg = {target: round(day_predictions_sum[target] / 24, 2) for target in ml_models.keys()}
        
        timestamp = datetime.now() + timedelta(days=day)
        forecast_days.append({
            'day': day,
            'date': timestamp.strftime('%Y-%m-%d'),
            'values': day_avg
        })
    
    return jsonify({'forecast': forecast_days})


def run_flask():
    app.run(host='0.0.0.0', port=5000)

# -----------------------------
# Excel Helper
# -----------------------------
def save_to_excel():
    """Saves the in-memory list to an Excel file."""
    try:
        df = pd.DataFrame(sensor_data_history)
        # Reorder columns if possible to make timestamp first, etc.
        # For now, just dump whatever we have.
        df.to_excel(EXCEL_FILE, index=False)
        logger.info(f"💾 Data saved to {EXCEL_FILE}. Total records: {len(sensor_data_history)}")
    except Exception as e:
        logger.error(f"❌ Failed to save Excel file: {e}")

# -----------------------------
# MQTT Callbacks
# -----------------------------
def on_connect(client, userdata, flags, reason_code, properties=None):
    if reason_code == 0:
        logger.info("✅ Connected to MQTT broker")
        client.subscribe(MQTT_TOPIC)
        logger.info(f"✅ Subscribed to topic: {MQTT_TOPIC}")
    else:
        logger.error(f"❌ Failed to connect to MQTT broker, reason_code={reason_code}")

def on_message(client, userdata, msg):
    global latest_sensor_data
    try:
        raw_payload = msg.payload.decode("utf-8", errors="ignore")
        logger.info(f"📩 Data received: {raw_payload[:100]}...")  # Log first 100 chars
        
        data = json.loads(raw_payload)
        
        # Flatten structure if needed or just store raw dict
        # Adding timestamp if not present
        if 'timestamp' not in data:
            data['timestamp'] = datetime.now().isoformat()
            
        # Also extracting specific fields for easier Excel reading if standard LoraWAN payload
        # Usually 'uplink_message' -> 'decoded_payload'
        # But we'll store the whole thing flattened or as is. 
        # Flattening 'uplink_message.decoded_payload' into top level if it exists
        if 'uplink_message' in data and 'decoded_payload' in data['uplink_message']:
            data.update(data['uplink_message']['decoded_payload'])

        sensor_data_history.append(data)
        latest_sensor_data = data
        
        # Save to Excel immediately
        save_to_excel()
        
    except json.JSONDecodeError:
        logger.warning("⚠ Received non-JSON payload.")
    except Exception as e:
        logger.error(f"❌ Error processing message: {e}")

# -----------------------------
# Main System
# -----------------------------
def start_mqtt():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        logger.info(f"Connecting to {MQTT_BROKER}:{MQTT_PORT}...")
        client.connect(MQTT_BROKER, MQTT_PORT, keepalive=60)
        client.loop_forever()
    except Exception as e:
        logger.error(f"❌ MQTT Connection failed: {e}")

if __name__ == "__main__":
    # Start Flask in a separate thread
    flask_thread = threading.Thread(target=run_flask, daemon=True)
    flask_thread.start()
    
    # Start MQTT in main thread
    start_mqtt()
