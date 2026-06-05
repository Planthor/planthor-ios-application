class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const AuthToken({
    required this.accessToken,
    required this.expiresAt,
    this.refreshToken,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
