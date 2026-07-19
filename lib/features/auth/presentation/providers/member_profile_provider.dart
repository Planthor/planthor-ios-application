import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';

final memberProfileProvider = FutureProvider<Member?>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.valueOrNull == null) return null;

  final memberId = await AuthRepositoryImpl().getMemberId();
  if (memberId == null) return null;

  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/Members/$memberId');
  return Member.fromJson(response.data as Map<String, dynamic>);
});
