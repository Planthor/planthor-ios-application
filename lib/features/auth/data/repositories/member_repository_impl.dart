import 'package:dio/dio.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';
import 'package:planthor_ios_application/features/auth/domain/repositories/member_repository.dart';

class MemberRepositoryImpl implements MemberRepository {
  MemberRepositoryImpl(this._dio);

  final Dio _dio;

  // The backend resolves the authenticated identity to its Planthor member ID.
  static const _currentMemberPath = '/v1/members/me';

  @override
  Future<Member> getCurrentMember() async {
    final response = await _dio.get(_currentMemberPath);
    return Member.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> updateAutoLink(bool value) async {
    await _dio.patch(
      _currentMemberPath,
      data: {
        'autoLinkUserAdapterToPlan': value,
        'updateMask': ['autoLinkUserAdapterToPlan'],
      },
    );
  }
}
