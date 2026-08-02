import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/auth/presentation/account_deleted_screen.dart';

import '../helpers/fakes.dart';

Widget _wrap() => ProviderScope(
  overrides: authOverrides(),
  child: const MaterialApp(home: AccountDeletedScreen()),
);

void main() {
  group('AccountDeletedScreen', () {
    testWidgets('matches Figma success content', (tester) async {
      tester.view.physicalSize = const Size(422, 896);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Account Deleted\nSuccessfully'), findsOneWidget);
      expect(
        find.text(
          'Your data has been permanently erased in compliance with privacy regulations',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('register for a new account'), findsOneWidget);
      expect(
        find.byKey(const Key('acknowledge-account-deletion')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('acknowledgement signs user out', (tester) async {
      tester.view.physicalSize = const Size(422, 896);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap());
      await tester.pump();
      await tester.tap(find.byKey(const Key('acknowledge-account-deletion')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
