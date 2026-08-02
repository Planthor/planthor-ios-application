import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/layout/app_spacing.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/mock_plan_changes_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_card.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(stravaConnectionProvider) == StravaConnectionStatus.connected;
    final plansAsync = ref.watch(effectivePersonalPlansProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/plans/new'),
        tooltip: 'Create plan',
        child: const Icon(Icons.add, size: 24),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.pageMargin(context),
                    AppSpacing.lg,
                    AppSpacing.pageMargin(context),
                    0,
                  ),
                  child: _Header(isConnected: isConnected),
                ),
              ),
              ...plansAsync.when(
                loading: () => const [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _LoadingState(),
                  ),
                ],
                error: (error, _) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ErrorState(
                      onRetry: () => ref.invalidate(personalPlansProvider),
                    ),
                  ),
                ],
                data: (plans) {
                  if (plans.isEmpty) {
                    return const [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(),
                      ),
                    ];
                  }

                  return [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.pageMargin(context),
                        AppSpacing.lg,
                        AppSpacing.pageMargin(context),
                        AppSpacing.sm,
                      ),
                      sliver: SliverList.separated(
                        itemCount: plans.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.lg),
                        itemBuilder: (_, index) => PlanCard(
                          plan: plans[index],
                          onTap: () => context.push(
                            '/plans/${plans[index].id}',
                            extra: plans[index],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.md,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        child: _ViewAllLink(count: plans.length),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: Key('plans-loading'),
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('plans-error'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: AppColors.inactive,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load plans',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.isConnected});
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Active Plans',
            maxLines: 1,
            style: GoogleFonts.montserrat(
              fontSize: 28,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.brand,
              letterSpacing: -0.28,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Connection status chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isConnected
                ? AppColors.planGreenLight
                : AppColors.planOverdueLight,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isConnected ? Icons.link : Icons.link_off,
                size: 13,
                color: isConnected
                    ? AppColors.achievementGreen
                    : AppColors.planOverdue,
              ),
              const SizedBox(width: 4),
              Text(
                isConnected ? 'CONNECTED' : 'NOT CONNECTED',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isConnected
                      ? AppColors.achievementGreen
                      : AppColors.planOverdue,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('plans-empty'),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.xl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular icon container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainer,
              border: Border.all(color: AppColors.surfaceBackground, width: 4),
              boxShadow: const [
                BoxShadow(color: Color(0x08000000), blurRadius: 40),
              ],
            ),
            child: Icon(
              Icons.event_busy_outlined,
              size: 56,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'No Active Plans Yet',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "You don't have any active performance plans. Start your journey today!",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View all link
// ─────────────────────────────────────────────────────────────────────────────

class _ViewAllLink extends StatelessWidget {
  const _ViewAllLink({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'VIEW ALL PLANS',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.planthorBlue,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward,
              size: 14,
              color: AppColors.planthorBlue,
            ),
          ],
        ),
      ),
    );
  }
}
