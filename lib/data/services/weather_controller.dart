import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/config/api_config.dart';
import '../../models/weather_models.dart';
import '../models/weather_model.dart';
import 'location_service.dart';
import 'weather_service.dart';

/// Centralized State Controller untuk cuaca di seluruh aplikasi WeatherMe.
///
/// Menggunakan [ChangeNotifier] bawaan Flutter sehingga semua halaman
/// (Beranda, Kalender, Lokasi) tersinkronisasi secara otomatis saat lokasi
/// aktif berubah atau data baru berhasil diambil dari WeatherAPI.com.
class WeatherController extends ChangeNotifier {
  /// Singleton instance untuk kemudahan akses di seluruh aplikasi
  static final WeatherController instance = WeatherController._internal();

  WeatherController._internal() {
    _isLoading = false;
    _isLocating = false;
    _isDeviceLocation = false;
    _isUsingApiData = false;
    _savedCities = List.from(CityWeather.initialSavedCities);
  }

  // ========================================================
  // STATE PROPERTIES
  // ========================================================

  String _currentCity = ApiConfig.defaultCity;
  WeatherApiResponse? _weatherData;

  CurrentWeather _currentWeather = CurrentWeather.mock;
  List<HourlyForecast> _hourlyForecasts = HourlyForecast.mockList;
  List<DailyForecast> _dailyForecasts = DailyForecast.mockList;
  List<WeeklyForecastItem> _weeklyForecasts = WeeklyForecastItem.mockList;
  Map<int, CalendarDayForecast> _calendarForecastMap = {};

  CityWeather _currentLocationCity = CityWeather.currentLocation;
  late List<CityWeather> _savedCities;

  bool _isLoading = false;
  bool _isLocating = false;
  bool _isDeviceLocation = false;
  double? _deviceLatitude;
  double? _deviceLongitude;
  String? _errorMessage;
  bool _isUsingApiData = false;

  // ========================================================
  // GETTERS
  // ========================================================

  String get currentCity => _currentCity;
  WeatherApiResponse? get weatherData => _weatherData;
  CurrentWeather get currentWeather => _currentWeather;
  List<HourlyForecast> get hourlyForecasts => _hourlyForecasts;
  List<DailyForecast> get dailyForecasts => _dailyForecasts;
  List<WeeklyForecastItem> get weeklyForecasts => _weeklyForecasts;
  Map<int, CalendarDayForecast> get calendarForecastMap => _calendarForecastMap;

  CityWeather get currentLocationCity => _currentLocationCity;
  List<CityWeather> get savedCities => List.unmodifiable(_savedCities);

  bool get isLoading => (_isLoading as dynamic) == true;
  bool get isLocating => (_isLocating as dynamic) == true;
  bool get isDeviceLocation => (_isDeviceLocation as dynamic) == true;
  double? get deviceLatitude => _deviceLatitude;
  double? get deviceLongitude => _deviceLongitude;
  String? get errorMessage => _errorMessage;
  bool get isUsingApiData => (_isUsingApiData as dynamic) == true;

  // ========================================================
  // ACTIONS & DATA FETCHING
  // ========================================================

  /// Mengambil data cuaca untuk kota saat ini atau kota yang ditentukan
  Future<void> fetchWeather({String? city}) async {
    if (city != null && city.trim().isNotEmpty) {
      _currentCity = city.trim();
      _isDeviceLocation = false;
    }

    // Jika API Key belum diisi di .env, tetap dalam Mode Demo/Mock
    if (!ApiConfig.isApiKeyConfigured) {
      _isUsingApiData = false;
      _isLoading = false;
      _isLocating = false;
      _errorMessage = null;
      _currentWeather = CurrentWeather.mock;
      _hourlyForecasts = HourlyForecast.mockList;
      _dailyForecasts = DailyForecast.mockList;
      _weeklyForecasts = WeeklyForecastItem.mockList;
      _currentLocationCity = CityWeather.currentLocation;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await WeatherService.instance.getForecast(
        query: _currentCity,
        days: 7,
      );

      _weatherData = response;
      _currentWeather = response.toCurrentWeather();
      _hourlyForecasts = response.hourlyList;
      _dailyForecasts = response.dailyList;
      _weeklyForecasts = response.weeklyList;
      _calendarForecastMap = response.calendarForecastMap;
      _currentLocationCity = response.toCityWeather(isCurrentLocation: true);
      _isUsingApiData = true;
      _isLoading = false;
      _errorMessage = null;

      // Update juga data kota tersimpan jika ada yang sama dengan kota aktif
      _updateSavedCityWeather(response.toCityWeather());

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _isUsingApiData = false;
      // Tetap gunakan mock data yang ramah agar tampilan tidak rusak
      _currentWeather = CurrentWeather.mock;
      _hourlyForecasts = HourlyForecast.mockList;
      _dailyForecasts = DailyForecast.mockList;
      _weeklyForecasts = WeeklyForecastItem.mockList;
      _currentLocationCity = CityWeather.currentLocation;
      notifyListeners();
    }
  }

