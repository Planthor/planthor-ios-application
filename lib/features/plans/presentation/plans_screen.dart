import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_card.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_filter_tabs.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  PlanFilter _selectedFilter = PlanFilter.all;

  // ── Demo data ──
  static const _plans = [
    PersonalPlan(
      id: '1',
      name: 'Run 100km in 2026',
      dateRange: 'Jan 1, 2026 – Dec 31, 2026',
      current: 40,
      target: 100,
      unit: 'km',
      icon: Icons.directions_run,
      status: PlanStatus.active,
      description: 'Annual running goal to improve cardio endurance.',
    ),
    PersonalPlan(
      id: '2',
      name: 'Century Challenge',
      dateRange: 'Feb 15, 2026 – May 20, 2026',
      current: 120,
      target: 161,
      unit: 'km',
      icon: Icons.directions_bike,
      status: PlanStatus.active,
      description: 'Complete a 100-mile cycling distance challenge.',
    ),
    PersonalPlan(
      id: '3',
      name: 'Summer Swim Goal',
      dateRange: 'Jun 1, 2026 – Aug 31, 2026',
      current: 50,
      target: 50,
      unit: 'km',
      icon: Icons.pool,
      status: PlanStatus.completed,
      description: 'Swim 50km total during the summer months.',
    ),
    PersonalPlan(
      id: '4',
      name: 'Morning Walk Streak',
      dateRange: 'Sep 1, 2026 – Sep 14, 2026',
      current: 12,
      target: 10,
      unit: 'walks',
      icon: Icons.directions_walk,
      status: PlanStatus.completed,
      description: 'Take a morning walk every day for two weeks.',
    ),
    PersonalPlan(
      id: '5',
      name: 'Marathon Training',
      dateRange: 'Mar 1, 2026 – Apr 10, 2026',
      current: 28,
      target: 42,
      unit: 'km',
      icon: Icons.emoji_events,
      status: PlanStatus.overdue,
      description: 'Prepare for the spring half-marathon event.',
    ),
  ];

  List<PersonalPlan> get _filteredPlans {
    return switch (_selectedFilter) {
      PlanFilter.all => _plans,
      PlanFilter.active =>
        _plans.where((p) => p.status == PlanStatus.active).toList(),
      PlanFilter.completed =>
        _plans.where((p) => p.status == PlanStatus.completed).toList(),
      PlanFilter.overdue =>
        _plans.where((p) => p.status == PlanStatus.overdue).toList(),
    };
  }

  Map<PlanFilter, int> get _filterCounts => {
        PlanFilter.all: _plans.length,
        PlanFilter.active:
            _plans.where((p) => p.status == PlanStatus.active).length,
        PlanFilter.completed:
            _plans.where((p) => p.status == PlanStatus.completed).length,
        PlanFilter.overdue:
            _plans.where((p) => p.status == PlanStatus.overdue).length,
      };

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPlans;

    return ColoredBox(
      color: const Color(0xFFF0F2F5),
      child: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _Header(
                onSync: () {},
              ),
            ),
          ),

          // ── Summary stat row ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: _SummaryRow(plans: _plans),
            ),
          ),

          // ── Filter tabs ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
              child: PlanFilterTabs(
                selected: _selectedFilter,
                counts: _filterCounts,
                onChanged: (filter) =>
                    setState(() => _selectedFilter = filter),
              ),
            ),
          ),

          // ── Plan cards ──
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: _EmptyState(filter: _selectedFilter),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, index) => PlanCard(
                  plan: filtered[index],
                  onTap: () {},
                ),
              ),
            ),

          // ── View all link ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: _ViewAllLink(count: _plans.length),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onSync});
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Plans',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.planBlue,
                letterSpacing: -0.28,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Track your fitness journey',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.planTextSub,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _CircleButton(icon: Icons.sync, onTap: onSync),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary stat row
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.plans});
  final List<PersonalPlan> plans;

  @override
  Widget build(BuildContext context) {
    final active = plans.where((p) => p.status == PlanStatus.active).length;
    final completed =
        plans.where((p) => p.status == PlanStatus.completed).length;
    final overdue = plans.where((p) => p.status == PlanStatus.overdue).length;

    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Active',
            value: '$active',
            color: AppColors.planBlueDark,
            bgColor: AppColors.planActiveLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            label: 'Done',
            value: '$completed',
            color: AppColors.planGreen,
            bgColor: AppColors.planGreenLight,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatChip(
            label: 'Overdue',
            value: '$overdue',
            color: AppColors.planOverdue,
            bgColor: AppColors.planOverdueLight,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.planChip,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.planTextSub),
      ),
    );
  }
}

class _ViewAllLink extends StatelessWidget {
  const _ViewAllLink({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.planBlueDark.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VIEW ALL PLANS',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.planBlueDark,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: AppColors.planBlueDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});
  final PlanFilter filter;

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (filter) {
      PlanFilter.all => (Icons.list_alt, 'No plans yet. Create your first!'),
      PlanFilter.active => (
          Icons.play_circle_outline,
          'No active plans right now.'
        ),
      PlanFilter.completed => (
          Icons.check_circle_outline,
          'No completed plans yet. Keep going!'
        ),
      PlanFilter.overdue => (
          Icons.warning_amber_rounded,
          'No overdue plans. Great job!'
        ),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.planChip,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 28, color: AppColors.planTextSub),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.planTextSub,
          ),
        ),
      ],
    );
  }
}
