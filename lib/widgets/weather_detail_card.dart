import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Modern Frosted Glass Weather Detail Card.
class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? unit;
  final String label;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.value,
    this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigmaLight,
          sigmaY: AppColors.glassBlurSigmaLight,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(22.0),
            border: Border.all(color: AppColors.glassBorder, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon wrapped in subtle ice blue glass circle
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.secondary),
              ),
              const SizedBox(height: 10),

              // Value and optional unit
              FittedBox(
                fit: BoxFit.scaleDown,
                child: unit != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            value,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            unit!,
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                          letterSpacing: -0.3,
                        ),
                      ),
              ),
              const SizedBox(height: 4),

              // Category Label
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                  letterSpacing: 0.2,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetailsRow extends StatelessWidget {
  final CurrentWeather weather;

  const WeatherDetailsRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // 1. Feels Like
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.thermostat_rounded,
              value: '${weather.feelsLike}',
              unit: '°C',
              label: 'TERASA\nSEPERTI',
            ),
          ),
          const SizedBox(width: 10),

          // 2. Humidity
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.water_drop_rounded,
              value: '${weather.humidity}',
              unit: '%',
              label: 'KELEMBAPAN\n',
            ),
          ),
          const SizedBox(width: 10),

          // 3. Wind Speed
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.air_rounded,
              value: '${weather.windSpeed}',
              unit: 'km/j',
              label: 'KECEPATAN\nANGIN',
            ),
          ),
        ],
      ),
    );
  }
}
