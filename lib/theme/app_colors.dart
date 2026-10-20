import 'package:flutter/material.dart';

/// WeatherMe Brand Color Palette
/// Exact specifications from brand reference:
/// - Primary: #5AF1FF
/// - Secondary: #006972
/// - Tertiary: #B4F3F9
/// - Neutral: #092E33
///
/// Supporting colors:
/// - White: #FFFFFF
/// - Soft background: #F4FCFD
/// - Muted text: #6D9298
/// - Border: #D9EFF1
/// - Sunny yellow: #FFD56A
/// - Soft coral: #FF9A91
abstract class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF5AF1FF);
  static const Color secondary = Color(0xFF006972);
  static const Color tertiary = Color(0xFFB4F3F9);
  static const Color neutral = Color(0xFF092E33);

  // Supporting & surface colors
  static const Color background = Color(0xFFF4FCFD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF6D9298);
  static const Color border = Color(0xFFD9EFF1);

  // Accent & weather condition colors
  static const Color sunnyYellow = Color(0xFFFFD56A);
  static const Color cloudWhite = Color(0xFFFFFFFF);
  static const Color softCoral = Color(0xFFFF9A91);

  // Shadows and overlays
  static Color shadow = const Color(0xFF006972).withValues(alpha: 0.08);
  static Color cardGlow = const Color(0xFF5AF1FF).withValues(alpha: 0.35);
}
