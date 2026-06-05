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

## 2. Configure Environment Files

Copy the example files and fill in values:

```bash
cp dart_defines/dev.example.json dart_defines/dev.json
cp dart_defines/prod.example.json dart_defines/prod.json
```

`dart_defines/dev.json` — for local development with Docker Compose:
```json
{
  "ENV": "dev",
  "KEYCLOAK_BASE_URL": "http://localhost:8180",
  "KEYCLOAK_REALM": "planthor",
  "API_BASE_URL": "http://localhost:5008",
  "CLIENT_ID": "planthor-ios"
}
```

`dart_defines/prod.json` — for production:
```json
{
  "ENV": "prod",
  "KEYCLOAK_BASE_URL": "https://auth.planthor.space",
  "KEYCLOAK_REALM": "planthor",
  "API_BASE_URL": "https://api.planthor.space",
  "CLIENT_ID": "planthor-ios"
}
```

`dart_defines/*.json` files are gitignored. Never commit real credentials.

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
# Development (local Keycloak + API)
flutter run --dart-define-from-file=dart_defines/dev.json

# Production
flutter run --dart-define-from-file=dart_defines/prod.json
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
