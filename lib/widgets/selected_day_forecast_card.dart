import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'weather_illustration.dart';

class SelectedDayForecastCard extends StatelessWidget {
  final CalendarDayForecast forecast;

  const SelectedDayForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F7FC), // Soft Ice Sky #48CBE8 tint
            Color(0xFFF0FDFE), // Frosted Pure White-Blue
            Color(0xFFBAE6FD), // Ambient Blue Accent
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigmaLight,
            sigmaY: AppColors.glassBlurSigmaLight,
          ),
          child: Stack(
            children: [
              // Soft depth circle — restrained
              Positioned(
                right: -40,
                top: -20,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 18.0, 20.0, 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Section Label + Date on Left, Condition on Right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FOKUS PRAKIRAAN',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${forecast.dayName}, ${forecast.dateFormatted}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.neutral,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),

                        // Condition — clean text, no pill
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            forecast.condition,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Middle Row: Temperature + Max/Min on Left, Sun/Cloud on Right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Temperature & Max/Min
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${forecast.temperature}°',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 54,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: AppColors.neutral,
                                letterSpacing: -2.0,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Maks ${forecast.maxTemp}°',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.neutral,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Min ${forecast.minTemp}°',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Weather Illustration
                        WeatherIllustration(
                          size: 96,
                          conditionType: forecast.conditionType,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Bottom Row: 4 Weather Details
                    Row(
                      children: [
                        // 1. Curah Hujan
                        Expanded(
                          child: _buildDetailTile(
                            icon: Icons.water_drop_outlined,
                            label: 'Hujan',
                            value: forecast.rainChance,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // 2. Kelembapan
                        Expanded(
                          child: _buildDetailTile(
                            icon: Icons.water_drop_rounded,
                            label: 'Kelembapan',
                            value: forecast.humidity,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // 3. Kecepatan Angin
                        Expanded(
                          child: _buildDetailTile(
                            icon: Icons.air_rounded,
                            label: 'Kec. Angin',
                            value: forecast.windSpeed,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // 4. Indeks UV
                        Expanded(
                          child: _buildDetailTile(
                            icon: Icons.wb_sunny_outlined,
                            label: 'Indeks UV',
                            value: forecast.uvIndex,
                          ),
                        ),
                      ],
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

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final String displayValue =
        (value != null && value.isNotEmpty) ? value : '-';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.75),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppColors.secondary),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              displayValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
