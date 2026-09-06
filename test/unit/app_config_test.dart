import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/config/app_config.dart';

void main() {
  const production = bool.fromEnvironment('TEST_PRODUCTION');

  test('flavor keeps the app identity, endpoints, and callbacks together', () {
    expect(AppConfig.isProduction, production);
    expect(AppConfig.displayName, production ? 'Planthor' : 'Planthor Dev');
    expect(
      AppConfig.apiBase,
      production ? 'https://api.planthor.space' : 'http://localhost:5008',
    );
    expect(
      AppConfig.keycloakBase,
      production
          ? 'https://auth.planthor.space/realms/planthor'
          : 'http://localhost:8180/realms/planthor',
    );
    expect(
      AppConfig.redirectUri,
      production ? 'planthor://callback' : 'planthor-dev://callback',
    );
    expect(AppConfig.postLogoutUri, AppConfig.redirectUri);
    expect(AppConfig.allowInsecureConnections, !production);
  });
}
