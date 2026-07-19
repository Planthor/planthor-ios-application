import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/core/router/app_router.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';

import '../helpers/fakes.dart';

void main() {
  group('appRouterProvider lifecycle', () {
    // GoRouter needs the Flutter binding for internal Navigator setup.
    testWidgets('ProviderContainer dispose completes without error',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(FakeAuth.new),
          personalPlansProvider.overrideWith((ref) async => []),
        ],
      );

      // Reading triggers _AuthRefreshNotifier creation, which registers
      // ref.onDispose(sub.close) and ref.onDispose(notifier.dispose).
      container.read(appRouterProvider);

      expect(() => container.dispose(), returnsNormally);
    });

    testWidgets('sign-out redirects to /sign-in', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(FakeAuth.new),
          personalPlansProvider.overrideWith((ref) async => []),
        ],
      );
      addTearDown(container.dispose);

      final router = container.read(appRouterProvider);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Sign out → authProvider changes → _AuthRefreshNotifier fires →
      // GoRouter redirect guard pushes to /sign-in.
      await container.read(authProvider.notifier).signOut();
      await tester.pumpAndSettle();

      expect(find.text('Sign in to Planthor'), findsOneWidget);
    });
  });
}
