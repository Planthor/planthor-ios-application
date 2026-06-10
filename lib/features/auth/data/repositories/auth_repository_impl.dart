import 'package:planthor_ios_application/features/auth/data/datasources/keycloak_auth_datasource.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';
import 'package:planthor_ios_application/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final KeycloakAuthDatasource _datasource;

  AuthRepositoryImpl({KeycloakAuthDatasource? datasource})
      : _datasource = datasource ?? KeycloakAuthDatasource();

  @override
  Future<AuthToken> signIn() => _datasource.signIn();

  @override
  Future<void> signOut() => _datasource.clearTokens();

  @override
  Future<AuthToken?> getStoredToken() => _datasource.getStoredToken();

  @override
  Future<AuthToken?> refreshTokens() => _datasource.refreshTokens();
}
