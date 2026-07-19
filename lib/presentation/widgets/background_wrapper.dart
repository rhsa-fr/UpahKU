import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final bool isTransparentScaffold;

  const BackgroundWrapper({
    super.key,
    required this.child,
    this.isTransparentScaffold = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7FA),
      ),
      child: Stack(
        children: [
          // Top Right Emerald Blob
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald.withOpacity(isDark ? 0.07 : 0.04),
              ),
            ),
          ),
          // Bottom Left Navy/Sky Blob
          Positioned(
            bottom: -120,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navy.withOpacity(isDark ? 0.12 : 0.04),
              ),
            ),
          ),
          // Foreground Content
          child,
        ],
      ),
    );
  }
}
