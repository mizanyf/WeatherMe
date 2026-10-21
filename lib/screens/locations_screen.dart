import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import '../widgets/add_city_bottom_sheet.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/current_location_card.dart';
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
  String _searchQuery = '';

  // Local state for current location and saved cities
  CityWeather _currentLocation = CityWeather.currentLocation;
  late List<CityWeather> _savedCities;

  // Quick filter chips matching bottom of screenshot
  final List<String> _quickChips = [
    'Paris',
    'Tokyo',
    'Bali',
    'New York',
    'Seoul',
  ];

  @override
  void initState() {
    super.initState();
    _savedCities = List.from(CityWeather.initialSavedCities);
  }

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

  void _toggleFavorite(int index) {
    setState(() {
      final city = _displayedCities[index];
      final actualIndex = _savedCities.indexWhere((c) => c.id == city.id);
      if (actualIndex != -1) {
        _savedCities[actualIndex] = _savedCities[actualIndex].copyWith(
          isFavorite: !_savedCities[actualIndex].isFavorite,
        );
      }
    });

    final city = _savedCities.firstWhere(
      (c) => c.id == _displayedCities[index].id,
      orElse: () => _displayedCities[index],
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          city.isFavorite
              ? '${city.cityName} ditambahkan ke favorit.'
              : '${city.cityName} dihapus dari favorit.',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  void _openAddCitySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddCityBottomSheet(
          currentSavedCities: _savedCities,
          onCityAdded: (newCity) {
            setState(() {
              _savedCities.add(newCity.copyWith(isFavorite: false));
            });

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
    setState(() {
      _currentLocation = city.copyWith(
        isCurrentLocation: true,
        localTime: 'Waktu lokal sekarang',
      );
    });

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
        content: const Text('Pengaturan lokasi cuaca'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.neutral,
      ),
    );
  }

  List<CityWeather> get _displayedCities {
    if (_searchQuery.trim().isEmpty) {
      return _savedCities;
    }
    final query = _searchQuery.toLowerCase();
    return _savedCities.where((city) {
      return city.cityName.toLowerCase().contains(query) ||
          city.country.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _displayedCities;

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

                    // 2. Locations Header
                    const LocationsHeader(),

                    const SizedBox(height: 4),

                    // 3. City Search Bar
                    CitySearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onClear: _onSearchClear,
                    ),

                    // 4. Current Location Card
                    if (_searchQuery.isEmpty)
                      CurrentLocationCard(city: _currentLocation),

                    const SizedBox(height: 8),

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
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral,
                              letterSpacing: -0.2,
                            ),
                          ),

                          // + Tambah Kota Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _openAddCitySheet,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 15,
                                      color: AppColors.neutral,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tambah Kota',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.neutral,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 6. Saved Cities List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: displayedList.isEmpty
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 24.0,
                              ),
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.location_off_rounded,
                                    size: 38,
                                    color: AppColors.mutedText,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Tidak ada kota yang cocok dengan "$_searchQuery"',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Coba kata kunci lain atau gunakan tombol "Tambah Kota".',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(displayedList.length, (
                                index,
                              ) {
                                final city = displayedList[index];
                                return SavedCityCard(
                                  city: city,
                                  onFavoriteTap: () => _toggleFavorite(index),
                                  onTap: () => _onCityTap(city),
                                );
                              }),
                            ),
                    ),

                    // 7. Quick City Suggestion Chips
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: _quickChips.map((cityName) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text(cityName),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral,
                              ),
                              backgroundColor: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: AppColors.border,
                                  width: 1.0,
                                ),
                              ),
                              onPressed: () {
                                _searchController.text = cityName;
                                _onSearchChanged(cityName);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 10),
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
                  currentIndex: 2,
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
