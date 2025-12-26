import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import TimeSeriesSplit
from sklearn.linear_model import LinearRegression
import joblib
import warnings
import os
warnings.filterwarnings('ignore')

# Set random seed for reproducibility
np.random.seed(42)

print("="*80)
print("AIR QUALITY PREDICTION SYSTEM - LINEAR REGRESSION")
print("Training on sensor_data.xlsx")
print("="*80)

# ============================================================================
# STEP 1: LOAD DATA
# ============================================================================
print("\n[STEP 1] Loading data from sensor_data.xlsx...")

try:
    df = pd.read_excel('sensor_data.xlsx')
    print(f"  - Data shape: {df.shape}")
    print(f"  - Columns: {df.columns.tolist()}")
    
except Exception as e:
    print(f"ERROR loading data: {e}")
    raise

# ============================================================================
# STEP 2: PREPROCESS DATA
# ============================================================================
print("\n[STEP 2] Preprocessing data...")

# Parse datetime and set as index
if 'timestamp' in df.columns:
    df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')
    df = df.sort_values('timestamp')
    df.set_index('timestamp', inplace=True)
    print(f"  - Set datetime index from 'timestamp'")

# Keep only sensor columns
sensor_cols = ['pm2_5', 'pm10', 'co2', 'tvoc', 'temperature', 'humidity']
available_cols = [col for col in sensor_cols if col in df.columns]
df = df[available_cols]
print(f"  - Kept {len(available_cols)} sensor columns: {available_cols}")

# ============================================================================
# STEP 3: CLEAN DATA
# ============================================================================
print("\n[STEP 3] Cleaning data...")

# Drop rows where ALL sensor values are NaN
rows_before = len(df)
df = df.dropna(how='all', subset=available_cols)
print(f"  - Removed {rows_before - len(df)} completely empty rows")

# Fill remaining missing values
print(f"  - Missing values before filling: {df.isnull().sum().sum()}")
df = df.ffill().bfill()
df = df.interpolate(method='linear', limit_direction='both')
print(f"  - Missing values after filling: {df.isnull().sum().sum()}")

# Remove any remaining NaN rows
rows_before = len(df)
df = df.dropna()
print(f"  - Removed {rows_before - len(df)} rows with remaining NaN values")
print(f"  - Final data shape: {df.shape}")

if len(df) < 10:
    print("\n⚠️  WARNING: Very few data points available. Model accuracy may be limited.")
    print("   Recommendation: Collect more data for better predictions.")

# ============================================================================
# STEP 4: TRAIN LINEAR REGRESSION MODELS FOR EACH TARGET
# ============================================================================
print("\n[STEP 4] Training Linear Regression models for each target...")

# Create directory for models
os.makedirs('models_lr', exist_ok=True)

# Store results for all models
all_results = {}
all_models = {}
all_scalers = {}
all_feature_names = {}