  /// Mengambil data cuaca berdasarkan lokasi GPS perangkat saat ini
  /// menggunakan [LocationService] dan WeatherAPI.com (q=latitude,longitude).
  ///
  /// Menangani seluruh alur:
  /// 1. Pengecekan GPS & permission lokasi
  /// 2. Permintaan izin jika belum diberikan
  /// 3. Perolehan koordinat perangkat
  /// 4. Permintaan cuaca ke WeatherAPI.com dengan q=latitude,longitude
  /// 5. Pembaruan state dan UI dengan nama lokasi resmi dari respons API
  /// 6. Penanganan kegagalan dengan aman tanpa mengklaim lokasi palsu
  Future<LocationResult> fetchWeatherByCurrentLocation() async {
    _isLocating = true;
    _errorMessage = null;
    notifyListeners();

    final locationResult = await LocationService.instance.determinePosition();

    if (!locationResult.isSuccess) {
      _isLocating = false;
      // Jangan mengklaim lokasi pengguna sudah diperoleh jika izin/koordinat gagal
      _errorMessage = locationResult.errorMessage;
      notifyListeners();
      return locationResult;
    }

    final pos = locationResult.position!;
    _deviceLatitude = pos.latitude;
    _deviceLongitude = pos.longitude;

    // Jika API Key belum diisi di .env, beri tahu pengguna
    if (!ApiConfig.isApiKeyConfigured) {
      _isLocating = false;
      _isUsingApiData = false;
      _isDeviceLocation = false;
      _errorMessage =
          'API Key belum diisi di file .env (WEATHER_API_KEY). Silakan masukkan API Key Anda.';
      notifyListeners();
      return LocationResult(
        status: LocationStatus.locationError,
        errorMessage: _errorMessage,
      );
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 6. Kirim koordinat ke WeatherAPI.com menggunakan parameter q=latitude,longitude
      final coordsQuery = '${pos.latitude},${pos.longitude}';
      final response = await WeatherService.instance.getForecast(
        query: coordsQuery,
        days: 7,
      );

      // 7. Perbarui data cuaca pada UI berdasarkan respons API dan tampilkan nama lokasi dari respons API
      _weatherData = response;
      _currentCity = response.cityName;
      _currentWeather = response.toCurrentWeather();
      _hourlyForecasts = response.hourlyList;
      _dailyForecasts = response.dailyList;
      _weeklyForecasts = response.weeklyList;
      _calendarForecastMap = response.calendarForecastMap;

      // Update lokasi saat ini dengan nama lokasi dari respons API
      _currentLocationCity = response.toCityWeather(isCurrentLocation: true);

      _isUsingApiData = true;
      _isDeviceLocation = true;
      _isLoading = false;
      _isLocating = false;
      _errorMessage = null;

      // Update juga data kota tersimpan jika ada yang sama dengan kota aktif
      _updateSavedCityWeather(response.toCityWeather());

      notifyListeners();
      return locationResult;
    } catch (e) {
      _isLoading = false;
      _isLocating = false;
      // Jangan mengklaim lokasi diperoleh jika request API gagal
      _isDeviceLocation = false;
      _errorMessage = e.toString();
      notifyListeners();
      return LocationResult(
        status: LocationStatus.locationError,
        errorMessage: _errorMessage,
      );
    }
  }

  /// Menghapus pesan error aktif
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Memilih kota aktif dari Halaman Lokasi
  Future<void> selectCity(CityWeather city) async {
    _isDeviceLocation = false;
    _currentCity = city.cityName;
    _currentLocationCity = city.copyWith(
      isCurrentLocation: true,
      localTime: 'Waktu lokal sekarang',
    );
    notifyListeners();

    // Fetch data cuaca aktual dari WeatherAPI untuk kota terpilih
    await fetchWeather(city: city.cityName);
  }

  /// Menambahkan kota ke daftar kota tersimpan
  void addSavedCity(CityWeather city) {
    final alreadyExists = _savedCities.any(
      (c) => c.cityName.toLowerCase() == city.cityName.toLowerCase(),
    );
    if (!alreadyExists) {
      _savedCities.add(city.copyWith(isFavorite: false));
      notifyListeners();

      // Jika API Key aktif, fetch data aktual untuk kota baru ini di latar belakang
      if (ApiConfig.isApiKeyConfigured) {
        WeatherService.instance
            .getCurrentWeather(query: city.cityName)
            .then((res) {
          _updateSavedCityWeather(res.toCityWeather());
          notifyListeners();
        }).catchError((_) {});
      }
    }
  }

  /// Menghapus kota dari daftar tersimpan
  void removeSavedCity(String cityId) {
    _savedCities.removeWhere((c) => c.id == cityId);
    notifyListeners();
  }

  /// Mencari lokasi via WeatherAPI /search.json dengan fallback ke pool lokal
  Future<List<CityWeather>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return CityWeather.availableCitiesPool;
    }

    if (ApiConfig.isApiKeyConfigured) {
      try {
        final results = await WeatherService.instance.searchLocations(trimmed);
        if (results.isNotEmpty) {
          return results.map((item) {
            final name = item['name']?.toString() ?? '';
            final country = item['country']?.toString() ?? '';
            final id = '${name.toLowerCase()}_${country.toLowerCase()}';
            return CityWeather(
              id: id,
              cityName: name,
              country: country,
              temperature: 28,
              condition: 'Cerah Berawan',
              conditionType: WeatherConditionType.partlyCloudy,
              maxTemp: 30,
              minTemp: 22,
            );
          }).toList();
        }
      } catch (_) {
        // Fallback ke pencarian pool lokal jika API gagal
      }
    }

    final lower = trimmed.toLowerCase();
    return CityWeather.availableCitiesPool.where((c) {
      return c.cityName.toLowerCase().contains(lower) ||
          c.country.toLowerCase().contains(lower);
    }).toList();
  }

  void _updateSavedCityWeather(CityWeather updatedCity) {
    final index = _savedCities.indexWhere(
      (c) => c.cityName.toLowerCase() == updatedCity.cityName.toLowerCase(),
    );
    if (index != -1) {
      _savedCities[index] = updatedCity.copyWith(
        id: _savedCities[index].id,
        isFavorite: _savedCities[index].isFavorite,
      );
    }
  }
}
