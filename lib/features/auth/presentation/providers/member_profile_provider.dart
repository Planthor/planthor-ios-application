import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/auth/data/repositories/member_repository_impl.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/member.dart';
import 'package:planthor_ios_application/features/auth/domain/repositories/member_repository.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(ref.watch(apiClientProvider));
});

class MemberProfileNotifier extends AsyncNotifier<Member?> {
  @override
  Future<Member?> build() async {
    final authState = ref.watch(authProvider);
    final token = authState.valueOrNull;
    if (token == null) return null;

    final repository = ref.watch(memberRepositoryProvider);
    try {
      return await repository.getCurrentMember();
    } catch (_) {
      return null;
    }
  }

  Future<void> updateAutoLink(bool value) async {
    if (ref.read(authProvider).valueOrNull == null) return;

    final currentMember = state.valueOrNull;

    // Optimistic update if we have a current member
    if (currentMember != null) {
      state = AsyncData(
        currentMember.copyWith(autoLinkPlansAndActivityApplications: value),
      );
    }

    try {
      await ref.read(memberRepositoryProvider).updateAutoLink(value);
      // Load the saved profile if the initial read was unavailable.
      if (currentMember == null) {
        ref.invalidateSelf();
      }
    } catch (e, stackTrace) {
      // Revert state on failure
      if (currentMember != null) {
        state = AsyncData(currentMember);
      }
      log(
        'Failed to update auto link',
        name: 'MemberProfile',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

final memberProfileProvider =
    AsyncNotifierProvider<MemberProfileNotifier, Member?>(
      MemberProfileNotifier.new,
    );
