import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/services/weather_controller.dart';
import '../models/weather_models.dart';
import '../theme/app_colors.dart';
import 'city_search_bar.dart';
import 'weather_icon.dart';

class AddCityBottomSheet extends StatefulWidget {
  final List<CityWeather> currentSavedCities;
  final ValueChanged<CityWeather> onCityAdded;
  final VoidCallback? onUseMyLocation;

  const AddCityBottomSheet({
    super.key,
    required this.currentSavedCities,
    required this.onCityAdded,
    this.onUseMyLocation,
  });

  @override
  State<AddCityBottomSheet> createState() => _AddCityBottomSheetState();
}

class _AddCityBottomSheetState extends State<AddCityBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CityWeather> _filteredCities = CityWeather.availableCitiesPool;

  @override
  void initState() {
    super.initState();
    _filteredCities = CityWeather.availableCitiesPool;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _filteredCities = CityWeather.availableCitiesPool;
        });
      }
      return;
    }

    final results = await WeatherController.instance.searchCities(query);
    if (mounted) {
      setState(() {
        _filteredCities = results;
      });
    }
  }

  bool _isAlreadySaved(CityWeather city) {
    return widget.currentSavedCities.any(
      (saved) =>
          saved.id == city.id ||
          (saved.cityName.toLowerCase() == city.cityName.toLowerCase() &&
              saved.country.toLowerCase() == city.country.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma,
            sigmaY: AppColors.glassBlurSigma,
          ),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32.0),
              ),
              border: Border.all(color: AppColors.glassBorder, width: 1.2),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0F7FC), // Soft Ice Sky
                  Color(0xFFF0FDFE), // Frosted Pure White-Blue
                  Color(0xFFBAE6FD), // Ambient Blue Accent
                ],
                stops: [0.0, 0.55, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 30,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),

                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah Lokasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutral,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.glassBorder,
                            width: 0.8,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppColors.neutral,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Field (sama seperti pada halaman lokasi diatas kondisi cuaca)
                CitySearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),

                // Opsi Cepat: Gunakan Lokasi Saya (seperti pada CurrentLocationCard)
                if (widget.onUseMyLocation != null &&
                    _searchController.text.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onUseMyLocation?.call();
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF48CBE8), // AppColors.primary
                              Color(0xFF0284C7), // AppColors.secondary
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.32),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Gunakan Lokasi Saya',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 4),

                // Available Cities List
                Flexible(
                  child: _filteredCities.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              'Kota tidak ditemukan.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: _filteredCities.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final city = _filteredCities[index];
                            final alreadySaved = _isAlreadySaved(city);

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                  width: 0.9,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Weather Icon matching app theme
                                  SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Center(
                                      child: WeatherIcon(
                                        conditionType: city.conditionType,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // City Name and Country
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          city.cityName,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.neutral,
                                          ),
                                        ),
                                        Text(
                                          city.country,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.mutedText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Temperature preview
                                  Text(
                                    '${city.temperature}°',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.neutral,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Add Button or Already Added Badge
                                  if (alreadySaved)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.border.withValues(
                                          alpha: 0.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Tersimpan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.mutedText,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF38BDF8),
                                            Color(0xFF0284C7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.25),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            widget.onCityAdded(city);
                                            Navigator.of(context).pop();
                                          },
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 7,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_rounded,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Tambah',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
