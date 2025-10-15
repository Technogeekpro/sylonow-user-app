@echo off
echo 🔑 Generating new debug keystore for Sylonow User app...

REM Navigate to the project directory
cd /d "%~dp0"

REM Remove old keystore if it exists
if exist "android\app\sylonow-debug.keystore" (
    echo 📝 Backing up old keystore...
    move "android\app\sylonow-debug.keystore" "android\app\sylonow-debug.keystore.backup"
)

REM Generate new debug keystore
echo 🛠️  Creating new debug keystore...
keytool -genkey -v ^
    -keystore android\app\sylonow-debug.keystore ^
    -alias androiddebugkey ^
    -keyalg RSA ^
    -keysize 2048 ^
    -validity 10000 ^
    -storepass android ^
    -keypass android ^
    -dname "CN=Android Debug,O=Android,C=US"

if %errorlevel% equ 0 (
    echo ✅ Keystore created successfully!
    
    REM Extract SHA-1 fingerprint
    echo.
    echo 🔍 Extracting SHA-1 fingerprint...
    echo ================================================
    keytool -list -v ^
        -keystore android\app\sylonow-debug.keystore ^
        -alias androiddebugkey ^
        -storepass android ^
        -keypass android | findstr "SHA1:"
    echo ================================================
    echo.
    echo 📋 Copy the SHA1 fingerprint above and add it to your Android client in Google Cloud Console
    echo 📋 Package name: com.example.sylonow_user
    echo.
    echo 🚀 After adding the SHA-1 to Google Cloud Console, Google Sign-In should work!
) else (
    echo ❌ Failed to create keystore. Make sure Java/keytool is installed.
    pause
    exit /b 1
)

pause