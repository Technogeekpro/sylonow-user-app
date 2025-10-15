#!/bin/bash

# Script to generate a new debug keystore and extract SHA-1 fingerprint
# Run this script on your local machine where Java/keytool is installed

echo "🔑 Generating new debug keystore for Sylonow User app..."

# Navigate to the project directory
cd "$(dirname "$0")"

# Remove old keystore if it exists
if [ -f "android/app/sylonow-debug.keystore" ]; then
    echo "📝 Backing up old keystore..."
    mv android/app/sylonow-debug.keystore android/app/sylonow-debug.keystore.backup
fi

# Generate new debug keystore
echo "🛠️  Creating new debug keystore..."
keytool -genkey -v \
    -keystore android/app/sylonow-debug.keystore \
    -alias androiddebugkey \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass android \
    -keypass android \
    -dname "CN=Android Debug,O=Android,C=US"

if [ $? -eq 0 ]; then
    echo "✅ Keystore created successfully!"
    
    # Extract SHA-1 fingerprint
    echo ""
    echo "🔍 Extracting SHA-1 fingerprint..."
    echo "================================================"
    keytool -list -v \
        -keystore android/app/sylonow-debug.keystore \
        -alias androiddebugkey \
        -storepass android \
        -keypass android | grep "SHA1:"
    echo "================================================"
    echo ""
    echo "📋 Copy the SHA1 fingerprint above and add it to your Android client in Google Cloud Console"
    echo "📋 Package name: com.example.sylonow_user"
    echo ""
    echo "🚀 After adding the SHA-1 to Google Cloud Console, Google Sign-In should work!"
else
    echo "❌ Failed to create keystore. Make sure Java/keytool is installed."
    exit 1
fi