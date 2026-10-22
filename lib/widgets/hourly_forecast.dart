import 'dart:ui';

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
          child: const Text(
            'Prakiraan Hari Ini',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.neutral,
              letterSpacing: -0.3,
            ),
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
                padding: const EdgeInsets.only(right: 10.0),
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
    final bool isHighlighted = (item.isCurrent as dynamic) == true;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigmaLight,
          sigmaY: AppColors.glassBlurSigmaLight,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          decoration: BoxDecoration(
            gradient: isHighlighted
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE0F7FC), Color(0xFFBAE6FD)],
                  )
                : null,
            color: isHighlighted ? null : AppColors.glassFill,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isHighlighted ? Colors.white : AppColors.glassBorder,
              width: isHighlighted ? 1.2 : 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isHighlighted
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.shadow,
                blurRadius: isHighlighted ? 14 : 10,
                offset: const Offset(0, 4),
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
                  fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlighted
                      ? AppColors.secondary
                      : AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 12),

              // Weather Icon
              _buildWeatherIcon(item.conditionType, isHighlighted),

              const SizedBox(height: 12),

              // Temperature
              Text(
                '${item.temperature}°',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
        ),
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
                ? const Color(0xFF48CBE8).withValues(alpha: 0.35)
                : const Color(0xFFBAE6FD).withValues(alpha: 0.50),
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
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFF48CBE8).withValues(alpha: 0.35)
                : const Color(0xFFBAE6FD).withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 20,
            color: Color(0xFF0284C7),
          ),
        );

      case WeatherConditionType.overcast:
        return Container(
          width: 32,
          height: 32,
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
