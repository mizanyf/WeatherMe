import 'package:flutter/material.dart';

import 'locations_screen.dart';
import '../data/services/weather_controller.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/calendar_header.dart';
import '../widgets/selected_day_forecast_card.dart';
import '../widgets/top_header.dart';
import '../widgets/weather_bottom_navigation.dart';
import '../widgets/weather_calendar.dart';
import '../widgets/weekly_forecast_list.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  WeatherController get _controller => WeatherController.instance;

  @override
  void initState() {
    super.initState();
    // Default initial date selalu sesuai dengan hari ini secara dinamis
    _selectedDate = DateTime.now();
  }

  CalendarDayForecast _getForecastForDate(DateTime date) {
    return _controller.getForecastForDate(date);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      // Navigate back to Home
      Navigator.of(context).pop();
    } else if (index == 2) {
      // Navigate to Locations
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LocationsScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _onLocationTap() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LocationsScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kalender Cuaca • Lokasi: ${_controller.currentCity}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: WeatherController.instance,
      builder: (context, _) {
        final locationDisplay = _controller.isUsingApiData
            ? '${_controller.currentCity}, ${_controller.weatherData?.countryName ?? "Indonesia"}'
            : 'Malang, Indonesia';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: AppBackground(
            child: SafeArea(
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

                          // 2. Calendar Header (Title, Subtitle, Location Selector)
                          CalendarHeader(
                            location: locationDisplay,
                            onLocationTap: _onLocationTap,
                          ),

                          const SizedBox(height: 10),

                          // 3. Monthly Calendar Card
                          WeatherCalendar(
                            initialDate: _selectedDate,
                            onDateSelected: _onDateSelected,
                          ),

                          const SizedBox(height: 10),

                          // 4. Selected-Day Forecast Card (Fokus Prakiraan)
                          SelectedDayForecastCard(
                            forecast: _getForecastForDate(_selectedDate),
                          ),

                          const SizedBox(height: 10),

                          // 5. Seven-Day Forecast List (Prakiraan 7 Hari Mendatang)
                          WeeklyForecastSection(
                            weeklyList: _controller.weeklyForecasts,
                          ),

                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),

                  // Floating Bottom Navigation Bar (Calendar is active = index 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 14.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0.0),
                            AppColors.background.withValues(alpha: 0.35),
                            AppColors.background.withValues(alpha: 0.70),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                      child: WeatherBottomNavigation(
                        currentIndex: 1,
                        onTap: _onNavTapped,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
