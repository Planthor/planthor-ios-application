import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/presentation/plan_details_screen.dart';
import 'package:planthor_ios_application/features/plans/bloc/activity_logs_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/activity_log.dart';

Widget _wrap() => ProviderScope(
      overrides: [
        activityLogsProvider('demo-plan').overrideWith((ref) => [
              ActivityLog(
                id: 'log-1',
                planId: 'demo-plan',
                value: 5.2,
                activityLocalDate: '2026-03-25T07:26:00',
                completedDate: DateTime(2026, 3, 25, 7, 26),
                externalSourceProvider: 'Morning Run',
              ),
              ActivityLog(
                id: 'log-2',
                planId: 'demo-plan',
                value: 4.8,
                activityLocalDate: '2026-03-25T16:15:00',
                completedDate: DateTime(2026, 3, 25, 16, 15),
                externalSourceProvider: 'Afternoon Jog',
              ),
              ActivityLog(
                id: 'log-3',
                planId: 'demo-plan',
                value: 6.5,
                activityLocalDate: '2026-03-25T19:00:00',
                completedDate: DateTime(2026, 3, 25, 19, 0),
                externalSourceProvider: 'Tempo Run',
              ),
            ]),
      ],
      child: const MaterialApp(home: PlanDetailsScreen()),
    );

void main() {
  group('PlanDetailsScreen', () {
    testWidgets('renders plan summary and activity logs', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle(); // Wait for data to load

      expect(find.text('Plan Details'), findsOneWidget);
      expect(find.text('Run 100km in 2026'), findsOneWidget);
      expect(find.text('40 / 100'), findsOneWidget);
      expect(find.text('Morning Run'), findsOneWidget);
      expect(find.text('5.2 km'), findsOneWidget);

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
      await tester.pumpAndSettle();

      // Find the row. First row is expanded by default? No, wait!
      // In our code, _expandedActivities is empty by default, so it's collapsed initially.
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(3));
      expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);

      await tester.tap(find.byKey(const ValueKey('log-1')));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(2));
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('log-1')));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.keyboard_arrow_down), findsNWidgets(3));
      expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    });

    testWidgets('opens Figma delete confirmation from overflow menu', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

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
