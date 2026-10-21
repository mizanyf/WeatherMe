import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Kartu metrik cuaca terpisah di beranda yang menampilkan 4 indikator:
/// Hujan, Kelembapan, Kec. Angin, dan Indeks UV dengan desain glassmorphic
/// yang selaras dengan tampilan di kalender.
class CurrentWeatherMetricsCard extends StatelessWidget {
  final CurrentWeather weather;

  const CurrentWeatherMetricsCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1.1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE0F7FC).withValues(alpha: 0.88),
            const Color(0xFFF0FDFE).withValues(alpha: 0.82),
            const Color(0xFFBAE6FD).withValues(alpha: 0.48),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigmaLight,
            sigmaY: AppColors.glassBlurSigmaLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // 1. Hujan
                Expanded(
                  child: _buildDetailTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Hujan',
                    value: (weather.rainChance != null && weather.rainChance!.isNotEmpty)
                        ? weather.rainChance!
                        : '5%',
                  ),
                ),
                const SizedBox(width: 8),

                // 2. Kelembapan
                Expanded(
                  child: _buildDetailTile(
                    icon: Icons.water_drop_rounded,
                    label: 'Kelembapan',
                    value: '${weather.humidity}%',
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Kecepatan Angin
                Expanded(
                  child: _buildDetailTile(
                    icon: Icons.air_rounded,
                    label: 'Kec. Angin',
                    value: '${weather.windSpeed} km/j',
                  ),
                ),
                const SizedBox(width: 8),

                // 4. Indeks UV
                Expanded(
                  child: _buildDetailTile(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Indeks UV',
                    value: (weather.uvIndex != null && weather.uvIndex!.isNotEmpty)
                        ? weather.uvIndex!
                        : 'Sedang 5',
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.80),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.secondary),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              displayValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 12.5,
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
