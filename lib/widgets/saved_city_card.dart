import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import 'weather_icon.dart';

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
                  // Weather Icon matching calendar
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: WeatherIcon(
                        conditionType: city.conditionType,
                        size: 30,
                      ),
                    ),
                  ),
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
}

