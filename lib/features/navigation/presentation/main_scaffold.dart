import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';
import 'package:planthor_ios_application/core/widgets/planthor_app_bar.dart';
import 'package:planthor_ios_application/core/widgets/planthor_bottom_nav.dart';
import 'package:planthor_ios_application/features/auth/presentation/profile_screen.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/community/screens/community_screen.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';
import 'package:planthor_ios_application/features/plans/presentation/plans_screen.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, this.showWelcome = false});

  final bool showWelcome;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  bool _welcomeShown = false;

  static const _screens = [
    DiscoveryScreen(),
    PlansScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final tokenAsync = ref.watch(authProvider);
    final token = tokenAsync.valueOrNull;

    Map<String, dynamic>? claims;
    if (token != null) {
      try {
        claims = decodeJwtPayload(token.accessToken);
      } catch (_) {}
    }

    final displayName = claims?['name'] as String? ??
        claims?['preferred_username'] as String? ??
        'User';

    if (widget.showWelcome && !_welcomeShown && claims != null) {
      _welcomeShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.forestGreen,
              content: Text(
                'Welcome, $displayName!',
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });
    }

    // Eagerly watch to trigger MemberSessionFilter JIT provisioning on first load.
    ref.watch(personalPlansProvider);

    final selectedIndex = ref.watch(navigationProvider);

    return Scaffold(
      appBar: const PlanthorAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: PlanthorBottomNav(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(navigationProvider.notifier).setIndex(index),
      ),
    );
  }
}
