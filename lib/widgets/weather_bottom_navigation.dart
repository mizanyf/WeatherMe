import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Modernized Glassmorphism Bottom Navigation Bar for WeatherMe.
///
/// Features:
/// - Floating frosted glass pill capsule with high-sigma Gaussian blur.
/// - Crisp luminous glass highlight border (`Colors.white.withValues(alpha: 0.85)`).
/// - Dynamic active capsule with smooth sky-blue gradient and soft ambient glow.
/// - Refined [Outfit] typography with crisp contrast.
class WeatherBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const WeatherBottomNavigation({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE0F7FC).withValues(alpha: 0.88), // Soft Ice Sky #48CBE8 tint
            const Color(0xFFF0FDFE).withValues(alpha: 0.92), // Frosted Pure White-Blue
            const Color(0xFFBAE6FD).withValues(alpha: 0.82), // Ambient Blue Accent
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma,
            sigmaY: AppColors.glassBlurSigma,
          ),
          child: Stack(
            children: [
              // Subtle ambient depth highlight
              Positioned(
                right: -20,
                top: -15,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // 1. Home / Beranda
                    _buildNavItem(
                      index: 0,
                      customIcon: _buildBerandaIcon(currentIndex == 0),
                      label: 'Beranda',
                      isActive: currentIndex == 0,
                    ),

                    // 2. Calendar / Kalender
                    _buildNavItem(
                      index: 1,
                      icon: Icons.calendar_month_rounded,
                      label: 'Kalender',
                      isActive: currentIndex == 1,
                    ),

                    // 3. Locations / Lokasi
                    _buildNavItem(
                      index: 2,
                      icon: currentIndex == 2
                          ? Icons.location_on_rounded
                          : Icons.location_on_outlined,
                      label: 'Lokasi',
                      isActive: currentIndex == 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBerandaIcon(bool isActive) {
    return SizedBox(
      width: 22,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 11,
              color: isActive ? Colors.white : AppColors.mutedText,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(
              Icons.cloud_rounded,
              size: 15,
              color: isActive ? Colors.white : AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    IconData? icon,
    Widget? customIcon,
    required String label,
    required bool isActive,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!(index);
          }
        },
        borderRadius: BorderRadius.circular(22.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          padding: isActive
              ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0)
              : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF48CBE8), // WeatherMe Vibrant sky #48CBE8
                      Color(0xFF0284C7), // Deep azure
                    ],
                  )
                : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(22.0),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customIcon ??
                  Icon(
                    icon,
                    size: 20,
                    color: isActive ? Colors.white : AppColors.mutedText,
                  ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.mutedText,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
