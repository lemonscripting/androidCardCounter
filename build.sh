#!/bin/bash

# Fail the script if any command fails
set -e

# Set Android SDK path
ANDROID_HOME=$HOME/android-sdk

# Step 1: Install SDKMAN and Gradle
echo "Installing SDKMAN and Gradle..."
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle

# Step 2: Download and Install Android SDK
echo "Setting up Android SDK..."
mkdir -p $ANDROID_HOME
cd $ANDROID_HOME
wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O cmdline-tools.zip
unzip cmdline-tools.zip -d cmdline-tools
mkdir -p cmdline-tools/tools
mv cmdline-tools/* cmdline-tools/tools
rm cmdline-tools.zip

# Set Android SDK environment variables
export PATH=$ANDROID_HOME/cmdline-tools/tools/bin:$PATH

# Step 3: Install Android SDK Components
echo "Installing Android SDK components..."
sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "platforms;android-34" "build-tools;34.0.0"
yes | sdkmanager --licenses

# Step 4: Build APK
echo "Building APK..."
cd /
./gradlew assembleDebug

# Step 5: Output APK Path
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo "APK successfully built: $APK_PATH"
else
    echo "APK build failed."
fi
