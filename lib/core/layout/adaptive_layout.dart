import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Renders the builder matching the current [WindowClass].
/// Falls back up the chain: expanded → medium → compact.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) {
    return switch (context.windowClass) {
      WindowClass.expanded => (expanded ?? medium ?? compact)(context),
      WindowClass.medium => (medium ?? compact)(context),
      WindowClass.compact => compact(context),
    };
  }
}
