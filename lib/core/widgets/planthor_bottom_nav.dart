import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

/// Bottom navigation bar matching the Stitch "Updated Nav" design.
///
/// Active tab renders as a pill/capsule with [AppColors.primaryContainer]
/// background. Inactive tabs show muted icon + label.
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
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    _NavItemData(
      icon: Icons.event_note_outlined,
      activeIcon: Icons.event_note,
      label: 'Plans',
    ),
    _NavItemData(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          top: BorderSide(
            color: AppColors.borderSubtle,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = index == currentIndex;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: _NavItem(
                item: item,
                isActive: isActive,
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
    if (isActive) {
      // Active: pill/capsule background
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.activeIcon,
              size: 22,
              color: AppColors.onPrimaryContainer,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      );
    }

    // Inactive
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 22,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
