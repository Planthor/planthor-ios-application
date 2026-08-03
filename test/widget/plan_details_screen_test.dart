import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/presentation/plan_details_screen.dart';

Widget _wrap() =>
    const ProviderScope(child: MaterialApp(home: PlanDetailsScreen()));

void main() {
  group('PlanDetailsScreen', () {
    testWidgets('renders plan summary and activity metrics', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.text('Plan Details'), findsOneWidget);
      expect(find.text('Run 100km in 2026'), findsOneWidget);
      expect(find.text('40 / 100'), findsOneWidget);
      expect(find.text('Morning Run'), findsOneWidget);
      expect(find.text('5.2 km'), findsOneWidget);
      expect(find.text('AVG PACE'), findsOneWidget);
      expect(find.text('6:45'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Afternoon Jog'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Afternoon Jog'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Tempo Run'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Tempo Run'), findsOneWidget);
    });

    testWidgets('expands and collapses activity rows', (tester) async {
      await tester.pumpWidget(_wrap());

      expect(find.text('DISTANCE'), findsOneWidget);
      await tester.tap(find.byKey(const Key('activity-Morning Run')));
      await tester.pump();
      expect(find.text('DISTANCE'), findsNothing);

      await tester.tap(find.byKey(const Key('activity-Morning Run')));
      await tester.pump();
      expect(find.text('DISTANCE'), findsOneWidget);
    });

    testWidgets('opens Figma delete confirmation from overflow menu', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());

      await tester.tap(find.byTooltip('More plan options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete plan'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Plan'), findsNWidgets(2));
      expect(find.byKey(const Key('confirm-delete-plan')), findsOneWidget);
      expect(find.byKey(const Key('cancel-delete-plan')), findsOneWidget);
    });
  });
}
