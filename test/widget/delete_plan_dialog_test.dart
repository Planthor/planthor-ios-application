import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/delete_plan_dialog.dart';

const _plan = PersonalPlan(
  id: '1',
  name: 'Run 100km in 2026',
  dateRange: 'Jan 1, 2026 - Dec 31, 2026',
  current: 40,
  target: 100,
  unit: 'km',
);

void main() {
  testWidgets('renders Figma delete confirmation content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: DeletePlanDialog(plan: _plan)),
      ),
    );

    expect(find.text('Delete Plan'), findsNWidgets(2));
    expect(find.text('Run 100km in 2026'), findsOneWidget);
    expect(find.text('40% Achieved'), findsOneWidget);
    expect(
      find.text(
        'Are you sure you want to delete this plan? This action cannot be undone.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('confirm-delete-plan')), findsOneWidget);
    expect(find.byKey(const Key('cancel-delete-plan')), findsOneWidget);
  });
}
