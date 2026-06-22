import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';

void main() {
  group('AuthToken', () {
    test('isExpired returns false when expiresAt is in the future', () {
      final token = AuthToken(
        accessToken: 'abc',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(token.isExpired, isFalse);
    });

    test('isExpired returns true when expiresAt is in the past', () {
      final token = AuthToken(
        accessToken: 'abc',
        expiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      expect(token.isExpired, isTrue);
    });

    test('refreshToken is nullable', () {
      final token = AuthToken(
        accessToken: 'abc',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(token.refreshToken, isNull);
    });

    test('stores refreshToken when provided', () {
      final token = AuthToken(
        accessToken: 'abc',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        refreshToken: 'refresh',
      );
      expect(token.refreshToken, 'refresh');
    });
  });
}
