import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WeatherBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const WeatherBottomNavigation({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(36.0),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Home / Beranda (Active)
          _buildNavItem(
            index: 0,
            customIcon: _buildBerandaIcon(currentIndex == 0),
            label: 'Beranda',
            isActive: currentIndex == 0,
          ),

          // 2. Calendar / Kalender (Inactive placeholder)
          _buildNavItem(
            index: 1,
            icon: Icons.calendar_month_outlined,
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
    );
  }

  Widget _buildBerandaIcon(bool isActive) {
    return SizedBox(
      width: 24,
      height: 22,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 1,
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 13,
              color: isActive ? AppColors.neutral : AppColors.mutedText,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 1,
            child: Icon(
              Icons.cloud_rounded,
              size: 16,
              color: isActive ? AppColors.neutral : AppColors.mutedText,
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
        borderRadius: BorderRadius.circular(24.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: isActive
              ? const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0)
              : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
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
                    size: 22,
                    color: isActive ? AppColors.neutral : AppColors.mutedText,
                  ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.neutral : AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
