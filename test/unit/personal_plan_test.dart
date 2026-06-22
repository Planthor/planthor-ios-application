import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

void main() {
  group('PersonalPlan', () {
    test('fromJson maps id and name', () {
      final plan = PersonalPlan.fromJson({'id': '1', 'name': 'My Plan'});
      expect(plan.id, '1');
      expect(plan.name, 'My Plan');
    });

    test('fromJson uses (unnamed) when name is null', () {
      final plan = PersonalPlan.fromJson({'id': '2', 'name': null});
      expect(plan.name, '(unnamed)');
    });

    test('progress clamps to 0 when target is 0', () {
      const plan = PersonalPlan(id: '1', name: 'Test', target: 0, current: 5);
      expect(plan.progress, 0.0);
    });

    test('progress clamps to 1 when current exceeds target', () {
      const plan =
          PersonalPlan(id: '1', name: 'Test', target: 10, current: 20);
      expect(plan.progress, 1.0);
    });

    test('progressPercent rounds correctly', () {
      const plan =
          PersonalPlan(id: '1', name: 'Test', target: 3, current: 1);
      expect(plan.progressPercent, 33);
    });

    test('isComplete is true when progress >= 1', () {
      const plan =
          PersonalPlan(id: '1', name: 'Test', target: 10, current: 10);
      expect(plan.isComplete, isTrue);
    });

    test('isComplete is false when progress < 1', () {
      const plan =
          PersonalPlan(id: '1', name: 'Test', target: 10, current: 5);
      expect(plan.isComplete, isFalse);
    });

    test('default icon is fitness_center', () {
      const plan = PersonalPlan(id: '1', name: 'Test');
      expect(plan.icon, Icons.fitness_center);
    });

    test('default status is active', () {
      const plan = PersonalPlan(id: '1', name: 'Test');
      expect(plan.status, PlanStatus.active);
    });
  });

  group('PlanStatus', () {
    test('labels are correct', () {
      expect(PlanStatus.active.label, 'Active');
      expect(PlanStatus.completed.label, 'Completed');
      expect(PlanStatus.overdue.label, 'Overdue');
      expect(PlanStatus.upcoming.label, 'Upcoming');
    });
  });
}
