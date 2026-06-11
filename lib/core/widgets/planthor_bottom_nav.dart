import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

/// A modern bottom navigation bar matching the Figma design.
///
/// Features a floating card style with rounded corners, active indicator dot,
/// and smooth icon/label transitions.
class PlanthorBottomNav extends StatelessWidget {
  const PlanthorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItemData(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Discover',
    ),
    _NavItemData(
      icon: Icons.flag_outlined,
      activeIcon: Icons.flag,
      label: 'Plans',
    ),
    _NavItemData(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Community',
    ),
    _NavItemData(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE8EAF0),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 64,
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: _NavItem(
                  item: item,
                  isActive: isActive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
  });

  final _NavItemData item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Active indicator ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: isActive ? 32 : 0,
          height: 3,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.planBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // ── Icon ──
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isActive ? item.activeIcon : item.icon,
            key: ValueKey(isActive),
            size: 24,
            color: isActive ? AppColors.planBlue : AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 4),

        // ── Label ──
        Text(
          item.label,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.planBlue : AppColors.textGrey,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
