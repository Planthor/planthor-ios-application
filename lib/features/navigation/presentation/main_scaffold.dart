import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';
import 'package:planthor_ios_application/features/my_garden/presentation/garden_screen.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key, this.showWelcome = false});

  final bool showWelcome;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  void initState() {
    super.initState();
    if (widget.showWelcome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navigationProvider);
    final screens = [const DiscoveryScreen(), const GardenScreen()];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
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
