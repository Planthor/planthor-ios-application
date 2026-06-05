import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:planthor_ios_application/core/config/app_config.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';

class KeycloakAuthDatasource {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _tokenExpiryKey = 'token_expiry';

  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  KeycloakAuthDatasource({
    FlutterAppAuth? appAuth,
    FlutterSecureStorage? storage,
  })  : _appAuth = appAuth ?? const FlutterAppAuth(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<AuthToken> signIn() async {
    final result = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AppConfig.clientId,
        AppConfig.redirectUri,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: AppConfig.authEndpoint,
          tokenEndpoint: AppConfig.tokenEndpoint,
          endSessionEndpoint: AppConfig.endSessionUrl,
        ),
        scopes: AppConfig.scopes,
        additionalParameters: const {'kc_idp_hint': 'facebook'},
        allowInsecureConnections: AppConfig.allowInsecureConnections,
      ),
    );

    if (result.accessToken == null ||
        result.accessTokenExpirationDateTime == null) {
      throw Exception('Sign in failed: no token received from Keycloak');
    }

    final token = AuthToken(
      accessToken: result.accessToken!,
      refreshToken: result.refreshToken,
      expiresAt: result.accessTokenExpirationDateTime!,
    );

    await _persistToken(token);
    return token;
  }

  Future<AuthToken?> getStoredToken() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    final expiryStr = await _storage.read(key: _tokenExpiryKey);

    if (accessToken == null || expiryStr == null) return null;

    final token = AuthToken(
      accessToken: accessToken,
      refreshToken: await _storage.read(key: _refreshTokenKey),
      expiresAt: DateTime.parse(expiryStr),
    );

    if (token.isExpired) {
      await clearTokens();
      return null;
    }

    return token;
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<void> _persistToken(AuthToken token) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: token.accessToken),
      _storage.write(
        key: _tokenExpiryKey,
        value: token.expiresAt.toIso8601String(),
      ),
      if (token.refreshToken != null)
        _storage.write(key: _refreshTokenKey, value: token.refreshToken!),
    ]);
  }
}
