import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

class WeeklyForecastSection extends StatelessWidget {
  final List<WeeklyForecastItem> weeklyList;
  final VoidCallback? onDetailTap;

  const WeeklyForecastSection({
    super.key,
    required this.weeklyList,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Prakiraan 7 Hari Mendatang',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral,
                  letterSpacing: -0.2,
                ),
              ),
              InkWell(
                onTap: onDetailTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    'Detail',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 7-day Forecast Rows — Frosted Glass Container
          ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppColors.glassBlurSigmaLight,
                sigmaY: AppColors.glassBlurSigmaLight,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: AppColors.glassBorder, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(weeklyList.length, (index) {
                    return Column(
                      children: [
                        WeeklyForecastTile(item: weeklyList[index]),
                        if (index < weeklyList.length - 1)
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: AppColors.border.withValues(alpha: 0.7),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyForecastTile extends StatelessWidget {
  final WeeklyForecastItem item;

  const WeeklyForecastTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11.0),
      child: Row(
        children: [
          // Day & Date (Left)
          SizedBox(
            width: 66,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.day,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),

          // Weather Icon + Precipitation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWeatherIcon(item.conditionType),
              const SizedBox(width: 4),
              SizedBox(
                width: 34,
                child: Text(
                  '${item.precipitation}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),

          // Min Temperature
          SizedBox(
            width: 28,
            child: Text(
              '${item.minTemp}°',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedText,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Temperature Range Indicator Bar
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Background track
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    // Active gradient range
                    Container(
                      height: 5,
                      width: barWidth * item.progress.clamp(0.25, 1.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            const Color(0xFF75E8F3),
                            if (item.maxTemp >= 30)
                              AppColors.sunnyYellow
                            else
                              AppColors.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          // Max Temperature
          SizedBox(
            width: 28,
            child: Text(
              '${item.maxTemp}°',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.sunny:
        return const Icon(
          Icons.wb_sunny_rounded,
          size: 20,
          color: AppColors.sunnyYellow,
        );

      case WeatherConditionType.partlyCloudy:
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFBAE6FD).withValues(alpha: 0.50),
            shape: BoxShape.circle,
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 4,
                right: 4,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 11,
                  color: AppColors.sunnyYellow,
                ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                child: Icon(
                  Icons.cloud_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 16,
            color: Color(0xFF64748B),
          ),
        );

      case WeatherConditionType.rainy:
        return const Icon(
          Icons.grain_rounded,
          size: 20,
          color: AppColors.secondary,
        );
    }
  }
}
