class AuthToken {
  const AuthToken({
    required this.accessToken,
    required this.expiresAt,
    this.refreshToken,
  });
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
