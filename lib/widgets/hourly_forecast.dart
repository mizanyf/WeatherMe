import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import 'weather_icon.dart';

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
            'Perkiraan Hari Ini',
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

  String _formatDisplayTime(String raw) {
    if (raw == 'Sekarang') return raw;
    final parts = raw.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return raw;
  }

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
                    colors: [
                      Color(0xFFBAE6FD),
                      Color(0xFFE0F7FC),
                      Color(0xFF7DD3FC),
                    ],
                    stops: [0.0, 0.50, 1.0],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE0F7FC),
                      Color(0xFFF0FDFE),
                      Color(0xFFBAE6FD),
                    ],
                    stops: [0.0, 0.55, 1.0],
                  ),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isHighlighted ? Colors.white : AppColors.glassBorder,
              width: isHighlighted ? 1.4 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isHighlighted
                    ? AppColors.primary.withValues(alpha: 0.28)
                    : AppColors.primary.withValues(alpha: 0.10),
                blurRadius: isHighlighted ? 16 : 12,
                offset: const Offset(0, 4),
              ),
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
                _formatDisplayTime(item.time),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isHighlighted ? FontWeight.w800 : FontWeight.w600,
                  color: isHighlighted
                      ? AppColors.secondary
                      : AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 10),

              // Weather Icon matching calendar design & hourly condition
              SizedBox(
                height: 32,
                child: Center(
                  child: WeatherIcon(
                    conditionType: item.conditionType,
                    size: 26,
                  ),
                ),
              ),

              const SizedBox(height: 10),

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
}
