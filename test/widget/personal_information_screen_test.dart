import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/auth/presentation/personal_information_screen.dart';

import '../helpers/fakes.dart';

Widget _wrap() => ProviderScope(
  overrides: authOverrides(),
  child: const MaterialApp(home: PersonalInformationScreen()),
);

Widget _wrapNull() => ProviderScope(
  overrides: unauthOverrides(),
  child: const MaterialApp(home: PersonalInformationScreen()),
);

void main() {
  group('PersonalInformationScreen', () {
    testWidgets('renders without error with token', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Personal Information heading', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Personal Information'), findsOneWidget);
    });

    testWidgets('shows subtitle text', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.textContaining('profile details'), findsOneWidget);
    });

    testWidgets('shows First Name field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('First Name'), findsOneWidget);
    });

    testWidgets('shows Last Name field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Last Name'), findsOneWidget);
    });

    testWidgets('shows Email Address field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Email Address'), findsOneWidget);
    });

    testWidgets('shows Description field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('shows Save Changes button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Save Changes'), findsOneWidget);
    });

    testWidgets('shows fallback display name while auth is loading', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('User'), findsOneWidget);
    });

    testWidgets('Save Changes shows snackbar', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      expect(find.textContaining('Profile update'), findsOneWidget);
    });

    testWidgets('renders without error when no token', (tester) async {
      await tester.pumpWidget(_wrapNull());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('back button visible in app bar', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
