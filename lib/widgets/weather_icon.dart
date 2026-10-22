import 'package:flutter/material.dart';

import '../models/weather_models.dart';

/// Komponen icon cuaca terpadu dengan desain seragam di seluruh aplikasi
/// (Kalender, Prakiraan Multi-Hari, dan Kartu Kota di Halaman Lokasi).
class WeatherIcon extends StatelessWidget {
  final WeatherConditionType conditionType;
  final double size;
  final Color? color;

  const WeatherIcon({
    super.key,
    required this.conditionType,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (conditionType) {
      case WeatherConditionType.sunny:
        return Icon(
          Icons.wb_sunny_rounded,
          size: size,
          color: color ?? const Color(0xFFF59E0B),
        );

      case WeatherConditionType.partlyCloudy:
        final sunSize = (size * 0.68).roundToDouble();
        final cloudSize = (size * 0.77).roundToDouble();
        return SizedBox(
          width: size * 1.15,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: sunSize,
                  color: color ?? const Color(0xFFF59E0B),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(
                  Icons.cloud_rounded,
                  size: cloudSize,
                  color: color != null
                      ? color!.withValues(alpha: 0.90)
                      : const Color(0xFF38BDF8),
                ),
              ),
            ],
          ),
        );

      case WeatherConditionType.cloudy:
        return Icon(
          Icons.cloud_rounded,
          size: size,
          color: color ?? const Color(0xFF38BDF8),
        );

      case WeatherConditionType.overcast:
        return Icon(
          Icons.cloud_rounded,
          size: size,
          color: color ?? const Color(0xFF64748B),
        );

      case WeatherConditionType.rainy:
        final cloudSize = (size * 0.77).roundToDouble();
        final dropSize = (size * 0.54).roundToDouble();
        return SizedBox(
          width: size * 1.15,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Icon(
                  Icons.cloud_rounded,
                  size: cloudSize,
                  color: color != null
                      ? color!.withValues(alpha: 0.85)
                      : const Color(0xFF64748B),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.water_drop_rounded,
                  size: dropSize,
                  color: color ?? const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        );
    }
  }
}
