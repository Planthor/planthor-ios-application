# Environment Setup

## Prerequisites

- Flutter SDK 3.44.1 (`flutter --version` to check; CI uses this exact version)
- Dart SDK ^3.11.5 (bundled with Flutter)
- Xcode ≥ 15 (iOS builds)
- Android Studio + Android SDK API 35+ (Android builds)
- CocoaPods (`sudo gem install cocoapods` — iOS dependency manager)
- Docker + Docker Compose (for local Keycloak + API server)

## 1. Clone and Install

```bash
git clone <repo-url>
cd planthor-ios-application
flutter pub get
cd ios && pod install && cd ..
```

## 2. Environment Configuration

All config is baked into `AppConfig` (`lib/core/config/app_config.dart`) and switches on a single `ENV` define. No JSON files or `.env` files are needed.

| ENV value | Keycloak | Backend API |
|-----------|----------|-------------|
| `dev` (default) | `http://localhost:8180` | `http://localhost:5008` |
| `prod` | `https://auth.planthor.space` | `https://api.planthor.space` |

## 3. Start Local Infrastructure (dev only)

The dev environment expects Keycloak on `localhost:8180` and the backend API on `localhost:5008`.

```bash
docker compose up -d
```

Keycloak admin console: `http://localhost:8180/admin`
Credentials: check your team's secrets manager.

> **Android emulator note:** The Android emulator maps `10.0.2.2` to the host machine's localhost. If you run on an Android emulator and the backend is unreachable, update the dev URLs in `AppConfig` to use `10.0.2.2` instead of `localhost`.

## 4. Run Code Generation

Required after any `@riverpod` annotation change or new file with a `part '*.g.dart'` directive:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The `--delete-conflicting-outputs` flag removes stale `.g.dart` files automatically.

## 5. Run the App

```bash
# Development (local Docker Compose stack)
flutter run --dart-define=ENV=dev

# Production
flutter run --dart-define=ENV=prod
```

## 6. Analyze and Test

```bash
flutter analyze          # must pass zero errors before merging
flutter test             # run all tests
flutter test test/widget_test.dart   # single file
```

## Troubleshooting

**`W/AppAuth: No stored state - unable to handle response` on Android**

Caused by `android:taskAffinity=""` in `AndroidManifest.xml`. This was already removed. If it reappears, check that `AndroidManifest.xml` does **not** have `android:taskAffinity` on the `MainActivity` element.

**`flutter_appauth` redirect not captured on iOS simulator**

Simulators can be unreliable with custom URL schemes. Test the OAuth flow on a physical device.

**`build_runner` fails with conflict errors**

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**CocoaPods version mismatch**

```bash
cd ios
pod repo update
pod install
```

**401 from backend API**

Check the `[API]` log lines in the terminal (LogInterceptor is active in debug builds). Verify the `Authorization: Bearer ...` header is present in the request log. If missing, the auth token may not have loaded before the first API call — tap "Retry" on the error screen.
