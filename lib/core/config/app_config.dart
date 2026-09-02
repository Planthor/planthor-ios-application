/// Centralized app configuration with environment-aware switching.
///
/// Use `--dart-define=ENV=prod` to target cloud services.
/// Defaults to `dev` (local infrastructure via Docker Compose).
abstract final class AppConfig {
  // Toggle via: flutter run --dart-define=ENV=prod
  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static bool get isProduction => _env == 'prod';

  static String get _defaultScheme => isProduction ? 'https' : 'http';

  // ── Keycloak ──────────────────────────────────────────────────────────

  /// Base URL for Keycloak.
  /// Resolves in this order:
  /// 1. --dart-define=KEYCLOAK_URL=... (e.g. https://my-auth.example.com)
  /// 2. --dart-define=KEYCLOAK_SCHEME/KEYCLOAK_HOST/KEYCLOAK_PORT
  /// 3. Dev defaults (uses API_HOST or localhost, port 8180) / Prod defaults
  static String get keycloakBase {
    const customUrl = String.fromEnvironment('KEYCLOAK_URL');
    if (customUrl.isNotEmpty) return '$customUrl/realms/planthor';

    const scheme = String.fromEnvironment('KEYCLOAK_SCHEME');
    const host = String.fromEnvironment('KEYCLOAK_HOST');
    const port = String.fromEnvironment('KEYCLOAK_PORT');

    final finalScheme = scheme.isNotEmpty ? scheme : _defaultScheme;
    final finalHost = host.isNotEmpty
        ? host
        : (isProduction
              ? 'auth.planthor.space'
              : const String.fromEnvironment(
                  'API_HOST',
                  defaultValue: 'localhost',
                ));
    final defaultPort = isProduction ? '' : '8180';
    final finalPort = port.isNotEmpty
        ? ':$port'
        : (defaultPort.isNotEmpty ? ':$defaultPort' : '');

    return '$finalScheme://$finalHost$finalPort/realms/planthor';
  }

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

  /// Base URL for the Resource API.
  /// Resolves in this order:
  /// 1. --dart-define=API_URL=... (e.g. https://my-api.example.com)
  /// 2. --dart-define=API_SCHEME/API_HOST/API_PORT
  /// 3. Dev defaults (localhost, port 5008) / Prod defaults
  static String get apiBase {
    const customUrl = String.fromEnvironment('API_URL');
    if (customUrl.isNotEmpty) return customUrl;

    const scheme = String.fromEnvironment('API_SCHEME');
    const host = String.fromEnvironment('API_HOST');
    const port = String.fromEnvironment('API_PORT');

    final finalScheme = scheme.isNotEmpty ? scheme : _defaultScheme;
    final finalHost = host.isNotEmpty
        ? host
        : (isProduction ? 'api.planthor.space' : 'localhost');
    final defaultPort = isProduction ? '' : '5008';
    final finalPort = port.isNotEmpty
        ? ':$port'
        : (defaultPort.isNotEmpty ? ':$defaultPort' : '');

    return '$finalScheme://$finalHost$finalPort';
  }
}
