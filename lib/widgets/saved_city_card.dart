import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

class SavedCityCard extends StatelessWidget {
  final CityWeather city;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const SavedCityCard({
    super.key,
    required this.city,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigmaLight,
            sigmaY: AppColors.glassBlurSigmaLight,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: AppColors.glassBorder, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20.0),
              child: Row(
                children: [
                  // Circular Weather Icon
                  _buildCircularIcon(city.conditionType),
                  const SizedBox(width: 14),

                  // City Name & Condition with Max/Min
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          city.displayName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${city.condition} • Maks ${city.maxTemp}° Min ${city.minTemp}°',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Current Temperature
                  Text(
                    '${city.temperature}°',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.neutral,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIcon(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.sunny:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.sunnyYellow.withValues(alpha: 0.2),
                blurRadius: 6,
              ),
            ],
          ),
          child: const Icon(
            Icons.wb_sunny_rounded,
            size: 22,
            color: AppColors.sunnyYellow,
          ),
        );

      case WeatherConditionType.partlyCloudy:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.40),
            shape: BoxShape.circle,
          ),
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 7,
                right: 7,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: 14,
                  color: AppColors.sunnyYellow,
                ),
              ),
              Positioned(
                bottom: 7,
                left: 7,
                child: Icon(
                  Icons.cloud_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFBAE6FD).withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 22,
            color: Color(0xFF0284C7),
          ),
        );

      case WeatherConditionType.overcast:
        return Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFEBF0F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 22,
            color: Color(0xFF4C6B73),
          ),
        );

      case WeatherConditionType.rainy:
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.40),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.grain_rounded,
            size: 22,
            color: AppColors.secondary,
          ),
        );
    }
  }
}
