# Flutter SDK Installation Steps

## Step 1: Install Chocolatey (Run PowerShell as Administrator)

**IMPORTANT**: You need to run PowerShell as Administrator for this step.

1. Right-click on PowerShell and select "Run as Administrator"
2. Run this command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

3. Wait for installation to complete
4. Close and reopen PowerShell as Administrator

## Step 2: Install Flutter SDK

After Chocolatey is installed, run:

```powershell
choco install flutter -y
```

This will:
- Download Flutter SDK
- Install it to `C:\tools\flutter`
- Add Flutter to your PATH automatically

## Step 3: Verify Installation

```powershell
flutter doctor
```

This will check your Flutter installation and show what's needed.

## Step 4: Accept Android Licenses (if using Android)

```powershell
flutter doctor --android-licenses
```

Press 'y' to accept all licenses.

## Step 5: Install Dependencies for Our Project

```powershell
cd d:\dheer@j\airsense5g
flutter pub get
```

## Step 6: Generate JSON Serialization Code

```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```

## Expected Output

After successful installation, `flutter doctor` should show:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Visual Studio - develop Windows apps
[✓] Android Studio
[✓] VS Code
[✓] Connected device
[✓] Network resources
```

## Alternative: Manual Installation

If Chocolatey doesn't work, you can install Flutter manually:

1. Download Flutter SDK: https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to your PATH:
   - Search for "Environment Variables" in Windows
   - Edit "Path" under System Variables
   - Add new entry: `C:\src\flutter\bin`
   - Click OK
4. Restart your terminal
5. Run `flutter doctor`

## Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Restart your terminal or add Flutter to PATH manually

### Issue: Android licenses not accepted
**Solution**: Run `flutter doctor --android-licenses` and accept all

### Issue: No devices available
**Solution**: 
- For Android: Install Android Studio and create an emulator
- For Chrome: Flutter web works automatically
- For physical device: Enable USB debugging

## Next Steps

Once Flutter is installed:
1. Run `flutter doctor` to verify
2. Navigate to project: `cd d:\dheer@j\airsense5g`
3. Install dependencies: `flutter pub get`
4. Generate code: `flutter pub run build_runner build --delete-conflicting-outputs`
5. Run the app: `flutter run`

---

**Note**: I'll continue building the remaining modules (Map, Forecast, Chat, Settings) while you install Flutter. You can test the app once installation is complete!
