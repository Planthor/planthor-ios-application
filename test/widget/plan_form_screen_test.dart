import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/plan_form_screen.dart';

const _plan = PersonalPlan(
  id: '1',
  name: 'Run 100km in 2026',
  dateRange: 'Jan 1, 2026 - Dec 31, 2026',
  current: 40,
  target: 100,
  unit: 'km',
  icon: Icons.directions_run,
);

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

void main() {
  group('PlanFormScreen', () {
    testWidgets('renders empty create form with disabled save', (tester) async {
      await tester.pumpWidget(_wrap(const PlanFormScreen()));

      expect(find.bySemanticsLabel('Create New Plan'), findsOneWidget);
      expect(find.byKey(const Key('plan-name-field')), findsOneWidget);
      expect(find.byKey(const Key('sport-type-field')), findsOneWidget);
      expect(find.byKey(const Key('target-distance-field')), findsOneWidget);
      expect(find.text('SAVE PLAN'), findsOneWidget);

      final button = tester.widget<FilledButton>(
        find.byKey(const Key('save-plan-button')),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('prefills edit form from mock plan', (tester) async {
      await tester.pumpWidget(_wrap(const PlanFormScreen(plan: _plan)));

      expect(find.bySemanticsLabel('Edit Plan'), findsOneWidget);
      expect(find.text('Run 100km in 2026'), findsOneWidget);
      expect(find.text('100.0'), findsOneWidget);
      expect(find.text('January, 1st, 2026'), findsOneWidget);
      expect(find.text('December, 31st, 2026'), findsOneWidget);
      expect(find.text('UPDATE PLAN'), findsOneWidget);
    });

    testWidgets('shows Figma name-length validation', (tester) async {
      await tester.pumpWidget(_wrap(const PlanFormScreen(plan: _plan)));
      await tester.enterText(
        find.byKey(const Key('plan-name-field')),
        'A plan name that is intentionally longer than fifty characters total',
      );
      tester.state<FormState>(find.byType(Form)).validate();
      await tester.pump();

      expect(
        find.text('Plan name cannot exceed 50 characters'),
        findsOneWidget,
      );
    });

    testWidgets('fits 390px compact canvas without overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(const PlanFormScreen(plan: _plan)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
