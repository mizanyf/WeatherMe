import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Layered Sun and Cloud illustration matching the WeatherMe reference card.
/// Features a layered background cloud, glowing sun, and puffy front cloud.
class WeatherIllustration extends StatelessWidget {
  final double size;

  const WeatherIllustration({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft cyan cloud (upper-left)
          Positioned(
            top: size * 0.12,
            left: size * 0.08,
            child: Container(
              width: size * 0.42,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: const Color(0xFF86E7F2).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(size * 0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -size * 0.08,
                    left: size * 0.1,
                    child: Container(
                      width: size * 0.22,
                      height: size * 0.22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9BEDF5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Glowing Golden Sun (center-right)
          Positioned(
            top: size * 0.12,
            right: size * 0.08,
            child: Container(
              width: size * 0.58,
              height: size * 0.58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFFFFF099),
                    AppColors.sunnyYellow,
                    Color(0xFFFFB84D),
                  ],
                  stops: [0.2, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sunnyYellow.withValues(alpha: 0.5),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Organic Front Puffy Cloud (lower-right)
          Positioned(
            bottom: size * 0.08,
            right: size * 0.02,
            child: Container(
              width: size * 0.68,
              height: size * 0.46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Upper main cloud bump
                  Positioned(
                    top: -size * 0.16,
                    left: size * 0.18,
                    child: Container(
                      width: size * 0.34,
                      height: size * 0.34,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Left cloud bump
                  Positioned(
                    top: -size * 0.08,
                    left: size * 0.04,
                    child: Container(
                      width: size * 0.24,
                      height: size * 0.24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Front cloud accent icon/dot
                  Positioned(
                    bottom: size * 0.08,
                    left: size * 0.15,
                    child: Container(
                      width: size * 0.38,
                      height: size * 0.28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4C7B80), Color(0xFF355E64)],
                        ),
                        borderRadius: BorderRadius.circular(size * 0.14),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -size * 0.08,
                            left: size * 0.09,
                            child: Container(
                              width: size * 0.20,
                              height: size * 0.20,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4C7B80),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
