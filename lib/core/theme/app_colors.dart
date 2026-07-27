import 'package:flutter/material.dart';

class AppColors {
  // Canonical Figma semantic tokens.
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF191C1E);
  static const Color textSecondary = Color(0xFF414754);
  static const Color brand = Color(0xFF1877F2);
  static const Color brandDark = Color(0xFF0058BC);
  static const Color brandHeader = Color(0xFF1D4ED8);
  static const Color activeContainer = Color(0xFFEFF6FF);
  static const Color controlSurface = Color(0xFFECEEF0);
  static const Color metricSurface = Color(0xFFF2F4F6);
  static const Color inactive = Color(0xFF94A3B8);
  static const Color positive = Color(0xFF16A34A);
  static const Color destructive = Color(0xFFBA1A1A);

  // Primary Green Palette
  static const Color forestGreen = Color(0xFF2D5A27);
  static const Color leafGreen = Color(0xFF4CAF50);
  static const Color sageGreen = Color(0xFF8DAA91);

  // Neutral/Earth Tones
  static const Color earthBrown = Color(0xFF4E342E);
  static const Color cream = Color(0xFFF5F5DC);
  static const Color offWhite = Color(0xFFFAFAFA);

  // Functional Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  // Auth / UI Colors
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color backgroundGrey = Color(0xFFE5E5E5);
  static const Color subtitleBlue = Color(0xFF5A78A6);
  static const Color textGrey = Color(0xFFA0A0A0);

  // ── Stitch Design System Tokens ──────────────────────────────────────────
  /// Planthor Blue — primary interactive, progress rings, FAB (#18A0FB)
  static const Color planthorBlue = brand;

  /// Achievement Green — 100%+ completed plans (#34D399)
  static const Color achievementGreen = positive;

  /// Primary dark — headings, active nav labels (#00629E)
  static const Color primaryDark = brandDark;

  /// Surface background (#F5F6FF)
  static const Color surfaceBackground = background;

  /// White card surface (#FFFFFF)
  static const Color surfaceCard = surface;

  /// Primary text (#111827)
  static const Color textMain = textPrimary;

  /// Muted / secondary text (#6B7280)
  static const Color textMuted = textSecondary;

  /// Card border (#E5E7EB)
  static const Color borderSubtle = Color(0xFFE5E7EB);

  /// Primary container for active nav pill (#CCE9FF)
  static const Color primaryContainer = activeContainer;

  /// On-primary-container text (#003458)
  static const Color onPrimaryContainer = Color(0xFF003458);

  /// Surface container low – "Details" button bg (#EDF0FF)
  static const Color surfaceContainerLow = controlSurface;

  /// Surface container – subtle backgrounds (#E0E8FF)
  static const Color surfaceContainer = metricSurface;

  /// Outline / secondary icon color (#6D778E)
  static const Color outline = inactive;

  // ── Plan / Active Plans screen (legacy, kept for compatibility) ──────────
  static const Color planBlue = Color(0xFF18A0FB); // updated to Planthor Blue
  static const Color planBlueDark = Color(0xFF00629E);
  static const Color planGreen = Color(
    0xFF34D399,
  ); // updated to Achievement Green
  static const Color planTextDark = Color(0xFF111827);
  static const Color planTextSub = Color(0xFF6B7280);
  static const Color planChip = Color(0xFFECEEF0);

  // Plan status colors
  static const Color planOverdue = destructive;
  static const Color planOverdueLight = Color(0xFFFFDAD6);
  static const Color planUpcoming = Color(0xFFF59E0B);
  static const Color planUpcomingLight = Color(0xFFFEF3C7);
  static const Color planActiveLight = Color(0xFFCCE9FF);
  static const Color planGreenLight = Color(0xFFCCF5E7);

  // Error container (badge bg)
  static const Color errorContainer = Color(0xFFFB5151);
  static const Color onErrorContainer = Color(0xFF570008);

  // Progress bar
  static const Color planProgressTrack = Color(0xFFE2E8F0);

  // Filter tabs
  static const Color planFilterActive = Color(0xFF18A0FB);
  static const Color planFilterInactive = Color(0xFFE2E8F0);
  static const Color planFilterText = Color(0xFF64748B);

  // ── Connect to Apps / Strava ─────────────────────────────────────────────
  /// Strava brand orange (#FC4C02)
  static const Color stravaOrange = Color(0xFFFC4C02);

  /// Error container light — NOT CONNECTED badge bg (#FFDAD6)
  static const Color errorContainerLight = Color(0xFFFFDAD6);

  /// On-error-container dark — NOT CONNECTED badge text (#93000A)
  static const Color onErrorContainerDark = Color(0xFF93000A);
}
