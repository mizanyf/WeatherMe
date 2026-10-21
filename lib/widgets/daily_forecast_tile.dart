import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

class DailyForecastSection extends StatelessWidget {
  final List<DailyForecast> dailyList;
  final VoidCallback? onCalendarTap;

  const DailyForecastSection({
    super.key,
    required this.dailyList,
    this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Prakiraan 3 Hari',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral,
                  letterSpacing: -0.3,
                ),
              ),
              InkWell(
                onTap: onCalendarTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Kalender',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Daily Forecast Rows — Frosted Glass Container
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
                  vertical: 6.0,
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
                  children: List.generate(dailyList.length, (index) {
                    return Column(
                      children: [
                        DailyForecastTile(item: dailyList[index]),
                        if (index < dailyList.length - 1)
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

class DailyForecastTile extends StatelessWidget {
  final DailyForecast item;

  const DailyForecastTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Day & Date (Left)
          SizedBox(
            width: 72,
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

          // Weather Icon
          _buildWeatherIcon(item.conditionType),

          const SizedBox(width: 14),

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
                        color: AppColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    // Active gradient range
                    Container(
                      height: 5,
                      width: barWidth * item.progress.clamp(0.2, 1.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF48CBE8), Color(0xFF0284C7)],
                        ),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          // Max & Min Temperature Display
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.maxTemp}°',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral,
                ),
              ),
              const Text(
                ' / ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
              Text(
                '${item.minTemp}°',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.sunny:
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.sunnyYellow.withValues(alpha: 0.25),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.wb_sunny_rounded,
            size: 20,
            color: AppColors.sunnyYellow,
          ),
        );

      case WeatherConditionType.partlyCloudy:
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFBAE6FD).withValues(alpha: 0.50),
            shape: BoxShape.circle,
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 14,
                  color: AppColors.sunnyYellow,
                ),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                child: Icon(
                  Icons.cloud_rounded,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 20,
            color: Color(0xFF64748B),
          ),
        );

      case WeatherConditionType.rainy:
        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.grain_rounded,
            size: 20,
            color: AppColors.secondary,
          ),
        );
    }
  }
}
