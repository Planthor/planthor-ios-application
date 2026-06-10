import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/core/utils/jwt_utils.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';
import 'package:planthor_ios_application/features/my_garden/presentation/garden_screen.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, this.showWelcome = false});

  final bool showWelcome;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  bool _welcomeShown = false;

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

    final selectedIndex = ref.watch(navigationProvider);
    final screens = [
      const DiscoveryScreen(),
      GardenScreen(claims: claims),
    ];
    final tabTitles = ['Discover', 'My Garden'];

    return Scaffold(
      appBar: AppBar(
        title: Text(tabTitles[selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.forestGreen,
        unselectedItemColor: AppColors.textGrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: 'My Garden',
          ),
        ],
      ),
    );
  }
}
