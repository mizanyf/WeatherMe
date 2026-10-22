import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import '../data/services/weather_controller.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../widgets/add_city_bottom_sheet.dart';
import '../widgets/app_background.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/current_location_card.dart';
import '../widgets/location_feedback_dialog.dart';
import '../widgets/locations_header.dart';
import '../widgets/saved_city_card.dart';
import '../widgets/top_header.dart';
import '../widgets/weather_bottom_navigation.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  WeatherController get _controller => WeatherController.instance;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSearchClear() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
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
          _openAddCitySheet();
        },
        onRetry: () => _useMyLocation(),
      );
    }
  }

  void _openAddCitySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddCityBottomSheet(
          currentSavedCities: _controller.savedCities,
          onUseMyLocation: _useMyLocation,
          onCityAdded: (newCity) {
            _controller.addSavedCity(newCity);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${newCity.cityName} berhasil ditambahkan ke kota tersimpan.',
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.neutral,
              ),
            );
          },
        );
      },
    );
  }

  void _onCityTap(CityWeather city) {
    _controller.selectCity(city);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lokasi aktif diubah ke ${city.displayName}.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  void _onNavTapped(int index) {
    if (index == 0) {
      // Navigate to Home
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 1) {
      // Navigate to Calendar
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CalendarScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _controller.isUsingApiData
              ? 'Sinkronisasi Lokasi dengan WeatherAPI.com Aktif'
              : 'Pengaturan lokasi cuaca (Mode Demo)',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  List<CityWeather> get _displayedCities {
    final list = _controller.savedCities;
    if (_searchQuery.trim().isEmpty) {
      return list;
    }
    final query = _searchQuery.toLowerCase();
    return list.where((city) {
      return city.cityName.toLowerCase().contains(query) ||
          city.country.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: WeatherController.instance,
      builder: (context, _) {
        final displayedList = _displayedCities;

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
                          TopHeader(
                            onSettingsTap: _onSettingsTap,
                          ),

                          // 2. Locations Header
                          const LocationsHeader(),

                          if (_controller.errorMessage != null)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 4.0,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: const Color(0xFFFECACA),
                                  width: 1.0,
                                ),
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
                                    onTap: _useMyLocation,
                                    borderRadius: BorderRadius.circular(6),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
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
                                ],
                              ),
                            ),

                          const SizedBox(height: 6),

                          // 3. City Search Bar
                          CitySearchBar(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            onClear: _onSearchClear,
                          ),

                          const SizedBox(height: 4),

                          // 4. Current Location Card
                          if (_searchQuery.isEmpty)
                            CurrentLocationCard(
                              city: _controller.currentLocationCity,
                              onUseLocationTap: _useMyLocation,
                              isLocating: _controller.isLocating,
                              isDeviceLocation: _controller.isDeviceLocation,
                            ),

                          const SizedBox(height: 10),

                          // 5. Saved Cities Section Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _searchQuery.isEmpty
                                      ? 'Kota Tersimpan'
                                      : 'Hasil Pencarian (${displayedList.length})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.neutral,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                if (_searchQuery.isEmpty)
                                  InkWell(
                                    onTap: _openAddCitySheet,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFE0F7FC),
                                            Color(0xFFBAE6FD),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                          width: 1.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.15,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_rounded,
                                            size: 15,
                                            color: AppColors.secondary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Tambah Kota',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // 6. Saved Cities List
                          if (displayedList.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 36.0,
                                horizontal: 20.0,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.location_off_rounded,
                                    size: 48,
                                    color: AppColors.mutedText.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Kota tidak ditemukan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Coba gunakan kata kunci nama kota atau negara yang lain.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 4.0,
                              ),
                              itemCount: displayedList.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final city = displayedList[index];
                                return SavedCityCard(
                                  city: city,
                                  onTap: () => _onCityTap(city),
                                );
                              },
                            ),

                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  ),

                  // Floating Bottom Navigation Bar (Locations is active = index 2)
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
                        currentIndex: 2,
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
