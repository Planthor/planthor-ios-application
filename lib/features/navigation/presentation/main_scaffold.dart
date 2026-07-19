import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';
import 'package:planthor_ios_application/core/widgets/planthor_app_bar.dart';
import 'package:planthor_ios_application/core/widgets/planthor_bottom_nav.dart';
import 'package:planthor_ios_application/features/auth/domain/entities/auth_token.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  static const _tabRoutes = ['/home', '/plans', '/settings'];

  bool _welcomeShown = false;

  int _indexFromLocation(String location) {
    if (location.startsWith('/plans')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  void _onTabTap(int newIndex) {
    context.go(_tabRoutes[newIndex]);
  }

  String _resolveDisplayName(AuthToken token) {
    try {
      final claims = decodeJwtPayload(token.accessToken);
      return claims['name'] as String? ??
          claims['preferred_username'] as String? ??
          'User';
    } catch (_) {
      return 'User';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthToken?>>(authProvider, (prev, next) {
      if (prev?.valueOrNull == null &&
          next.valueOrNull != null &&
          !_welcomeShown) {
        _welcomeShown = true;
        final name = _resolveDisplayName(next.valueOrNull!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.forestGreen,
                content: Text(
                  'Welcome, $name!',
                  style: const TextStyle(color: Colors.white),
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        });
      }
    });

    // Eagerly watch to trigger MemberSessionFilter JIT provisioning on first load.
    ref.watch(personalPlansProvider);

    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: const PlanthorAppBar(),
      body: widget.child,
      bottomNavigationBar: PlanthorBottomNav(
        currentIndex: selectedIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
