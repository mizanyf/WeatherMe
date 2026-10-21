import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

class SavedCityCard extends StatelessWidget {
  final CityWeather city;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onTap;

  const SavedCityCard({
    super.key,
    required this.city,
    required this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                    '${city.condition} • M: ${city.maxTemp}° R: ${city.minTemp}°',
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
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.neutral,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 12),

            // Interactive Heart Icon
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFavoriteTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      city.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(city.isFavorite),
                      size: 22,
                      color: city.isFavorite
                          ? AppColors.secondary
                          : AppColors.mutedText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(WeatherConditionType type) {
    switch (type) {
      case WeatherConditionType.sunny:
        return Container(
          width: 44,
          height: 44,
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
            size: 24,
            color: AppColors.sunnyYellow,
          ),
        );

      case WeatherConditionType.partlyCloudy:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.45),
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
                  size: 15,
                  color: AppColors.sunnyYellow,
                ),
              ),
              Positioned(
                bottom: 7,
                left: 7,
                child: Icon(
                  Icons.cloud_rounded,
                  size: 20,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEBF0F2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_rounded,
            size: 24,
            color: Color(0xFF4C6B73),
          ),
        );

      case WeatherConditionType.rainy:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.grain_rounded,
            size: 24,
            color: AppColors.secondary,
          ),
        );
    }
  }
}
