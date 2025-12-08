# Air Quality Guardian - Quick Start Guide

## 🚀 Quick Setup (3 Steps)

### Step 1: Install Flutter

**Option A: Using Chocolatey (Easiest)**
```powershell
# Open PowerShell as Administrator and run:
choco install flutter -y
```

**Option B: Manual Installation**
1. Download: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Restart terminal

### Step 2: Run Setup Script
```bash
# Double-click setup.bat or run:
.\setup.bat
```

This will automatically:
- Check Flutter installation
- Run `flutter pub get`
- Generate JSON code with build_runner

### Step 3: Run the App
```bash
flutter run
```

---

## 📱 Testing the App

### Check Installation
```bash
flutter doctor
```

### Run on Different Platforms

**Chrome (Web)**
```bash
flutter run -d chrome
```

**Windows Desktop**
```bash
flutter run -d windows
```

**Android Emulator**
```bash
# Start emulator first, then:
flutter run
```

---

## 🎯 What to Test

### 1. Authentication Flow
- ✅ Splash screen (2 second delay)
- ✅ Login screen (email/password validation)
- ✅ Signup screen (password strength indicator)

### 2. Dashboard
- ✅ AQI Gauge (circular progress)
- ✅ Risk Assessment Card
- ✅ Health Suggestions (5 recommendations)
- ✅ Pollutant Breakdown (6 pollutants)
- ✅ Pull-to-refresh

### 3. Profile
- ✅ User information display
- ✅ Health profile details
- ✅ Edit profile button

### 4. Health Form
- ✅ Age, gender, conditions
- ✅ Activity level selector
- ✅ Sensitivity slider (1-5)
- ✅ Notification preferences
- ✅ Form validation

### 5. Chat Assistant
- ✅ Welcome message
- ✅ Quick replies
- ✅ Message bubbles
- ✅ Typing indicator
- ✅ Mock AI responses

### 6. Forecast
- ✅ 24-hour line chart
- ✅ 7-day bar chart
- ✅ Forecast summary
- ✅ Activity planner

### 7. Settings
- ✅ Account settings
- ✅ Notification toggles
- ✅ Theme selector (Light/Dark/System)
- ✅ Language selector
- ✅ Privacy options

---

## 🐛 Troubleshooting

### Flutter not found
**Solution**: Restart terminal after installation or add to PATH manually

### Build runner fails
**Solution**: 
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Missing dependencies
**Solution**:
```bash
flutter pub get
```

### Android licenses
**Solution**:
```bash
flutter doctor --android-licenses
```

---

## 📊 Current Status

**Implemented**: 55+ files, ~60% complete
- ✅ Foundation & Core Infrastructure
- ✅ Authentication Module
- ✅ Dashboard Module
- ✅ Profile & Health Form
- ✅ Chat Assistant
- ✅ Forecast Module
- ✅ Settings Module

**Pending**:
- ⏳ Map Module (Google Maps integration)
- ⏳ Alerts Module (Firebase notifications)
- ⏳ Onboarding Flow

---

## 🎨 Features to Explore

1. **Dark Mode**: Change theme in Settings
2. **Password Strength**: Try different passwords in signup
3. **AQI Colors**: See different colors for AQI values
4. **Chat Responses**: Ask about AQI, health tips, pollutants
5. **Forecast Charts**: Toggle between 24hr and 7-day views
6. **Pull to Refresh**: Swipe down on dashboard

---

## 📝 Notes

- **Mock Data**: App uses mock data (no backend required)
- **Offline**: All features work offline
- **Responsive**: Works on different screen sizes
- **Accessible**: Follows Material Design 3 guidelines

Enjoy testing! 🎉
