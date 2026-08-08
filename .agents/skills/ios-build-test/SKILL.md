---
name: ios-build-test
description: >-
  Use this skill when diagnosing iOS build issues, managing certificates/profiles,
  or testing the app on the iOS simulator or physical devices.
---

# Planthor iOS Build & Test Workflow

## 1. Bundle Identifier & Code Signing
- **Bundle ID:** `space.planthor.app`
- **Development Team:** Without an Apple Developer Account, open `ios/Runner.xcworkspace` in Xcode, navigate to the `Runner` target's `Signing & Capabilities` tab, and sign in with a personal Apple ID to generate a Free Personal Team. Select that team.
- **Entitlements:** Entitlements like Keychain Sharing (required by `flutter_secure_storage`) require signing and physical device deployment.

## 2. Running on iOS Simulator
- Find an available simulator: `flutter devices`
- Run locally: `flutter run -d <simulator_id> --dart-define=ENV=dev`

## 3. Resolving CocoaPods Issues
If iOS builds fail due to Podfile or plugin mismatch:
```bash
cd ios
rm -rf Pods/ Podfile.lock
pod cache clean --all
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

## 4. Xcode Versioning
- iOS Deployment Target is locked to `17.0` (iPhone 15).
- Make sure Xcode is updated if API issues occur.
