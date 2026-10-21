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
  late CalendarDayForecast _selectedForecast;
  WeatherController get _controller => WeatherController.instance;

  @override
  void initState() {
    super.initState();
    // Default initial mock date: 21 Oktober 2026
    _selectedDate = DateTime(2026, 10, 21);
    _selectedForecast = CalendarDayForecast.initial;

    // Jika data API sudah tersedia untuk tanggal hari ini, sinkronisasikan
    if (_controller.isUsingApiData &&
        _controller.calendarForecastMap.containsKey(DateTime.now().day)) {
      final today = DateTime.now();
      _selectedDate = today;
      _selectedForecast = _controller.calendarForecastMap[today.day]!;
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;

      // 1. Cek apakah tanggal tersedia dari respons API aktual (rentang hari forecast API)
      if (_controller.calendarForecastMap.containsKey(date.day)) {
        _selectedForecast = _controller.calendarForecastMap[date.day]!;
        return;
      }

      // 2. Fallback ke data mock kalender Oktober 2026
      if (date.year == 2026 &&
          date.month == 10 &&
          CalendarDayForecast.mockOctober.containsKey(date.day)) {
        _selectedForecast = CalendarDayForecast.mockOctober[date.day]!;
      } else {
        // Dynamic fallback mock untuk tanggal di luar cakupan
        final dayNames = [
          'Senin',
          'Selasa',
          'Rabu',
          'Kamis',
          'Jumat',
          'Sabtu',
          'Minggu',
        ];
        final monthNames = [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember',
        ];

        final dayName = dayNames[date.weekday - 1];
        final dateFormatted = '${date.day} ${monthNames[date.month - 1]}';

        _selectedForecast = CalendarDayForecast(
          date: date,
          dayName: dayName,
          dateFormatted: dateFormatted,
          condition: 'Cerah Berawan',
          conditionType: WeatherConditionType.partlyCloudy,
          temperature: 28,
          maxTemp: 30,
          minTemp: 21,
          rainChance: '5%',
          humidity: '65%',
          windSpeed: '11 km/j',
          uvIndex: 'Sedang 6',
        );
      }
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

  void _onDetailActionTap() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _controller.isUsingApiData
              ? 'Prakiraan 7 hari sinkron dengan WeatherAPI.com'
              : 'Prakiraan 7 Hari Lengkap (Mode Demo)',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
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
                          SelectedDayForecastCard(forecast: _selectedForecast),

                          const SizedBox(height: 10),

                          // 5. Seven-Day Forecast List (Prakiraan 7 Hari Mendatang)
                          WeeklyForecastSection(
                            weeklyList: _controller.weeklyForecasts,
                            onDetailTap: _onDetailActionTap,
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
