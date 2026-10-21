import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'locations_screen.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_tile.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/top_header.dart';
import '../widgets/weather_bottom_navigation.dart';
import '../widgets/weather_detail_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // Local mock data instances
  final CurrentWeather _currentWeather = CurrentWeather.mock;
  final List<HourlyForecast> _hourlyForecasts = HourlyForecast.mockList;
  final List<DailyForecast> _dailyForecasts = DailyForecast.mockList;

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CalendarScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      return;
    }

    if (index == 2) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LocationsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      return;
    }

    setState(() {
      _selectedNavIndex = index;
    });
  }

  void _onCalendarActionTap() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CalendarScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pengaturan cuaca'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 110.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Top Header
                    TopHeader(onSettingsTap: _onSettingsTap),

                    // 2. Current Weather Hero Card
                    CurrentWeatherCard(weather: _currentWeather),

                    const SizedBox(height: 6),

                    // 3. Weather Details Row (Feels like, Humidity, Wind speed)
                    WeatherDetailsRow(weather: _currentWeather),

                    const SizedBox(height: 10),

                    // 4. Hourly Forecast Section
                    HourlyForecastSection(
                      hourlyList: _hourlyForecasts,
                      onMoreTap: _onCalendarActionTap,
                    ),

                    const SizedBox(height: 10),

                    // 5. Three-Day Forecast Section
                    DailyForecastSection(
                      dailyList: _dailyForecasts,
                      onCalendarTap: _onCalendarActionTap,
                    ),
                  ],
                ),
              ),
            ),

            // Floating Bottom Navigation Bar with Soft Gradient Mask
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0.0),
                      AppColors.background.withValues(alpha: 0.8),
                      AppColors.background,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
                child: WeatherBottomNavigation(
                  currentIndex: _selectedNavIndex,
                  onTap: _onNavTapped,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
