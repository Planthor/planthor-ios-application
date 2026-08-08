---
name: design-tokens
description: >-
  Use this skill when implementing UI components from Figma to ensure correct usage
  of theme colors, typography, spacing, and geometry.
---

# Planthor Design Tokens

## 1. Color Palette
Never use raw hex colors (e.g., `Color(0xFF...)`) in screen code.
All colors are defined in `lib/core/theme/app_colors.dart`.
- Access via `Theme.of(context).colorScheme` or specific extensions.
- Standard mappings:
  - Brand Primary: `#1877F2` -> `AppColors.primary`
  - Background: `#F7F9FB` -> `AppColors.background`
  - Success/Achievement: `#16A34A` -> `AppColors.success`
  - Destructive: `#BA1A1A` -> `AppColors.error`

## 2. Spacing & Geometry
Defined in `lib/core/layout/app_spacing.dart`.
- Base spacing tokens: `xs(4)`, `sm(8)`, `md(16)`, `lg(24)`, `xl(32)`, `xxl(48)`.
- Use `AppSpacing.pageMargin` (24px) for horizontal screen padding.
- `AppSpacing.cardPadding` (24px) and `AppSpacing.cardRadius` (24px).

## 3. Typography
- Defined in `lib/core/theme/app_theme.dart` using `GoogleFonts.montserratTextTheme()`.
- Access via `Theme.of(context).textTheme`.

## 4. Components
- Use `PlanthorAppBar` and `PlanthorBottomNav` instead of raw `AppBar` or `BottomNavigationBar`.
- Use `PlanCard` and `PlanProgressRing` for Plan displays.
