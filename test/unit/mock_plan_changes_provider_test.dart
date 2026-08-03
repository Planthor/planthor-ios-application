import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/bloc/mock_plan_changes_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

const _source = PersonalPlan(
  id: 'source',
  name: 'Source plan',
  target: 100,
  unit: 'km',
  icon: Icons.directions_run,
);

void main() {
  group('MockPlanChangesNotifier', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('creates a session-only plan', () {
      const created = PersonalPlan(
        id: 'created',
        name: 'Created plan',
        target: 50,
      );

      container.read(mockPlanChangesProvider.notifier).create(created);

      final result = container.read(mockPlanChangesProvider).apply([_source]);
      expect(result, contains(created));
    });

    test('updates an existing plan', () {
      const updated = PersonalPlan(
        id: 'source',
        name: 'Updated plan',
        target: 120,
      );

      container.read(mockPlanChangesProvider.notifier).update(updated);

      final result = container.read(mockPlanChangesProvider).apply([_source]);
      expect(result.single.name, 'Updated plan');
      expect(result.single.target, 120);
    });

    test('deletes an existing plan', () {
      container.read(mockPlanChangesProvider.notifier).delete(_source.id);

      final result = container.read(mockPlanChangesProvider).apply([_source]);
      expect(result, isEmpty);
    });
  });
}
