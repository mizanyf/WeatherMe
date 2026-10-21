import 'package:flutter/material.dart';

/// WeatherMe Modern Minimalist White-Blue Color Palette
///
/// Designed for a sleek, modern glassmorphism aesthetic:
/// - Crisp whites and translucent frosted glass layers
/// - Vibrant sky/azure blues (#0EA5E9, #0284C7)
/// - Deep slate navy typography (#0F172A)
/// - Cool pale ice canvas (#F4F7FB)
abstract class AppColors {
  // Primary brand blues
  static const Color primary = Color(
    0xFF48CBE8,
  ); // WeatherMe Vibrant Sky Blue #48CBE8
  static const Color secondary = Color(0xFF0284C7); // Deep Azure Accent
  static const Color tertiary = Color(0xFFBAE6FD); // Soft Ice Sky
  static const Color neutral = Color(
    0xFF0F172A,
  ); // Deep Slate Navy for high-contrast modern typography

  // Supporting & surface colors
  static const Color background = Color(
    0xFFF4F7FB,
  ); // Atmospheric pale ice canvas
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF64748B); // Cool Slate Gray
  static const Color border = Color(0xFFE2E8F0); // Subtle Ice Border

  // Accent & weather condition colors (minimalist)
  static const Color sunnyYellow = Color(0xFFFBBF24); // Warm Sun Gold
  static const Color cloudWhite = Color(0xFFFFFFFF);
  static const Color softCoral = Color(0xFFF87171);

  // Shadows and glows
  static Color shadow = const Color(0xFF0F172A).withValues(alpha: 0.05);
  static Color cardGlow = const Color(0xFF48CBE8).withValues(alpha: 0.22);

  // ── Glassmorphism tokens ──────────────────────────────────────────────
  /// Translucent white fill for frosted glass surfaces
  static Color glassFill = Colors.white.withValues(alpha: 0.72);

  /// Translucent tinted glass fill for active cards / hero highlights
  static Color glassAccentFill = const Color(0xFFE0F2FE)
      .withValues(alpha: 0.75);

  /// Ultra-smooth glass fill for floating bottom navbar
  static Color glassNavFill = Colors.white.withValues(alpha: 0.82);

  /// Crisp glass border – gives luminous frosted bevel highlight
  static Color glassBorder = Colors.white.withValues(alpha: 0.85);

  /// Subtle secondary glass border for contrasting edges
  static Color glassBorderSubtle = const Color(0xFFE2E8F0)
      .withValues(alpha: 0.60);

  /// Glass shadow – ultra-soft ambient elevation
  static Color glassShadow = const Color(0xFF0F172A).withValues(alpha: 0.05);

  /// Ambient glass glow for active elements
  static Color glassGlow = const Color(0xFF48CBE8).withValues(alpha: 0.28);

  /// Default backdrop blur sigma for glass surfaces
  static const double glassBlurSigma = 20.0;

  /// Lighter blur for small glass widgets
  static const double glassBlurSigmaLight = 12.0;
}
