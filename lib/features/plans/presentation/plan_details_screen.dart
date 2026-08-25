import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/layout/app_spacing.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/data/plan_repository.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/activity_logs_provider.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/activity_log.dart';
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

  final Set<String> _expandedActivities = {};

  PersonalPlan get _plan => widget.plan ?? _demoPlan;

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    final activityLogsAsync = ref.watch(activityLogsProvider(plan.id));

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
          activityLogsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Text(
                    'No activities logged yet.',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }
              return Column(
                children: List.generate(logs.length, (index) {
                  final log = logs[index];
                  final expanded = _expandedActivities.contains(log.id);
                  final activityData = _ActivityData.fromLog(log, plan.unit);
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == logs.length - 1 ? 0 : AppSpacing.smMd,
                    ),
                    child: _ActivityCard(
                      key: ValueKey(log.id),
                      activity: activityData,
                      expanded: expanded,
                      onTap: () => setState(() {
                        if (expanded) {
                          _expandedActivities.remove(log.id);
                        } else {
                          _expandedActivities.add(log.id);
                        }
                      }),
                    ),
                  );
                }),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Failed to load activities.',
                style: GoogleFonts.montserrat(color: AppColors.destructive),
              ),
            ),
          ),
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

    try {
      await ref.read(planRepositoryProvider).deletePlan(plan.id);
      ref.invalidate(personalPlansProvider);
      if (mounted) context.go('/plans');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete plan: $e')));
      }
    }
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
    final hasMetrics = activity.metrics.isNotEmpty;
    final rowCount = (activity.metrics.length / 2).ceil();

    return Column(
      children: [
        _ActivityHeader(activity: activity, expanded: true),
        if (hasMetrics) ...[
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                for (var row = 0; row < rowCount; row++) ...[
                  if (row > 0) const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _MetricItem(metric: activity.metrics[row * 2]),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: row * 2 + 1 < activity.metrics.length
                            ? _MetricItem(metric: activity.metrics[row * 2 + 1])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
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

  factory _ActivityData.fromLog(ActivityLog log, String planUnit) {
    // Basic date formatting
    final dt = log.completedDate;
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final timePrefix = dt.hour < 12 ? 'AM' : 'PM';
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final formattedDate = '${months[dt.month]} ${dt.day}, ${dt.year} at $hour:$minute $timePrefix';
    
    // Formatting distance with unit
    final formattedDistance = log.value == log.value.truncateToDouble()
        ? '${log.value.toInt()} $planUnit'
        : '${log.value} $planUnit';
        
    return _ActivityData(
      name: log.externalSourceProvider ?? 'Activity',
      date: formattedDate,
      distance: formattedDistance,
      metrics: const [], // Metrics omitted as they are not currently returned from backend
    );
  }

  final String name;
  final String date;
  final String distance;
  final List<_MetricData> metrics;
}

class _MetricData {
  const _MetricData(this.label, this.value);

  final String label;
  final String value;
}
