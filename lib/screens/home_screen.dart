import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'locations_screen.dart';
import '../core/config/api_config.dart';
import '../data/services/weather_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/current_weather_metrics_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/weekly_forecast_list.dart';
import '../widgets/location_feedback_dialog.dart';
import '../widgets/top_header.dart';
import '../widgets/weather_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  WeatherController get _controller => WeatherController.instance;

  @override
  void initState() {
    super.initState();
    // Memuat data cuaca dari WeatherAPI saat pertama kali dibuka
    _controller.fetchWeather();
  }

  Future<void> _useMyLocation() async {
    final result = await _controller.fetchWeatherByCurrentLocation();
    if (!mounted) return;

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lokasi terdeteksi: ${_controller.currentCity}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      LocationFeedbackDialog.show(
        context,
        result: result,
        onManualSearchSelected: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LocationsScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        onRetry: () => _useMyLocation(),
      );
    }
  }

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
        content: Text(
          ApiConfig.isApiKeyConfigured
              ? 'Terhubung ke WeatherAPI.com • Lokasi: ${_controller.currentCity}'
              : 'Mode Demo: Buka file .env dan isi WEATHER_API_KEY',
        ),
        duration: const Duration(seconds: 3),
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
        return Scaffold(
          backgroundColor: AppColors.background,
          body: AppBackground(
            child: SafeArea(
              child: Stack(
                children: [
                  // Scrollable Content dengan Pull-to-Refresh
                  Positioned.fill(
                    child: RefreshIndicator(
                      onRefresh: () => _controller.fetchWeather(),
                      color: AppColors.primary,
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(bottom: 110.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Top Header
                            TopHeader(
                              onSettingsTap: _onSettingsTap,
                            ),

                            // Banner status data (Loading / Error / Live API / Demo)
                            _buildApiStatusBanner(),

                            // 2. Current Weather Hero Card
                            CurrentWeatherCard(weather: _controller.currentWeather),

                            const SizedBox(height: 6),

                            // 3. Current Weather Metrics Card (Hujan, Kelembapan, Kec. Angin, Indeks UV)
                            CurrentWeatherMetricsCard(weather: _controller.currentWeather),

                            const SizedBox(height: 12),

                            // 4. Hourly Forecast Section
                            HourlyForecastSection(
                              hourlyList: _controller.hourlyForecasts,
                              onMoreTap: _onCalendarActionTap,
                            ),

                            const SizedBox(height: 14),

                            // 5. Multi-Day Forecast Section (desain sama dengan halaman kalender, tanpa tombol "Lihat Kalender")
                            WeeklyForecastSection(
                              weeklyList: _controller.weeklyForecasts,
                              title: 'Prakiraan 7 Hari Mendatang',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Floating Bottom Navigation Bar with Soft Glass-Friendly Gradient Mask
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
                        currentIndex: _selectedNavIndex,
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

  /// Banner status sumber data yang elegan & informatif
  Widget _buildApiStatusBanner() {
    if (_controller.isLoading == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            minHeight: 2.5,
            backgroundColor: Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      );
    }

    if (_controller.errorMessage != null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFFECACA), width: 1.0),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: Color(0xFFDC2626),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _controller.errorMessage!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (_controller.isLocating == true) {
                  _useMyLocation();
                } else {
                  _controller.fetchWeather();
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                _controller.clearError();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LocationsScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  'Pilih Kota',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Tampilan status badge (Live API / Mode Demo) dihilangkan sesuai permintaan
    return const SizedBox.shrink();
  }
}
