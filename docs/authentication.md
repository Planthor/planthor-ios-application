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

## AppConfig Environment Variables

Set via `--dart-define-from-file`:

```json
// dart_defines/dev.json (copy from dev.example.json)
{
  "ENV": "dev",
  "KEYCLOAK_BASE_URL": "http://localhost:8180",
  "KEYCLOAK_REALM": "planthor",
  "API_BASE_URL": "http://localhost:5008",
  "CLIENT_ID": "planthor-ios"
}
```

```json
// dart_defines/prod.json (copy from prod.example.json)
{
  "ENV": "prod",
  "KEYCLOAK_BASE_URL": "https://auth.planthor.space",
  "KEYCLOAK_REALM": "planthor",
  "API_BASE_URL": "https://api.planthor.space",
  "CLIENT_ID": "planthor-ios"
}
```

`AppConfig` reads these at startup:
- `AppConfig.keycloakBaseUrl` → authorization + token endpoints
- `AppConfig.apiBaseUrl` → API calls (Phase 2+)
- `AppConfig.allowInsecureConnections` → true only when ENV=dev (localhost)

## Platform Redirect URI Registration

The `planthor://callback` URI scheme is registered on both platforms so the OS routes the OAuth callback back to the app:

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
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="planthor" android:host="callback"/>
</intent-filter>
```
