import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

class HourlyForecastSection extends StatelessWidget {
  final List<HourlyForecast> hourlyList;
  final VoidCallback? onMoreTap;

  const HourlyForecastSection({
    super.key,
    required this.hourlyList,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Prakiraan Hari Ini',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral,
                  letterSpacing: -0.2,
                ),
              ),
              InkWell(
                onTap: onMoreTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    '24 Jam Ke Depan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Horizontal Scrollable Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          child: Row(
            children: hourlyList.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _HourlyForecastCard(item: item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _HourlyForecastCard extends StatelessWidget {
  final HourlyForecast item;

  const _HourlyForecastCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isHighlighted = item.isCurrent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 78,
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(22.0),
        border: isHighlighted
            ? Border.all(color: AppColors.primary, width: 1.5)
            : Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          if (isHighlighted)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.45),
              blurRadius: 14,
              offset: const Offset(0, 5),
            )
          else
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Time label
          Text(
            item.time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
              color: isHighlighted ? AppColors.neutral : AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 12),

          // Weather Icon
          _buildWeatherIcon(item.conditionType, isHighlighted),

          const SizedBox(height: 12),

          // Temperature
          Text(
            '${item.temperature}°',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(WeatherConditionType type, bool isHighlighted) {
    switch (type) {
      case WeatherConditionType.sunny:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.sunnyYellow.withValues(alpha: 0.3),
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.white.withValues(alpha: 0.9)
                : AppColors.tertiary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
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
                  color: isHighlighted
                      ? AppColors.neutral
                      : AppColors.secondary,
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 20,
            color: AppColors.secondary,
          ),
        );

      case WeatherConditionType.rainy:
        return Container(
          width: 32,
          height: 32,
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
