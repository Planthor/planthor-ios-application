import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_progress_ring.dart';

Widget _wrap(Widget w) => MaterialApp(
  home: Scaffold(body: Center(child: w)),
);

void main() {
  group('PlanProgressRing', () {
    testWidgets('renders active state (progress 0.5)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanProgressRing(progress: 0.5, icon: Icons.directions_run),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders complete state (progress >= 1.0)', (tester) async {
      await tester.pumpWidget(
        _wrap(const PlanProgressRing(progress: 1.0, icon: Icons.pool)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders overdue state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanProgressRing(
            progress: 0.3,
            icon: Icons.directions_bike,
            isOverdue: true,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders zero progress', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanProgressRing(progress: 0.0, icon: Icons.fitness_center),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders custom size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanProgressRing(
            progress: 0.7,
            icon: Icons.directions_walk,
            size: 60,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('progress > 1.0 renders without error', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PlanProgressRing(progress: 1.2, icon: Icons.fitness_center),
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
