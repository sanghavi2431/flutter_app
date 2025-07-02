#!/bin/bash

# Clean the project
flutter clean

# Remove debug-info
rm -r debug-info

# Create debug-info
mkdir debug-info

# Prompt the user to choose a build type
echo "Which build do you want?"
echo "1. iOS (IPA)"
echo "2. APK"
echo "3. AppBundle"

# Read the user's choice
read -p "Enter the number of your choice: " choice

# Check the user's choice and perform the corresponding action
case $choice in
    1)
        echo "You selected iOS (IPA) build."
        flutter build ipa --release --obfuscate --dart-define-from-file=config.json --split-debug-info=debug-info
        ;;
    2)
        echo "You selected APK build."
        flutter build apk --release --obfuscate --dart-define-from-file=config.json --split-debug-info=debug-info
        ;;
    3)
        echo "You selected AppBundle build."
        flutter build appbundle --release --obfuscate --dart-define-from-file=config.json --split-debug-info=debug-info
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 3."
        ;;
esac


# Upload symbols to Firebase Crashlytics
# firebase crashlytics:symbols:upload --app=[] debug-info