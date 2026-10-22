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
    if (!forecast.isAvailable) {
      return _buildUnavailableCard(context);
    }

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
                padding: const EdgeInsets.fromLTRB(22.0, 16.0, 20.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Date on Left, Condition on Right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${forecast.dayName}, ${forecast.dateFormatted} ${forecast.date.year}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Condition — clean text, no pill
                        Text(
                          forecast.condition,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${forecast.temperature}°',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: AppColors.neutral,
                                letterSpacing: -2.0,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
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
                            ),
                          ],
                        ),

                        // Weather Illustration (proporsional dan tidak mepet ke atas)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 6.0),
                          child: WeatherIllustration(
                            size: 72,
                            conditionType: forecast.conditionType,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

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

  Widget _buildUnavailableCard(BuildContext context) {
    final bool isExpired = forecast.isPastExpired;
    final String badgeText = isExpired ? 'SUDAH TERLEWAT' : 'BELUM TERSEDIA';
    final Color badgeColor =
        isExpired ? const Color(0xFF64748B) : AppColors.primary;
    final IconData statusIcon =
        isExpired ? Icons.history_toggle_off_rounded : Icons.schedule_rounded;
    final String titleText =
        isExpired ? 'Perkiraan Telah Berlalu' : 'Perkiraan Belum Tersedia';
    final String descText = isExpired
        ? 'Data perkiraan cuaca untuk tanggal ini sudah terlewat. Aplikasi hanya menampilkan riwayat hingga 7 hari ke belakang.'
        : 'Perkiraan cuaca untuk tanggal ini belum tersedia. Perkiraan cuaca akurat hanya dapat diprediksi hingga 7 hari ke depan.';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F7FC),
            Color(0xFFF0FDFE),
            Color(0xFFBAE6FD),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22.0, 20.0, 20.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Day/Date on Left, Badge on Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '${forecast.dayName}, ${forecast.dateFormatted} ${forecast.date.year}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Middle Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(statusIcon, size: 36, color: badgeColor),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.neutral,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            descText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedText,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Bottom Row
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.water_drop_outlined,
                        label: 'Hujan',
                        value: '-',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.water_drop_rounded,
                        label: 'Kelembapan',
                        value: '-',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.air_rounded,
                        label: 'Kec. Angin',
                        value: '-',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailTile(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Indeks UV',
                        value: '-',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
