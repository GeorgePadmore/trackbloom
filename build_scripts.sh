#!/bin/bash

# TrackBloom Build Script
# This script helps you build debug APK for testing and production AAB for Play Store

echo "🚀 TrackBloom Build Script"
echo "=========================="

# Function to build debug APK
build_debug_apk() {
    echo "📱 Building Debug APK for testing..."
    echo "This will create an APK file for testing on your device."
    echo ""
    
    flutter clean
    flutter build apk --debug
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Debug APK built successfully!"
        echo "📁 Location: build/app/outputs/flutter-apk/app-debug.apk"
        echo ""
        echo "📋 To install on your device:"
        echo "   adb install build/app/outputs/flutter-apk/app-debug.apk"
        echo ""
    else
        echo ""
        echo "❌ Debug APK build failed!"
        echo "Please check the error messages above."
        echo ""
    fi
}

# Function to build production AAB
build_production_aab() {
    echo "🏪 Building Production AAB for Play Store..."
    echo "This will create a signed AAB file for Play Store upload."
    echo ""
    
    # Check if key.properties exists
    if [ ! -f "android/key.properties" ]; then
        echo "❌ Error: android/key.properties not found!"
        echo "Please make sure you have set up your keystore and key.properties file."
        echo ""
        return 1
    fi
    
    flutter clean
    flutter build appbundle --release
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Production AAB built successfully!"
        echo "📁 Location: build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "📋 Next steps:"
        echo "   1. Upload the AAB file to Google Play Console"
        echo "   2. Test the release on internal testing track first"
        echo "   3. Then promote to production"
        echo ""
    else
        echo ""
        echo "❌ Production AAB build failed!"
        echo "Please check the error messages above."
        echo ""
    fi
}

# Function to show help
show_help() {
    echo "Usage: ./build_scripts.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  debug     Build debug APK for testing"
    echo "  release   Build production AAB for Play Store"
    echo "  both      Build both debug APK and production AAB"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./build_scripts.sh debug     # Build debug APK only"
    echo "  ./build_scripts.sh release   # Build production AAB only"
    echo "  ./build_scripts.sh both      # Build both"
    echo ""
}

# Main script logic
case "$1" in
    "debug")
        build_debug_apk
        ;;
    "release")
        build_production_aab
        ;;
    "both")
        echo "🔄 Building both debug APK and production AAB..."
        echo ""
        build_debug_apk
        echo "----------------------------------------"
        build_production_aab
        ;;
    "help"|"-h"|"--help"|"")
        show_help
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

echo "🎉 Build script completed!" 