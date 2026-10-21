import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../theme/app_colors.dart';

/// Layered Weather illustration matching the WeatherMe design system.
///
/// Ensures clear visual meaning:
/// - [partlyCloudy] (Cerah Berawan): Golden glowing sun with a 100% PURE FLUFFY
///   WHITE cloud. Absolutely NO dark/grey tones.
/// - [cloudy] (Mendung): Full overcast dark slate/grey clouds.
/// - [sunny] (Cerah): Radiant glowing golden sun.
/// - [rainy] (Hujan): Overcast slate cloud with stylized raindrops.
class WeatherIllustration extends StatelessWidget {
  final double size;
  final WeatherConditionType conditionType;

  const WeatherIllustration({
    super.key,
    this.size = 110,
    this.conditionType = WeatherConditionType.partlyCloudy,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _buildIllustration(size),
    );
  }

  Widget _buildIllustration(double size) {
    switch (conditionType) {
      case WeatherConditionType.sunny:
        return _buildSunny(size);
      case WeatherConditionType.partlyCloudy:
        return _buildPartlyCloudy(size);
      case WeatherConditionType.cloudy:
        return _buildCloudy(size);
      case WeatherConditionType.rainy:
        return _buildRainy(size);
    }
  }

  /// Cerah Berawan: Matahari emas bersinar dengan awan PUTIH BERSIH
  /// Tidak ada warna hitam atau abu-abu sama sekali
  Widget _buildPartlyCloudy(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background soft cyan/sky cloud (upper-left)
        Positioned(
          top: size * 0.12,
          left: size * 0.08,
          child: Container(
            width: size * 0.42,
            height: size * 0.26,
            decoration: BoxDecoration(
              color: const Color(0xFF86E7F2).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(size * 0.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -size * 0.08,
                  left: size * 0.1,
                  child: Container(
                    width: size * 0.22,
                    height: size * 0.22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9BEDF5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Glowing Golden Sun (center-right)
        Positioned(
          top: size * 0.12,
          right: size * 0.08,
          child: Container(
            width: size * 0.58,
            height: size * 0.58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFF099),
                  AppColors.sunnyYellow,
                  Color(0xFFFFB84D),
                ],
                stops: [0.2, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.sunnyYellow.withValues(alpha: 0.5),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        // Organic Front Puffy Cloud — 100% PURE WHITE (lower-right)
        Positioned(
          bottom: size * 0.08,
          right: size * 0.02,
          child: Container(
            width: size * 0.68,
            height: size * 0.46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Upper main cloud bump (pure white)
                Positioned(
                  top: -size * 0.16,
                  left: size * 0.18,
                  child: Container(
                    width: size * 0.34,
                    height: size * 0.34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Left cloud bump (pure white)
                Positioned(
                  top: -size * 0.08,
                  left: size * 0.04,
                  child: Container(
                    width: size * 0.24,
                    height: size * 0.24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Right cloud bump (pure white)
                Positioned(
                  top: -size * 0.06,
                  right: size * 0.06,
                  child: Container(
                    width: size * 0.22,
                    height: size * 0.22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Soft pure white-blue highlight puff (clean & bright, not dark)
                Positioned(
                  bottom: size * 0.04,
                  left: size * 0.12,
                  child: Container(
                    width: size * 0.40,
                    height: size * 0.24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFE),
                      borderRadius: BorderRadius.circular(size * 0.12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Mendung: Awan tebal abu-abu/hitam pekat
  Widget _buildCloudy(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background dark slate cloud
        Positioned(
          top: size * 0.14,
          left: size * 0.10,
          child: Container(
            width: size * 0.54,
            height: size * 0.34,
            decoration: BoxDecoration(
              color: const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(size * 0.18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF334155).withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -size * 0.10,
                  left: size * 0.14,
                  child: Container(
                    width: size * 0.28,
                    height: size * 0.28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF94A3B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Foreground overcast slate cloud (mendung abu-abu gelap)
        Positioned(
          bottom: size * 0.10,
          right: size * 0.04,
          child: Container(
            width: size * 0.70,
            height: size * 0.46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF64748B), Color(0xFF475569)],
              ),
              borderRadius: BorderRadius.circular(size * 0.25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -size * 0.16,
                  left: size * 0.18,
                  child: Container(
                    width: size * 0.34,
                    height: size * 0.34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF64748B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: -size * 0.08,
                  left: size * 0.04,
                  child: Container(
                    width: size * 0.24,
                    height: size * 0.24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF64748B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Cerah: Matahari emas bersinar penuh
  Widget _buildSunny(double size) {
    return Center(
      child: Container(
        width: size * 0.72,
        height: size * 0.72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFFFFF5A5),
              AppColors.sunnyYellow,
              Color(0xFFFF9E2C),
            ],
            stops: [0.2, 0.65, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.sunnyYellow.withValues(alpha: 0.6),
              blurRadius: 26,
              spreadRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  /// Hujan: Awan mendung dengan butiran air hujan
  Widget _buildRainy(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Grey/slate cloud
        Positioned(
          top: size * 0.10,
          child: Container(
            width: size * 0.68,
            height: size * 0.44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF64748B), Color(0xFF475569)],
              ),
              borderRadius: BorderRadius.circular(size * 0.22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -size * 0.14,
                  left: size * 0.18,
                  child: Container(
                    width: size * 0.32,
                    height: size * 0.32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF64748B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Raindrops
        Positioned(
          bottom: size * 0.08,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRaindrop(size * 0.08),
              SizedBox(width: size * 0.08),
              _buildRaindrop(size * 0.11),
              SizedBox(width: size * 0.08),
              _buildRaindrop(size * 0.08),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRaindrop(double height) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
