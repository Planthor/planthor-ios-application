import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';

String _makeJwt(Map<String, dynamic> payload) {
  final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
  return 'header.$encoded.signature';
}

void main() {
  group('decodeJwtPayload', () {
    test('decodes standard claims', () {
      final jwt = _makeJwt({'sub': '123', 'name': 'Alice', 'email': 'a@b.com'});
      final claims = decodeJwtPayload(jwt);
      expect(claims['sub'], '123');
      expect(claims['name'], 'Alice');
      expect(claims['email'], 'a@b.com');
    });

    test('decodes payload with padding needed', () {
      // Ensure base64 padding edge case is handled by testing a longer payload.
      final jwt = _makeJwt({
        'sub': 'user-abc-def-ghi-jkl',
        'preferred_username': 'testuser',
      });
      final claims = decodeJwtPayload(jwt);
      expect(claims['preferred_username'], 'testuser');
    });

    test('throws FormatException for non-JWT string', () {
      expect(() => decodeJwtPayload('not.a.valid.jwt.string'),
          throwsA(isA<FormatException>()));
    });

    test('throws FormatException when parts != 3', () {
      expect(() => decodeJwtPayload('only.twoparts'),
          throwsA(isA<FormatException>()));
    });
  });
}
