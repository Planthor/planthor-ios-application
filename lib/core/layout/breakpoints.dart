import 'package:flutter/material.dart';

/// Material 3 window size classes.
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
enum WindowClass { compact, medium, expanded }

extension WindowClassContext on BuildContext {
  WindowClass get windowClass {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) return WindowClass.compact;
    if (width < 840) return WindowClass.medium;
    return WindowClass.expanded;
  }

  bool get isCompact => windowClass == WindowClass.compact;
  bool get isMedium => windowClass == WindowClass.medium;
  bool get isExpanded => windowClass == WindowClass.expanded;

  /// True for medium or expanded — both use side navigation.
  bool get useSideNav => !isCompact;
}
