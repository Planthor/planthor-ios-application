import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

final mockPlanChangesProvider =
    NotifierProvider<MockPlanChangesNotifier, MockPlanChanges>(
      MockPlanChangesNotifier.new,
    );

final effectivePersonalPlansProvider = Provider<AsyncValue<List<PersonalPlan>>>(
  (ref) {
    final source = ref.watch(personalPlansProvider);
    final changes = ref.watch(mockPlanChangesProvider);

    if (source.hasError && changes.created.isNotEmpty) {
      return AsyncData(changes.apply(const []));
    }
    return source.whenData(changes.apply);
  },
);

class MockPlanChanges {
  const MockPlanChanges({
    this.created = const [],
    this.updated = const {},
    this.deletedIds = const {},
  });

  final List<PersonalPlan> created;
  final Map<String, PersonalPlan> updated;
  final Set<String> deletedIds;

  List<PersonalPlan> apply(List<PersonalPlan> source) {
    final plansById = <String, PersonalPlan>{
      for (final plan in source) plan.id: plan,
      for (final plan in created) plan.id: plan,
      ...updated,
    }..removeWhere((id, _) => deletedIds.contains(id));
    return plansById.values.toList(growable: false);
  }

  PersonalPlan? resolve(PersonalPlan plan) {
    if (deletedIds.contains(plan.id)) return null;
    return updated[plan.id] ??
        created.where((candidate) => candidate.id == plan.id).firstOrNull ??
        plan;
  }
}

class MockPlanChangesNotifier extends Notifier<MockPlanChanges> {
  @override
  MockPlanChanges build() => const MockPlanChanges();

  void create(PersonalPlan plan) {
    state = MockPlanChanges(
      created: [...state.created, plan],
      updated: state.updated,
      deletedIds: state.deletedIds,
    );
  }

  void update(PersonalPlan plan) {
    final created = [
      for (final candidate in state.created)
        if (candidate.id == plan.id) plan else candidate,
    ];
    final wasCreated = created.any((candidate) => candidate.id == plan.id);

    state = MockPlanChanges(
      created: created,
      updated: wasCreated ? state.updated : {...state.updated, plan.id: plan},
      deletedIds: {...state.deletedIds}..remove(plan.id),
    );
  }

  void delete(String planId) {
    final wasCreated = state.created.any((plan) => plan.id == planId);
    state = MockPlanChanges(
      created: state.created.where((plan) => plan.id != planId).toList(),
      updated: {...state.updated}..remove(planId),
      deletedIds: wasCreated ? state.deletedIds : {...state.deletedIds, planId},
    );
  }
}
