# 🚀 INSTALL FLUTTER - Step by Step

## ⚠️ IMPORTANT: You need to run PowerShell as Administrator

---

## Option 1: Install with Chocolatey (Recommended - Easiest)

### Step 1: Install Chocolatey
1. **Right-click** on PowerShell icon
2. Select **"Run as Administrator"**
3. Copy and paste this command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

4. Press **Enter** and wait for installation
5. **Close and reopen** PowerShell as Administrator

### Step 2: Install Flutter
```powershell
choco install flutter -y
```

### Step 3: Verify Installation
```powershell
flutter doctor
```

---

## Option 2: Manual Installation (Alternative)

### Step 1: Download Flutter
1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Click **"Download Flutter SDK"**
3. Extract the ZIP file to `C:\src\flutter`

### Step 2: Add to PATH
1. Press **Windows Key** and search for **"Environment Variables"**
2. Click **"Edit the system environment variables"**
3. Click **"Environment Variables"** button
4. Under **"System variables"**, find and select **"Path"**
5. Click **"Edit"**
6. Click **"New"**
7. Add: `C:\src\flutter\bin`
8. Click **"OK"** on all windows

### Step 3: Verify Installation
1. **Close and reopen** your terminal
2. Run:
```bash
flutter doctor
```

---

## After Flutter is Installed

### 1. Navigate to Project
```bash
cd d:\dheer@j\airsense5g
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate JSON Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App
```bash
# For Chrome (Web)
flutter run -d chrome

# For Windows Desktop
flutter run -d windows

# For Android (if emulator is running)
flutter run
```

---

## 🎯 Quick Test

Once installed, you can use the automated setup script:

```bash
# Just double-click this file:
setup.bat
```

---

## ✅ Expected Output

After `flutter doctor`, you should see:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version
[✓] Android toolchain (optional)
[✓] Chrome - develop for the web
[✓] Visual Studio (optional)
[✓] VS Code (optional)
[✓] Connected device
[✓] Network resources
```

Don't worry if some items show `[!]` - you only need Flutter and Chrome for web testing.

---

## 🐛 Common Issues

### "flutter: command not found"
**Solution**: Restart your terminal or add Flutter to PATH manually

### "Unable to find git"
**Solution**: Install Git from https://git-scm.com/download/win

### Android licenses
**Solution**: 
```bash
flutter doctor --android-licenses
```
Press 'y' to accept all

---

## 📞 Need Help?

If you encounter any issues:
1. Run `flutter doctor -v` for detailed diagnostics
2. Check the error message carefully
3. Restart your terminal after installation

---

**Ready to proceed?** Follow the steps above, then run `setup.bat`!