for target_col in available_cols:
    print(f"\n{'='*80}")
    print(f"TRAINING MODEL FOR: {target_col.upper()}")
    print(f"{'='*80}")
    
    # Prepare features (all columns except current target)
    feature_cols = [col for col in available_cols if col != target_col]
    
    # Create lag features for this target
    df_temp = df.copy()
    df_temp[f'{target_col}_lag1'] = df_temp[target_col].shift(1)
    df_temp[f'{target_col}_lag2'] = df_temp[target_col].shift(2)
    
    # Create rolling mean features for other pollutants
    rolling_window = 3  # Smaller window due to limited data
    for col in feature_cols:
        rolling_col = f'{col}_rolling_mean_{rolling_window}'
        df_temp[rolling_col] = df_temp[col].rolling(window=rolling_window, min_periods=1).mean()
    
    # Drop NaN rows created by lag features
    df_temp = df_temp.dropna()
    
    if len(df_temp) < 5:
        print(f"  ⚠️  Skipping {target_col}: Not enough data after feature engineering")
        continue
    
    # Prepare X and y
    all_features = [col for col in df_temp.columns if col != target_col]
    X = df_temp[all_features]
    y = df_temp[target_col]
    
    print(f"  - Feature matrix shape: {X.shape}")
    print(f"  - Target shape: {y.shape}")
    print(f"  - Target mean: {y.mean():.2f}, std: {y.std():.2f}")
    
    # Chronological split (80/20)
    split_idx = max(int(len(df_temp) * 0.8), len(df_temp) - 2)  # At least 2 test samples
    X_train, X_test = X.iloc[:split_idx], X.iloc[split_idx:]
    y_train, y_test = y.iloc[:split_idx], y.iloc[split_idx:]
    
    print(f"  - Train set: {X_train.shape[0]} samples")
    print(f"  - Test set: {X_test.shape[0]} samples")
    
    # Normalize features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train Linear Regression model
    print(f"  - Training Linear Regression model...")
    model = LinearRegression(fit_intercept=True, n_jobs=-1)
    model.fit(X_train_scaled, y_train)
    print(f"  - Model trained successfully")
    
    # Evaluate on test set
    y_train_pred = model.predict(X_train_scaled)
    y_test_pred = model.predict(X_test_scaled)
    
    train_rmse = np.sqrt(mean_squared_error(y_train, y_train_pred))
    test_rmse = np.sqrt(mean_squared_error(y_test, y_test_pred))
    train_mae = mean_absolute_error(y_train, y_train_pred)
    test_mae = mean_absolute_error(y_test, y_test_pred)
    train_r2 = r2_score(y_train, y_train_pred)
    test_r2 = r2_score(y_test, y_test_pred)
    
    print(f"\n  RESULTS:")
    print(f"    Train - RMSE: {train_rmse:.4f}, MAE: {train_mae:.4f}, R2: {train_r2:.4f}")
    print(f"    Test  - RMSE: {test_rmse:.4f}, MAE: {test_mae:.4f}, R2: {test_r2:.4f}")
    
    # Store results
    all_results[target_col] = {
        'train_rmse': train_rmse,
        'test_rmse': test_rmse,
        'train_mae': train_mae,
        'test_mae': test_mae,
        'train_r2': train_r2,
        'test_r2': test_r2,
    }
    
    # Save model, scaler, and feature names
    model_filename = f'models_lr/{target_col}_model.pkl'
    scaler_filename = f'models_lr/{target_col}_scaler.pkl'
    features_filename = f'models_lr/{target_col}_features.pkl'
    
    joblib.dump(model, model_filename)
    joblib.dump(scaler, scaler_filename)
    joblib.dump(all_features, features_filename)
    
    all_models[target_col] = model
    all_scalers[target_col] = scaler
    all_feature_names[target_col] = all_features
    
    print(f"  - Saved: {model_filename}")
    print(f"  - Saved: {scaler_filename}")
    print(f"  - Saved: {features_filename}")

# ============================================================================
# STEP 5: SUMMARY TABLE
# ============================================================================
print("\n" + "="*80)
print("MODEL PERFORMANCE SUMMARY")
print("="*80)

if all_results:
    summary_df = pd.DataFrame({
        'Target': list(all_results.keys()),
        'Train RMSE': [all_results[t]['train_rmse'] for t in all_results],
        'Test RMSE': [all_results[t]['test_rmse'] for t in all_results],
        'Test MAE': [all_results[t]['test_mae'] for t in all_results],
        'Test R2': [all_results[t]['test_r2'] for t in all_results],
    })
    
    print("\n" + summary_df.to_string(index=False))
    print("\n" + "="*80)
    
    # Save summary to CSV
    summary_df.to_csv('models_lr/model_performance_summary.csv', index=False)
    print("\nSaved performance summary to: models_lr/model_performance_summary.csv")

# ============================================================================
# FINAL SUMMARY
# ============================================================================
print("\n" + "="*80)
print("TRAINING COMPLETE!")
print("="*80)
print(f"\nTrained {len(all_results)} Linear Regression models for:")
for target in all_results.keys():
    print(f"  - {target}")

print(f"\nFiles saved:")
print(f"  - models_lr/ directory with {len(all_results)*3} files (model + scaler + features)")
print(f"  - models_lr/model_performance_summary.csv")
print("="*80)
print("\nNext steps:")
print("  1. Restart mqtt_pipeline.py to load these models")
print("  2. Models will be available for predictions via API")
print("="*80)
