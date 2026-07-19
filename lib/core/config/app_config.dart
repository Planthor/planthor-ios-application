/// Centralized app configuration with environment-aware switching.
///
/// Use `--dart-define=ENV=prod` to target cloud services.
/// Defaults to `dev` (local infrastructure via Docker Compose).
abstract final class AppConfig {
  // Toggle via: flutter run --dart-define=ENV=prod
  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static bool get isProduction => _env == 'prod';

  // ── Keycloak ──────────────────────────────────────────────────────────
  static const _keycloakDev = 'https://auth.planthor.space/realms/planthor';
  static const _keycloakProd = 'https://auth.planthor.space/realms/planthor';
  static String get keycloakBase => isProduction ? _keycloakProd : _keycloakDev;

  static String get authEndpoint =>
      '$keycloakBase/protocol/openid-connect/auth';
  static String get tokenEndpoint =>
      '$keycloakBase/protocol/openid-connect/token';
  static String get endSessionUrl =>
      '$keycloakBase/protocol/openid-connect/logout';

  static const clientId = 'planthor-ios';
  static const redirectUri = 'planthor://callback';
  static const postLogoutUri = 'planthor://callback';
  static const scopes = ['openid', 'profile', 'email', 'offline_access'];

  /// `true` for dev (localhost HTTP), `false` for prod (HTTPS).
  static bool get allowInsecureConnections => !keycloakBase.startsWith('https');

  // ── Resource API ──────────────────────────────────────────────────────
  // Override host via: --dart-define=API_HOST=10.0.2.2 (Android emulator)
  // or --dart-define=API_HOST=<LAN IP> (physical device)
  static const _apiHost =
      String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static String get _apiDev => 'https://$_apiHost:7259';
  static const _apiProd = 'https://api.planthor.space';
  static String get apiBase => isProduction ? _apiProd : _apiDev;
}
