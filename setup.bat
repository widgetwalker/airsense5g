@echo off
echo ========================================
echo Air Quality Guardian - Flutter Setup
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Flutter is already installed!
    flutter --version
    goto :install_deps
) else (
    echo [!] Flutter is not installed.
    echo.
    echo Please install Flutter using one of these methods:
    echo.
    echo METHOD 1: Using Chocolatey (Recommended)
    echo   1. Open PowerShell as Administrator
    echo   2. Run: choco install flutter -y
    echo.
    echo METHOD 2: Manual Installation
    echo   1. Download from: https://docs.flutter.dev/get-started/install/windows
    echo   2. Extract to C:\src\flutter
    echo   3. Add C:\src\flutter\bin to PATH
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
)

:install_deps
echo.
echo ========================================
echo Installing Dependencies
echo ========================================
echo.

REM Navigate to project directory
cd /d "%~dp0"

REM Install dependencies
echo Running: flutter pub get
flutter pub get

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo ========================================
echo Generating Code
echo ========================================
echo.

REM Generate JSON serialization code
echo Running: flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner build --delete-conflicting-outputs

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to generate code
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo You can now run the app with:
echo   flutter run
echo.
echo Or check your Flutter installation with:
echo   flutter doctor
echo.
pause
