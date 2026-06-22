import '../entities/auth_token.dart';

abstract interface class AuthRepository {
  Future<AuthToken> signIn();
  Future<void> signOut();
  Future<AuthToken?> getStoredToken();
  Future<AuthToken?> refreshTokens();
  Future<String?> getMemberId();
  Future<void> saveMemberId(String id);
}
