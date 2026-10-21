import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
import '../models/weather_model.dart';

/// Custom Exception yang ramah pengguna untuk masalah pada Weather API.
class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;

  const WeatherApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Service utama untuk berkomunikasi dengan Weather API.
///
/// Mendukung WeatherAPI.com sebagai penyedia utama dengan fallback otomatis
/// ke OpenWeatherMap jika pengguna memasukkan API Key OpenWeatherMap (32 hex).
class WeatherService {
  /// Singleton instance untuk kemudahan akses di seluruh aplikasi
  static final WeatherService instance = WeatherService();

  final http.Client _client;

  /// Cache respons cuaca terakhir yang berhasil diambil dari API
  WeatherApiResponse? lastForecastResponse;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data prakiraan cuaca lengkap (cuaca saat ini, hourly, & daily)
  Future<WeatherApiResponse> getForecast({
    String query = ApiConfig.defaultCity,
    int days = 7,
  }) async {
    _validateApiKey();

    // 1. Coba WeatherAPI.com
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.forecastEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query,
        'days': days.toString(),
        'aqi': 'no',
        'alerts': 'no',
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final result = _processResponse(response);
        lastForecastResponse = result;
        return result;
      }
    } on SocketException {
      throw const WeatherApiException(
        'Koneksi internet bermasalah. Periksa jaringan Anda.',
      );
    } on TimeoutException {
      throw const WeatherApiException(
        'Waktu permintaan habis (timeout). Silakan coba lagi.',
      );
    } catch (_) {}

    // 2. Coba OpenWeatherMap jika WeatherAPI belum berhasil (misal key OpenWeatherMap)
    final openWeatherRes = await _tryOpenWeatherMap(query);
    if (openWeatherRes != null) {
      lastForecastResponse = openWeatherRes;
      return openWeatherRes;
    }

    throw const WeatherApiException(
      'Gagal memuat data cuaca. Periksa API Key pada file .env atau koneksi internet Anda.',
    );
  }

  /// Mengambil data cuaca saat ini saja
  Future<WeatherApiResponse> getCurrentWeather({
    String query = ApiConfig.defaultCity,
  }) async {
    _validateApiKey();

    // 1. Coba WeatherAPI.com
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.currentEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query,
        'aqi': 'no',
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        return _processResponse(response);
      }
    } catch (_) {}

    // 2. Coba OpenWeatherMap
    final openWeatherRes = await _tryOpenWeatherMap(query);
    if (openWeatherRes != null) {
      return openWeatherRes;
    }

    throw const WeatherApiException(
      'Gagal memuat data cuaca saat ini.',
    );
  }

  /// Mencari lokasi atau kota berdasarkan kata kunci
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];
    _validateApiKey();

    // 1. Coba WeatherAPI.com /search.json
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.searchEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query.trim(),
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          return decoded.cast<Map<String, dynamic>>();
        }
      }
    } catch (_) {}

    // 2. Coba OpenWeatherMap geocoding
    try {
      final geoUri = Uri.parse('https://api.openweathermap.org/geo/1.0/direct')
          .replace(queryParameters: {
        'q': query.trim(),
        'limit': '5',
        'appid': ApiConfig.apiKey,
      });

      final response = await _client.get(geoUri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
      }
    } catch (_) {}

    return [];
  }

  // ========================================================
  // INTERNAL HELPERS
  // ========================================================

  Future<WeatherApiResponse?> _tryOpenWeatherMap(String query) async {
    try {
      final currentUri =
          Uri.parse('https://api.openweathermap.org/data/2.5/weather')
              .replace(queryParameters: {
        'q': query,
        'appid': ApiConfig.apiKey,
        'units': 'metric',
      });
      final forecastUri =
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast')
              .replace(queryParameters: {
        'q': query,
        'appid': ApiConfig.apiKey,
        'units': 'metric',
      });

      final currentRes =
          await _client.get(currentUri).timeout(ApiConfig.requestTimeout);
      if (currentRes.statusCode == 200) {
        final currentBody = jsonDecode(currentRes.body) as Map<String, dynamic>;
        Map<String, dynamic>? forecastBody;
        try {
          final forecastRes =
              await _client.get(forecastUri).timeout(ApiConfig.requestTimeout);
          if (forecastRes.statusCode == 200) {
            forecastBody = jsonDecode(forecastRes.body) as Map<String, dynamic>;
          }
        } catch (_) {}

        return WeatherApiResponse.fromOpenWeatherJson(currentBody, forecastBody);
      }
    } catch (_) {}
    return null;
  }

  void _validateApiKey() {
    if (!ApiConfig.isApiKeyConfigured) {
      throw const WeatherApiException(
        'API Key belum diisi. Masukkan API Key Anda di file .env (WEATHER_API_KEY).',
      );
    }
  }

  WeatherApiResponse _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return WeatherApiResponse.fromJson(body);
      } catch (e) {
        throw const WeatherApiException(
          'Format data dari server cuaca tidak sesuai.',
        );
      }
    } else {
      _handleHttpError(response.statusCode, response.body);
      throw const WeatherApiException('Gagal memproses data cuaca.');
    }
  }

  void _handleHttpError(int statusCode, String responseBody) {
    String? apiErrorMessage;
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map && decoded['error'] is Map) {
        apiErrorMessage = decoded['error']['message']?.toString();
      }
    } catch (_) {}

    switch (statusCode) {
      case 400:
        throw WeatherApiException(
          apiErrorMessage ?? 'Lokasi tidak ditemukan atau parameter tidak valid.',
          statusCode: 400,
        );
      case 401:
      case 403:
        throw WeatherApiException(
          'API Key tidak valid atau masa akses habis. Periksa file .env Anda.',
          statusCode: statusCode,
        );
      case 429:
        throw WeatherApiException(
          'Batas panggilan API (rate limit) telah tercapai. Tunggu beberapa saat.',
          statusCode: 429,
        );
      case 500:
      case 503:
        throw const WeatherApiException(
          'Server penyedia cuaca sedang bermasalah. Coba lagi nanti.',
          statusCode: 500,
        );
      default:
        throw WeatherApiException(
          apiErrorMessage ?? 'Terjadi kesalahan HTTP (Kode: $statusCode).',
          statusCode: statusCode,
        );
    }
  }

  /// Menutup http client jika sudah tidak digunakan
  void dispose() {
    _client.close();
  }
}
