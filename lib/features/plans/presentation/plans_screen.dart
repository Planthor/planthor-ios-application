import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_card.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isConnected = false; // TODO: wire to real connectivity provider

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.planthorBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 8,
        child: const Icon(Icons.add, size: 24),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _Header(isConnected: isConnected),
            ),
          ),

          // ── Plan cards ──
          if (_plans.isEmpty)
            const SliverToBoxAdapter(child: _EmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              sliver: SliverList.separated(
                itemCount: _plans.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, index) => PlanCard(
                  plan: _plans[index],
                  onTap: () {},
                ),
              ),
            ),

          // ── View all link ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
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
  const _Header({required this.isConnected});
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Active Plans',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.planthorBlue,
            letterSpacing: -0.3,
          ),
        ),
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
                style: GoogleFonts.inter(
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
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
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
              border: Border.all(
                color: AppColors.surfaceBackground,
                width: 4,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 40,
                ),
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
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "You don't have any active performance plans. Start your journey today!",
            style: GoogleFonts.inter(
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
              style: GoogleFonts.inter(
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
