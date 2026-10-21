import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// App-wide modern background widget featuring an airy white/ice canvas
/// accented by subtle ethereal sky-blue glass glows at the top-left and
/// bottom-right corners.
///
/// Designed so that clean white remains dominant while providing modern
/// visual depth and lighting for glassmorphic elements above it.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Dominant clean white/ice base canvas
        Positioned.fill(
          child: Container(
            color: AppColors.background,
          ),
        ),

        // 2. Subtle modern blue glass glow — Top-Left Corner
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.2),
                radius: 0.75,
                colors: [
                  const Color(0xFF48CBE8).withValues(alpha: 0.20),
                  const Color(0xFFBAE6FD).withValues(alpha: 0.12),
                  const Color(0xFFE0F2FE).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.40, 0.70, 1.0],
              ),
            ),
          ),
        ),

        // Additional soft frosted glass highlight orb (top-left)
        Positioned(
          top: -30,
          left: -30,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  const Color(0xFFE0F7FC).withValues(alpha: 0.20),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.50, 1.0],
              ),
            ),
          ),
        ),

        // 3. Subtle modern azure glass glow — Bottom-Right Corner
        Positioned(
          bottom: -90,
          right: -90,
          child: Container(
            width: 340,
            height: 340,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(0.2, 0.2),
                radius: 0.75,
                colors: [
                  const Color(0xFF0284C7).withValues(alpha: 0.15),
                  const Color(0xFF48CBE8).withValues(alpha: 0.10),
                  const Color(0xFFBAE6FD).withValues(alpha: 0.04),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.38, 0.68, 1.0],
              ),
            ),
          ),
        ),

        // Additional soft frosted glass highlight orb (bottom-right)
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.40),
                  const Color(0xFFBAE6FD).withValues(alpha: 0.18),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.50, 1.0],
              ),
            ),
          ),
        ),

        // 4. Foreground content
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
