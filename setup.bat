@echo off
REM Inventory App Setup Script for Windows

echo.
echo ============================================
echo   Inventory Manager App - Setup Script
echo ============================================
echo.

echo Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo Error: Flutter is not installed or not in PATH
    pause
    exit /b 1
)

echo.
echo Getting Flutter dependencies...
call flutter pub get
if errorlevel 1 (
    echo Error: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Cleaning build cache...
call flutter clean

echo.
echo ============================================
echo   Setup Complete!
echo ============================================
echo.
echo Next steps:
echo 1. Connect a device or start an emulator
echo 2. Run: flutter run
echo.
pause
