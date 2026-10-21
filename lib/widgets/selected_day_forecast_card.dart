import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFCEF5F9), // Soft cyan tint
            Color(0xFFE8FBFC), // Light sky
            Color(0xFFB4F3F9), // Brand Tertiary
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: Stack(
          children: [
            // Organic background circle for depth
            Positioned(
              right: -30,
              top: -20,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.28),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.22),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Section Label + Date on Left, Condition Badge on Right
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
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${forecast.dayName}, ${forecast.dateFormatted}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      // Condition Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11.0,
                          vertical: 5.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.70),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          forecast.condition,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral,
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
                              fontSize: 54,
                              fontWeight: FontWeight.w400,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.neutral,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Min ${forecast.minTemp}°',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Weather Illustration
                      const WeatherIllustration(size: 96),
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
                          label: 'Plg Hujan',
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
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
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
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
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
