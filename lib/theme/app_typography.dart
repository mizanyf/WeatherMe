import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized Typography tokens for WeatherMe.
///
/// Uses the [Outfit] typeface with a deliberate weight hierarchy:
/// - Light / Regular (400): Body descriptions, secondary metadata
/// - Medium (500): Weather units, date/time timestamps, subheadings
/// - SemiBold (600): Navigation labels, conditions, chip labels, interactive actions
/// - Bold (700): Section headings, card titles, city names, detail values, forecast numbers
/// - ExtraBold (800): Main page hero titles, brand wordmark
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Outfit';

  // --- Display / Hero ---
  /// Large hero temperature display ("28")
  static const TextStyle heroTemp = TextStyle(
    fontFamily: fontFamily,
    fontSize: 64,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: AppColors.neutral,
    letterSpacing: -2.5,
  );

  /// Hero temperature unit ("°C")
  static const TextStyle heroTempUnit = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );

  // --- Page Headings ---
  /// Main screen titles ("Prakiraan Cuaca", "Kalender Cuaca")
  static const TextStyle pageHeading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.2,
    color: AppColors.neutral,
    letterSpacing: -0.5,
  );

  /// Brand wordmark ("WeatherMe")
  static const TextStyle brandWordmark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.3,
  );

  // --- Section & Card Headings ---
  /// Section titles ("Prakiraan Hari Ini", "Prakiraan 7 Hari")
  static const TextStyle sectionHeading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.2,
  );

  /// Card titles & modal headings
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.2,
  );

  /// City name / main location header
  static const TextStyle cityName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.2,
  );

  // --- Conditions & Status ---
  /// Weather condition subtitle ("Sebagian Berawan", "Hujan Ringan")
  static const TextStyle condition = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );

  // --- Weather Measurement Details ---
  /// Value in detail cards ("29°", "78%", "14 km/j")
  static const TextStyle detailValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.3,
  );

  /// Unit accompanying detail values
  static const TextStyle detailUnit = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedText,
  );

  /// Category label in detail cards ("TERASA SEPERTI", "KELEMBAPAN")
  static const TextStyle detailLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedText,
    letterSpacing: 0.3,
  );

  // --- Forecast Items ---
  /// Forecast temperature numbers in hourly / daily cards
  static const TextStyle forecastTemp = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.neutral,
    letterSpacing: -0.2,
  );

  /// Forecast day or time label ("12.00", "Kamis")
  static const TextStyle forecastLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral,
  );

  // --- Navigation & Interactive ---
  /// Floating bottom navigation labels ("Beranda", "Kalender", "Lokasi")
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  /// Button / Action pill labels ("Lihat Semua", "Pilih Lokasi")
  static const TextStyle actionLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
  );

  /// Quick filter chip labels ("Paris", "Tokyo")
  static const TextStyle chipLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.neutral,
  );

  // --- Body & Metadata ---
  /// Primary body text
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.neutral,
    height: 1.4,
  );

  /// Secondary description / subtitle
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mutedText,
    height: 1.3,
  );

  /// Micro metadata (e.g. date format "21 Okt 2026")
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedText,
  );

  /// Generate Material 3 TextTheme populated with Outfit
  static TextTheme get textTheme => const TextTheme(
    headlineLarge: pageHeading,
    headlineMedium: cardTitle,
    titleLarge: sectionHeading,
    titleMedium: cityName,
    titleSmall: condition,
    bodyLarge: body,
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.neutral,
    ),
    bodySmall: bodySmall,
    labelLarge: actionLabel,
    labelSmall: navLabel,
  );
}
