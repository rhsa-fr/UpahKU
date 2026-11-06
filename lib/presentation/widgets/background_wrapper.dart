import 'package:flutter/material.dart';

/// Flat surface background. The Stitch screens use a single tinted canvas
/// (`bg-surface` = `#f8f9ff`) with no decorative blobs, so this is now a thin
/// wrapper that only applies the surface colour and safe-area padding.
class BackgroundWrapper extends StatelessWidget {
  const BackgroundWrapper({
    super.key,
    required this.child,
    this.isTransparentScaffold = true,
  });

  final Widget child;
  final bool isTransparentScaffold;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return ColoredBox(
      color: isTransparentScaffold ? Colors.transparent : s.surface,
      child: child,
    );
  }
}
