import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TopHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const TopHeader({super.key, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Wordmark
          Row(
            children: [
              // WeatherMe Logo with rounded corners (sudut tumpul)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/logo/WeatherMe.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback sun-and-cloud icon if asset fails to load
                    return Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.neutral,
                        size: 22,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Wordmark "WeatherMe" — Bold & Modern
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Weather',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.neutral,
                        letterSpacing: -0.6,
                      ),
                    ),
                    TextSpan(
                      text: 'Me',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.6,
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
