import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_card.dart';

Widget _wrap(Widget w) => MaterialApp(home: Scaffold(body: SingleChildScrollView(child: w)));

const _activePlan = PersonalPlan(
  id: '1',
  name: 'Run 100km',
  dateRange: 'Jan – Dec 2026',
  current: 40,
  target: 100,
  unit: 'km',
  icon: Icons.directions_run,
  status: PlanStatus.active,
  description: 'Annual running goal.',
);

const _completePlan = PersonalPlan(
  id: '2',
  name: 'Summer Swim',
  dateRange: 'Jun – Aug 2026',
  current: 50,
  target: 50,
  unit: 'km',
  icon: Icons.pool,
  status: PlanStatus.completed,
);

const _overduePlan = PersonalPlan(
  id: '3',
  name: 'Overdue Plan',
  dateRange: 'Jan – Mar 2026',
  current: 5,
  target: 100,
  unit: 'km',
  icon: Icons.directions_bike,
  status: PlanStatus.overdue,
);

void main() {
  group('PlanCard', () {
    testWidgets('renders plan name', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _activePlan)));
      expect(find.text('Run 100km'), findsOneWidget);
    });

    testWidgets('renders date range', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _activePlan)));
      expect(find.text('Jan – Dec 2026'), findsOneWidget);
    });

    testWidgets('renders unit', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _activePlan)));
      expect(find.textContaining('km'), findsWidgets);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(PlanCard(plan: _activePlan, onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(PlanCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders complete plan without error', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _completePlan)));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders overdue plan without error', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _overduePlan)));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders plan without description', (tester) async {
      const plan = PersonalPlan(id: '4', name: 'No Desc', target: 10, current: 5);
      await tester.pumpWidget(_wrap(const PlanCard(plan: plan)));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders progress percentage text', (tester) async {
      await tester.pumpWidget(_wrap(const PlanCard(plan: _activePlan)));
      expect(find.textContaining('%'), findsWidgets);
    });
  });
}
