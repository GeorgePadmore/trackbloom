# track_bloom

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## How to Build the app
### Build debug APK for testing
./build_scripts.sh debug

### Build production AAB for Play Store
./build_scripts.sh release

### Build both debug APK and production AAB
./build_scripts.sh both

### Show help
./build_scripts.sh help


## What the Script Does:
### Debug APK Build:
- Cleans the project
- Builds debug APK
- Shows the file location
- Provides ADB install command

### Production AAB Build:
- Checks if key.properties exists
- Cleans the project
- Builds signed AAB
- Shows the file location
- Provides next steps for Play Store

Both Builds:
- Runs both debug and production builds sequentially
- Shows clear separation between builds

Features:
- ✅ Error handling - Checks for required files
- ✅ Clear output - Shows exactly where files are created
- ✅ Helpful instructions - Provides next steps
- ✅ Visual feedback - Uses emojis and clear formatting
- ✅ Flexible options - Build one or both types