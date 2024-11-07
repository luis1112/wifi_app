# wifi_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## For Native Splash
- flutter pub run flutter_native_splash:create
## For Native Icon
- flutter pub run flutter_launcher_icons -f pubspec.yaml
- flutter pub run flutter_launcher_icons
## For Export Docs
- flutter pub global activate index_generator
- flutter pub global run index_generator
## For get SHA-1 and SHA-256
- ./gradlew signingReport
- keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
# For compile
- flutter build apk --release --target-platform android-arm64 --split-per-abi

# Credentials
- Alias: UNL-Analyzer
- Password: UNL-Analyzer