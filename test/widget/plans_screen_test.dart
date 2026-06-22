import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/presentation/plans_screen.dart';

import '../helpers/fakes.dart';

Widget _wrap() => ProviderScope(
      overrides: authOverrides(),
      child: const MaterialApp(
        home: Scaffold(body: PlansScreen()),
      ),
    );

void main() {
  group('PlansScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows Plans heading', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.textContaining('Plan'), findsWidgets);
    });

    testWidgets('shows plan cards', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.textContaining('Run 100km'), findsOneWidget);
    });

    testWidgets('scrollable content', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('shows active plan status chips', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.textContaining('Active'), findsWidgets);
    });
  });
}
