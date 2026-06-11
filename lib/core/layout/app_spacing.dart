import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Fixed spacing tokens and context-aware layout helpers.
abstract final class AppSpacing {
  // Fixed tokens — use these for internal component spacing.
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Outer page margin, adapts to window class.
  static double pageMargin(BuildContext context) =>
      switch (context.windowClass) {
        WindowClass.compact => 16,
        WindowClass.medium => 24,
        WindowClass.expanded => 24,
      };

  /// Maximum body content width; null on compact (fills width).
  static double? maxContentWidth(BuildContext context) =>
      switch (context.windowClass) {
        WindowClass.compact => null,
        WindowClass.medium => 840,
        WindowClass.expanded => 1200,
      };

  /// Horizontal padding for page-level scrollable bodies.
  static EdgeInsets pagePadding(BuildContext context) {
    final margin = pageMargin(context);
    return EdgeInsets.symmetric(horizontal: margin, vertical: lg);
  }
}
