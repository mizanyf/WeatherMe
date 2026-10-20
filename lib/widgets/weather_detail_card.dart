import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular icon container with soft Tertiary tint
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.55),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.secondary),
          ),
          const SizedBox(height: 12),

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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        unit!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral,
                        ),
                      ),
                    ],
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral,
                      letterSpacing: -0.5,
                    ),
                  ),
          ),
          const SizedBox(height: 4),

          // Label
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
              letterSpacing: 0.4,
              height: 1.2,
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          // Card 1: Terasa Seperti
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.thermostat_rounded,
              value: '${weather.feelsLike}°C',
              label: 'TERASA\nSEPERTI',
            ),
          ),
          const SizedBox(width: 12),

          // Card 2: Kelembapan
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.water_drop_rounded,
              value: '${weather.humidity}%',
              label: 'KELEMBAPAN\n',
            ),
          ),
          const SizedBox(width: 12),

          // Card 3: Kecepatan Angin
          Expanded(
            child: WeatherDetailCard(
              icon: Icons.air_rounded,
              value: '${weather.windSpeed}',
              unit: 'km/jam',
              label: 'KECEPATAN\nANGIN',
            ),
          ),
        ],
      ),
    );
  }
}
