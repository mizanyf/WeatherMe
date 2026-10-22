import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TopHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLocationTap;
  final bool? isLocating;
  final bool? isDeviceLocation;

  const TopHeader({
    super.key,
    this.onSettingsTap,
    this.onLocationTap,
    this.isLocating = false,
    this.isDeviceLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool locating = isLocating == true;
    final bool deviceLocation = isDeviceLocation == true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Wordmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // WeatherMe Logo with smooth rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/logo/WeatherMe.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback sun-and-cloud icon if asset fails to load
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Wordmark "WeatherMe" — Sleek, refined, not overly thick
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weather',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: 'Me',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right side: Gunakan Lokasi Saya quick action
          if (onLocationTap != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: locating ? null : onLocationTap,
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (locating) ...[
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Mencari...',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          deviceLocation
                              ? Icons.location_on_rounded
                              : Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          deviceLocation
                              ? 'Lokasi Saya'
                              : 'Gunakan Lokasi',
                          style: const TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
