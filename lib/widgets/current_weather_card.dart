import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/models/weather_model.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'weather_illustration.dart';

/// Modern Minimalist White-Blue Glassmorphic Hero Weather Card.
class CurrentWeatherCard extends StatefulWidget {
  final CurrentWeather weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  State<CurrentWeatherCard> createState() => _CurrentWeatherCardState();
}

class _CurrentWeatherCardState extends State<CurrentWeatherCard> {
  Timer? _clockTimer;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.weather.dateTime.isNotEmpty
        ? widget.weather.dateTime
        : WeatherApiResponse.formatDateTimeIndo();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowFormatted = WeatherApiResponse.formatDateTimeIndo();
      if (_currentTime != nowFormatted) {
        if (mounted) {
          setState(() {
            _currentTime = nowFormatted;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant CurrentWeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weather.dateTime != widget.weather.dateTime &&
        widget.weather.dateTime.isNotEmpty) {
      _currentTime = widget.weather.dateTime;
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.weather;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F2FE), // Soft Ice Sky
            Color(0xFFF0F9FF), // Frosted Pure White-Blue
            Color(0xFFBAE6FD), // Ambient Blue Accent
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigmaLight,
            sigmaY: AppColors.glassBlurSigmaLight,
          ),
          child: Stack(
            children: [
              // Soft ethereal glass orb in corner
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),

              // Main card content
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 20.0, 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Location & Condition
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Condition label — Big & Bold on top
                            Text(
                              weather.condition,
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.neutral,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // 2. Location pin and name underneath
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  weather.location,
                                  style: const TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mutedText,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Middle Row: Temperature & Sun/Cloud Illustration
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Large Temperature Display "28°C"
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather.temperature}',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 64,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: AppColors.neutral,
                                letterSpacing: -2.5,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 2.0),
                              child: Text(
                                '°C',
                                style: TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Layered Weather Illustration matching current condition (dinaikkan agar pas dan proporsional)
                        Transform.translate(
                          offset: const Offset(0, -18),
                          child: WeatherIllustration(
                            size: 116,
                            conditionType: weather.conditionType,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Bottom Row: Date/Time and Min/Max
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Date & Time (waktu jam di sebelah kiri hari, tanpa bulatan)
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 13,
                                color: AppColors.mutedText,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _currentTime,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Max and Min temperatures (di bawah awan di sebelah kanan: Maks & Min)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Maks ${weather.maxTemp}°',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutral,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Min ${weather.minTemp}°',
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
