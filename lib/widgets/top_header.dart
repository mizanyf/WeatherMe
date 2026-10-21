import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TopHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const TopHeader({super.key, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Wordmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // WeatherMe Logo with smooth rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/logo/WeatherMe.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback sun-and-cloud icon if asset fails to load
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Wordmark "WeatherMe" — Sleek, refined, not overly thick
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weather',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: 'Me',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
