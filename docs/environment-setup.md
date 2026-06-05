# Environment Setup

## Prerequisites

- Flutter SDK ≥ 3.32.x (`flutter --version` to check)
- Dart SDK ≥ 3.11.5 (bundled with Flutter)
- Xcode ≥ 15 (iOS builds)
- Android Studio + Android SDK (Android builds)
- CocoaPods (`sudo gem install cocoapods` — iOS dependency manager)

## 1. Clone and Install

```bash
git clone <repo-url>
cd planthor-ios-application
flutter pub get
cd ios && pod install && cd ..
```

## 2. Environment Configuration

All config is baked into `AppConfig` (`lib/core/config/app_config.dart`) and switches on a single `ENV` define. No JSON files needed.

## 3. Start Local Keycloak (dev only)

The dev environment expects Keycloak running on `localhost:8180`. Use the project's Docker Compose setup:

```bash
docker compose up -d keycloak
```

Keycloak admin console: `http://localhost:8180/admin` (credentials in your team's secrets manager).

## 4. Run Code Generation

Required after any `@riverpod` annotation change or model addition:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 5. Run the App

```bash
# Development (local Keycloak + API via Docker Compose)
flutter run --dart-define=ENV=dev

# Production
flutter run --dart-define=ENV=prod
```

## 6. Run Tests and Analysis

```bash
flutter analyze          # must pass zero errors
flutter test             # run all tests
flutter test test/widget_test.dart   # single file
```

## Troubleshooting

**`flutter_appauth` redirect not captured on iOS simulator:**
Simulators may not handle custom URL schemes reliably. Test OAuth flow on a physical device or use the `planthor://callback` scheme in Safari manually.

**`build_runner` conflicts:**
```bash
dart run build_runner build --delete-conflicting-outputs
```
The `--delete-conflicting-outputs` flag resolves stale `.g.dart` files.

**CocoaPods version mismatch:**
```bash
cd ios
pod repo update
pod install
```
