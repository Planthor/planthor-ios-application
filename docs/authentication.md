# Authentication

Planthor uses **Keycloak** as the identity provider with **OAuth 2.0 Authorization Code Flow + PKCE** via `flutter_appauth`. The current implementation authenticates through Facebook as an external IDP federated into Keycloak.

## OAuth Flow

```
User taps "Sign in with Facebook"
  │
  ▼
flutter_appauth opens native browser / ASWebAuthenticationSession
  │
  ▼
Keycloak authorization endpoint
  └─ kc_idp_hint=facebook → redirects to Facebook login
  │
  ▼
User authenticates on Facebook
  │
  ▼
Keycloak exchanges Facebook token → issues authorization code
  │
  ▼
Browser redirects to planthor://callback?code=...
  │   (captured by iOS CFBundleURLTypes / Android intent-filter)
  │
  ▼
flutter_appauth exchanges code for tokens (PKCE)
  │
  ▼
KeycloakAuthDatasource persists tokens to flutter_secure_storage
  │
  ▼
authProvider state updates → main.dart routes to MainScaffold
```

## Key Classes

| Class | Path | Role |
|-------|------|------|
| `AppConfig` | `lib/core/config/app_config.dart` | Env-aware Keycloak + API endpoints |
| `AuthToken` | `lib/features/auth/domain/entities/auth_token.dart` | Token value object |
| `AuthRepository` | `lib/features/auth/domain/repositories/auth_repository.dart` | Abstract interface |
| `KeycloakAuthDatasource` | `lib/features/auth/data/datasources/keycloak_auth_datasource.dart` | OAuth + storage |
| `AuthRepositoryImpl` | `lib/features/auth/data/repositories/auth_repository_impl.dart` | Wires datasource to interface |
| `Auth` (notifier) | `lib/features/auth/presentation/providers/auth_provider.dart` | Riverpod state |

## Token Lifecycle

- **Login:** tokens stored in encrypted secure storage (AES on Android, Keychain on iOS)
- **App startup:** `build()` in `Auth` notifier calls `getStoredToken()` — auto-login if valid
- **Expiry:** `AuthToken.isExpired` checks `expiresAt`; datasource clears expired tokens on read
- **Logout:** `signOut()` clears secure storage, resets provider state to `null`
- **Refresh:** not yet implemented — expired tokens send the user back to `SignInScreen`

## Token Storage Keys (flutter_secure_storage)

| Key | Value |
|-----|-------|
| `access_token` | Raw JWT string — sent as Bearer token to the backend API |
| `refresh_token` | Raw refresh token (nullable) |
| `token_expiry` | ISO 8601 datetime string |

## AppConfig Environment Variables

Pass a single define at run time — `AppConfig` derives all endpoints from it:

```bash
flutter run --dart-define=ENV=dev    # → localhost Keycloak + API
flutter run --dart-define=ENV=prod   # → auth.planthor.space + api.planthor.space
```

| Setting | dev | prod |
|---------|-----|------|
| Keycloak base | `http://localhost:8180/realms/planthor` | `https://auth.planthor.space/realms/planthor` |
| API base | `http://localhost:5008` | `https://api.planthor.space` |
| Insecure HTTP | allowed | blocked |
| Client ID | `planthor-ios` | `planthor-ios` |
| Redirect URI | `planthor://callback` | `planthor://callback` |

All values live in `lib/core/config/app_config.dart`. No JSON config files needed.

## Platform Redirect URI Registration

The `planthor://callback` URI scheme is registered on both platforms so the OS routes the OAuth callback back to the app.

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>planthor</string></array>
  </dict>
</array>
```

**Android** (`android/app/src/main/AndroidManifest.xml`):

The `appAuthRedirectScheme` manifest placeholder in `android/app/build.gradle.kts` registers the scheme automatically via the flutter_appauth plugin's manifest merge:

```kotlin
manifestPlaceholders["appAuthRedirectScheme"] = "planthor"
```

## Android OAuth Configuration Decisions

### `android:launchMode="singleTop"` (required)

flutter_appauth requires this on `MainActivity`. When the browser redirects back to `planthor://callback`, Android delivers the intent to the **existing** Activity instance. Without `singleTop`, a new instance is created that has no AppAuth state, causing:

```
W/AppAuth: No stored state - unable to handle response
```

### `android:taskAffinity` removed

The default Flutter template includes `android:taskAffinity=""`. This was removed because an empty task affinity caused the OAuth redirect to arrive at a new task (no affinity to join an existing one), again losing AppAuth's pending request state.

### `id("kotlin-android")` removed from build.gradle.kts

The Flutter Gradle Plugin applies Kotlin internally since Flutter 3.x. Keeping the manual plugin application produced:

```
WARNING: Your Android app project applies the Kotlin Gradle Plugin,
which will cause build failures in future versions of Flutter.
```

The `kotlinOptions { jvmTarget = ... }` block remains valid because the Flutter plugin still applies Kotlin — it just manages it internally now.
