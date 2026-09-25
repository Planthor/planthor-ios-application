import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';

abstract interface class MemberRepository {
  Future<Member> getCurrentMember();

  Future<void> updateAutoLink(bool value);
}
