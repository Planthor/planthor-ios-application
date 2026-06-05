import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    return _repository.getStoredToken();
  }

  Future<void> signIn() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.signIn);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncData(null);
  }
}
