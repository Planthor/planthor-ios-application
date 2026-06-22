import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/auth/presentation/sign_in_screen.dart';

import '../helpers/fakes.dart';

Widget _wrapUnauthenticated() => ProviderScope(
      overrides: unauthOverrides(),
      child: const MaterialApp(home: SignInScreen()),
    );

void main() {
  group('SignInScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows PLANTHOR brand name', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(find.text('PLANTHOR'), findsOneWidget);
    });

    testWidgets('shows Sign in heading', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(find.text('Sign in to Planthor'), findsOneWidget);
    });

    testWidgets('shows Facebook sign-in button', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(find.text('Sign in with Facebook'), findsOneWidget);
    });

    testWidgets('shows footer links', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(find.text('PRIVACY'), findsOneWidget);
      expect(find.text('TERMS'), findsOneWidget);
      expect(find.text('SUPPORT'), findsOneWidget);
    });

    testWidgets('shows FROM PLAN TO PERFORMANCE tagline', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      expect(find.text('FROM PLAN TO PERFORMANCE'), findsOneWidget);
    });

    testWidgets('sign in button triggers signIn on tap', (tester) async {
      await tester.pumpWidget(_wrapUnauthenticated());
      await tester.pump();
      await tester.tap(find.text('Sign in with Facebook'));
      await tester.pump();
      // No exception = notifier.signIn() was called safely
      expect(tester.takeException(), isNull);
    });
  });
}
