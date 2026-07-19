import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:planthor_ios_application/features/auth/data/datasources/member_datasource.dart';
import 'package:planthor_ios_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';
import 'package:planthor_ios_application/features/auth/domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _repository;

  @override
  Future<AuthToken?> build() async {
    _repository = AuthRepositoryImpl();
    final stored = await _repository.getStoredToken();
    if (stored != null) return stored;
    return _repository.refreshTokens();
  }

  Future<void> signIn() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await _repository.signIn();
      final memberId = await createMemberIfNeeded(token.accessToken);
      if (memberId != null) await _repository.saveMemberId(memberId);
      return token;
    });
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }

  Future<AuthToken?> refreshTokens() async {
    try {
      final token = await _repository.refreshTokens();
      if (token != null) {
        state = AsyncData(token);
      } else {
        await signOut();
      }
      return token;
    } catch (_) {
      await signOut();
      return null;
    }
  }
}
