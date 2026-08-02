import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/layout/app_spacing.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/bloc/mock_plan_changes_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/delete_plan_dialog.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_progress_ring.dart';

class PlanDetailsScreen extends ConsumerStatefulWidget {
  const PlanDetailsScreen({super.key, this.plan});

  final PersonalPlan? plan;

  @override
  ConsumerState<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends ConsumerState<PlanDetailsScreen> {
  static const _demoPlan = PersonalPlan(
    id: 'demo-plan',
    name: 'Run 100km in 2026',
    dateRange: 'Jan 1, 2026 - Dec 31, 2026',
    current: 40,
    target: 100,
    unit: 'km',
    icon: Icons.directions_run,
  );

  static const _activities = [
    _ActivityData(
      name: 'Morning Run',
      date: 'March 25, 2026 at 7:26 AM',
      distance: '5.2 km',
      metrics: [
        _MetricData('DISTANCE', '5.2', 'km'),
        _MetricData('AVG PACE', '6:45', '/km'),
        _MetricData('MOVING TIME', '35:06'),
        _MetricData('ELEVATION GAIN', '12', 'm'),
        _MetricData('MAX ELEVATION', '8', 'm'),
        _MetricData('TOTAL STEPS', '6240'),
      ],
    ),
    _ActivityData(
      name: 'Afternoon Jog',
      date: 'March 25, 2026 at 4:15 PM',
      distance: '4.8 km',
    ),
    _ActivityData(
      name: 'Tempo Run',
      date: 'March 25, 2026 at 7:00 PM',
      distance: '6.5 km',
    ),
  ];

  final Set<int> _expandedActivities = {0};

  PersonalPlan get _plan => widget.plan ?? _demoPlan;

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(mockPlanChangesProvider).resolve(_plan) ?? _plan;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.pageMargin(context),
          AppSpacing.lg,
          AppSpacing.pageMargin(context),
          AppSpacing.xl,
        ),
        children: [
          _PageHeader(
            onEdit: () => context.push('/plans/${plan.id}/edit', extra: plan),
            onDelete: () => _confirmDelete(plan),
          ),
          const SizedBox(height: AppSpacing.lg),
          _PlanSummaryCard(plan: plan),
          const SizedBox(height: AppSpacing.xlLg),
          Text(
            'Activity',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.brand,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(_activities.length, (index) {
            final activity = _activities[index];
            final expanded = _expandedActivities.contains(index);
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _activities.length - 1 ? 0 : AppSpacing.smMd,
              ),
              child: _ActivityCard(
                key: ValueKey(activity.name),
                activity: activity,
                expanded: expanded,
                onTap: () => setState(() {
                  if (expanded) {
                    _expandedActivities.remove(index);
                  } else {
                    _expandedActivities.add(index);
                  }
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(PersonalPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => DeletePlanDialog(plan: plan),
    );
    if (confirmed != true || !mounted) return;
    ref.read(mockPlanChangesProvider.notifier).delete(plan.id);
    context.go('/plans');
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Plan Details',
            style: GoogleFonts.montserrat(
              fontSize: 28,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.brand,
              letterSpacing: -0.28,
            ),
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'More plan options',
          icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: AppSpacing.smMd),
                  Text('Edit plan'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.destructive,
                  ),
                  SizedBox(width: AppSpacing.smMd),
                  Text(
                    'Delete plan',
                    style: TextStyle(color: AppColors.destructive),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard({required this.plan});

  final PersonalPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('plan-summary-card'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A191C1E),
            blurRadius: 20,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      plan.dateRange,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        height: 1.33,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              PlanProgressRing(
                progress: plan.progress,
                icon: plan.icon,
                size: 80,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatNumber(plan.current)} / ${_formatNumber(plan.target)}',
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  plan.unit,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    height: 1.43,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${plan.progressPercent}% ACHIEVED',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              height: 1.33,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) => value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    super.key,
    required this.activity,
    required this.expanded,
    required this.onTap,
  });

  final _ActivityData activity;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${activity.name}, ${activity.distance}',
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          key: Key('activity-${activity.name}'),
          decoration: BoxDecoration(
            color: AppColors.metricSurface,
            borderRadius: BorderRadius.circular(expanded ? 24 : 12),
          ),
          clipBehavior: Clip.antiAlias,
          child: expanded
              ? _ExpandedActivity(activity: activity)
              : _CollapsedActivity(activity: activity),
        ),
      ),
    );
  }
}

class _ExpandedActivity extends StatelessWidget {
  const _ExpandedActivity({required this.activity});

  final _ActivityData activity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActivityHeader(activity: activity, expanded: true),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              for (var row = 0; row < 3; row++) ...[
                if (row > 0) const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _MetricItem(metric: activity.metrics[row * 2]),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: _MetricItem(metric: activity.metrics[row * 2 + 1]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _CollapsedActivity extends StatelessWidget {
  const _CollapsedActivity({required this.activity});

  final _ActivityData activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: _ActivityHeader(activity: activity, expanded: false),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.activity, required this.expanded});

  final _ActivityData activity;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: expanded ? const EdgeInsets.all(AppSpacing.lg) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    height: 1.43,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  activity.date,
                  style: GoogleFonts.montserrat(
                    fontSize: 11.2,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inactive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            activity.distance,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              height: 1.43,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 18,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            height: 1.5,
            fontWeight: FontWeight.w700,
            color: AppColors.brand,
            letterSpacing: 0.55,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              metric.value,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (metric.unit != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  metric.unit!,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    height: 1.33,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inactive,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ActivityData {
  const _ActivityData({
    required this.name,
    required this.date,
    required this.distance,
    this.metrics = const [],
  });

  final String name;
  final String date;
  final String distance;
  final List<_MetricData> metrics;
}

class _MetricData {
  const _MetricData(this.label, this.value, [this.unit]);

  final String label;
  final String value;
  final String? unit;
}
