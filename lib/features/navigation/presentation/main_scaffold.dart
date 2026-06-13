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

class _MainScaffoldState extends ConsumerState<MainScaffold>
    with SingleTickerProviderStateMixin {
  bool _welcomeShown = false;
  int _displayIndex = 0;
  int _animatingIndex = 0;
  int _direction = 1;
  late final AnimationController _slideController;
  late Animation<Offset> _enterAnimation;

  static const _screens = [
    DiscoveryScreen(),
    PlansScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _enterAnimation = _buildEnterAnimation();
    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _displayIndex = _animatingIndex;
          _slideController.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Animation<Offset> _buildEnterAnimation() {
    return Tween<Offset>(
      begin: Offset(_direction.toDouble(), 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));
  }

  void _onTabTap(int newIndex) {
    if (newIndex == _displayIndex) return;
    setState(() {
      _direction = newIndex > _displayIndex ? 1 : -1;
      _animatingIndex = newIndex;
      _enterAnimation = _buildEnterAnimation();
    });
    _slideController.forward(from: 0);
    ref.read(navigationProvider.notifier).setIndex(newIndex);
  }

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

    final bool isAnimating = _slideController.isAnimating ||
        _animatingIndex != _displayIndex;

    return Scaffold(
      appBar: const PlanthorAppBar(),
      body: Stack(
        children: [
          _screens[_displayIndex],
          if (isAnimating)
            SlideTransition(
              position: _enterAnimation,
              child: _screens[_animatingIndex],
            ),
        ],
      ),
      bottomNavigationBar: PlanthorBottomNav(
        currentIndex: selectedIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
