import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LocationsHeader extends StatelessWidget {
  const LocationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Jelajahi Lokasi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.neutral,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 4),

          // Subtitle
          Text(
            'Temukan cuaca di berbagai belahan dunia',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
