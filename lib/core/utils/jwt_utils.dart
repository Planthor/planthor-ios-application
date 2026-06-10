import 'dart:convert';

Map<String, dynamic> decodeJwtPayload(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw FormatException('Invalid JWT: expected 3 parts');
  final normalized = base64Url.normalize(parts[1]);
  return jsonDecode(utf8.decode(base64Url.decode(normalized)))
      as Map<String, dynamic>;
}