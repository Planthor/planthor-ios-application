import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/member_profile_provider.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';
import 'package:planthor_ios_application/features/plans/presentation/providers/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

String makeJwt({
  String name = 'Test User',
  String email = 'test@planthor.io',
  String preferredUsername = 'testuser',
}) {
  final payload = base64Url.encode(
    utf8.encode(
      jsonEncode({
        'sub': 'user-123',
        'name': name,
        'email': email,
        'preferred_username': preferredUsername,
        'given_name': name.split(' ').first,
        'family_name': name.split(' ').length > 1 ? name.split(' ').last : '',
      }),
    ),
  );
  return 'eyJhbGciOiJSUzI1NiJ9.$payload.fakesig';
}

AuthToken makeToken({bool expired = false}) => AuthToken(
  accessToken: makeJwt(),
  expiresAt: expired
      ? DateTime.now().subtract(const Duration(hours: 1))
      : DateTime.now().add(const Duration(hours: 1)),
  refreshToken: 'fake-refresh-token',
);

// Extends Auth (not _$Auth) so overrideWith type-checks correctly.
class FakeAuth extends Auth {
  FakeAuth([this._token]);
  final AuthToken? _token;

  @override
  Future<AuthToken?> build() async => _token ?? makeToken();

  @override
  Future<void> signIn() async {
    state = AsyncData(makeToken());
  }

  @override
  Future<void> signOut() async {
    state = const AsyncData(null);
  }

  @override
  Future<AuthToken?> refreshTokens() async => state.valueOrNull;
}

class FakeAuthNull extends Auth {
  @override
  Future<AuthToken?> build() async => null;

  @override
  Future<void> signIn() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthToken?> refreshTokens() async => null;
}

// Extends Navigation so overrideWith type-checks correctly.
class FakeNavigation extends Navigation {
  @override
  int build() => 0;
}

class FakeMemberProfile extends MemberProfileNotifier {
  @override
  Future<Member?> build() async => null;

  @override
  Future<void> updateAutoLink(bool value) async {}
}

List<Override> authOverrides({AuthToken? token}) => [
  authProvider.overrideWith(() => FakeAuth(token)),
  memberProfileProvider.overrideWith(FakeMemberProfile.new),
  navigationProvider.overrideWith(FakeNavigation.new),
  personalPlansProvider.overrideWith((ref) async => <PersonalPlan>[]),
];

List<Override> unauthOverrides() => [
  authProvider.overrideWith(FakeAuthNull.new),
  memberProfileProvider.overrideWith(FakeMemberProfile.new),
  navigationProvider.overrideWith(FakeNavigation.new),
  personalPlansProvider.overrideWith((ref) async => <PersonalPlan>[]),
];
