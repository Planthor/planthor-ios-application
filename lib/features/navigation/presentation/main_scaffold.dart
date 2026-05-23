import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';
import 'package:planthor_ios_application/features/plant_discovery/presentation/discovery_screen.dart';
import 'package:planthor_ios_application/features/my_garden/presentation/garden_screen.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
