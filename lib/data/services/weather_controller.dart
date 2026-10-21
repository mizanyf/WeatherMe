import 'package:flutter/material.dart';

import '../../core/config/api_config.dart';
import '../../models/weather_models.dart';
import '../models/weather_model.dart';
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

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUsingApiData => _isUsingApiData;

  // ========================================================
  // ACTIONS & DATA FETCHING
  // ========================================================

  /// Mengambil data cuaca untuk kota saat ini atau kota yang ditentukan
  Future<void> fetchWeather({String? city}) async {
    if (city != null && city.trim().isNotEmpty) {
      _currentCity = city.trim();
    }

    // Jika API Key belum diisi di .env, tetap dalam Mode Demo/Mock
    if (!ApiConfig.isApiKeyConfigured) {
      _isUsingApiData = false;
      _isLoading = false;
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

  /// Memilih kota aktif dari Halaman Lokasi
  Future<void> selectCity(CityWeather city) async {
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
