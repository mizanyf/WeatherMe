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

    final bool isOpenWeatherKey =
        RegExp(r'^[a-fA-F0-9]{32}$').hasMatch(ApiConfig.apiKey);

    // 1. Jika API Key adalah format 32-hex khas OpenWeatherMap, coba OpenWeatherMap lebih dulu
    if (isOpenWeatherKey) {
      final openWeatherRes = await _tryOpenWeatherMap(query);
      if (openWeatherRes != null) {
        lastForecastResponse = openWeatherRes;
        return openWeatherRes;
      }
    }

    // 2. Coba WeatherAPI.com
    WeatherApiException? weatherApiException;
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.forecastEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query,
        'days': days.toString(),
        'aqi': 'no',
        'alerts': 'no',
        'lang': 'id',
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final result = _processResponse(response);
        lastForecastResponse = result;
        return result;
      } else {
        try {
          _handleHttpError(response.statusCode, response.body);
        } on WeatherApiException catch (e) {
          weatherApiException = e;
        }
      }
    } on WeatherApiException catch (e) {
      weatherApiException = e;
    } on SocketException {
      throw const WeatherApiException(
        'Koneksi internet bermasalah. Periksa jaringan Anda.',
      );
    } on TimeoutException {
      throw const WeatherApiException(
        'Waktu permintaan habis (timeout). Silakan coba lagi.',
      );
    } catch (_) {}

    // 3. Coba fallback OpenWeatherMap jika belum dicoba
    if (!isOpenWeatherKey) {
      final openWeatherRes = await _tryOpenWeatherMap(query);
      if (openWeatherRes != null) {
        lastForecastResponse = openWeatherRes;
        return openWeatherRes;
      }
    }

    if (weatherApiException != null) {
      throw weatherApiException;
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

    final bool isOpenWeatherKey =
        RegExp(r'^[a-fA-F0-9]{32}$').hasMatch(ApiConfig.apiKey);

    if (isOpenWeatherKey) {
      final openWeatherRes = await _tryOpenWeatherMap(query);
      if (openWeatherRes != null) {
        return openWeatherRes;
      }
    }

    // 1. Coba WeatherAPI.com
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.currentEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query,
        'aqi': 'no',
        'lang': 'id',
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        return _processResponse(response);
      }
    } catch (_) {}

    // 2. Coba OpenWeatherMap jika belum dicoba
    if (!isOpenWeatherKey) {
      final openWeatherRes = await _tryOpenWeatherMap(query);
      if (openWeatherRes != null) {
        return openWeatherRes;
      }
    }

    throw const WeatherApiException(
      'Gagal memuat data cuaca saat ini.',
    );
  }

  /// Mencari lokasi atau kota berdasarkan kata kunci
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    _validateApiKey();

    final bool isOpenWeatherKey =
        RegExp(r'^[a-fA-F0-9]{32}$').hasMatch(ApiConfig.apiKey);

    // 1. Jika API Key adalah format OpenWeatherMap, coba geocoding OpenWeatherMap lebih dulu
    if (isOpenWeatherKey) {
      final owmResults = await _searchOpenWeather(trimmed);
      if (owmResults.isNotEmpty) return owmResults;
    }

    // 2. Coba WeatherAPI.com /search.json
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.searchEndpoint}')
          .replace(queryParameters: {
        'key': ApiConfig.apiKey,
        'q': trimmed,
      });

      final response = await _client.get(uri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          return decoded.cast<Map<String, dynamic>>();
        }
      }
    } catch (_) {}

    // 3. Fallback OpenWeatherMap jika belum dicoba
    if (!isOpenWeatherKey) {
      final owmResults = await _searchOpenWeather(trimmed);
      if (owmResults.isNotEmpty) return owmResults;
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> _searchOpenWeather(String query) async {
    try {
      final geoUri = Uri.parse('https://api.openweathermap.org/geo/1.0/direct')
          .replace(queryParameters: {
        'q': query,
        'limit': '5',
        'appid': ApiConfig.apiKey,
      });

      final response =
          await _client.get(geoUri).timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map<Map<String, dynamic>>((item) {
            final map = item as Map<String, dynamic>;
            final rawCountry = map['country']?.toString() ?? '';
            final countryName = rawCountry == 'ID' ? 'Indonesia' : rawCountry;
            final state = map['state']?.toString();
            final region = state != null && state.isNotEmpty ? state : countryName;

            return {
              'name': map['name']?.toString() ?? '',
              'region': region,
              'country': countryName,
              'lat': map['lat'],
              'lon': map['lon'],
            };
          }).toList();
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
      final isCoords = query.contains(',') &&
          double.tryParse(query.split(',').first.trim()) != null;
      final queryParams = <String, String>{
        'appid': ApiConfig.apiKey,
        'units': 'metric',
        'lang': 'id',
      };
      if (isCoords) {
        final parts = query.split(',');
        queryParams['lat'] = parts[0].trim();
        queryParams['lon'] = parts[1].trim();
      } else {
        queryParams['q'] = query;
      }

      final currentUri =
          Uri.parse('https://api.openweathermap.org/data/2.5/weather')
              .replace(queryParameters: queryParams);
      final forecastUri =
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast')
              .replace(queryParameters: queryParams);

      final currentRes =
          await _client.get(currentUri).timeout(ApiConfig.requestTimeout);
      if (currentRes.statusCode == 200) {
        final currentBody = jsonDecode(currentRes.body) as Map<String, dynamic>;

        // Jika pencarian berbasis koordinat, gunakan API Geocoding OpenWeatherMap untuk memperoleh
        // nama kota yang sebenarnya (misalnya "Malang" alih-alih nama daerah administratif "Kabupaten Malang")
        if (isCoords) {
          try {
            final geoUri = Uri.parse('https://api.openweathermap.org/geo/1.0/reverse')
                .replace(queryParameters: {
              'lat': queryParams['lat']!,
              'lon': queryParams['lon']!,
              'limit': '1',
              'appid': ApiConfig.apiKey,
            });
            final geoRes =
                await _client.get(geoUri).timeout(const Duration(seconds: 4));
            if (geoRes.statusCode == 200) {
              final geoList = jsonDecode(geoRes.body);
              if (geoList is List && geoList.isNotEmpty) {
                final geoMap = geoList.first as Map<String, dynamic>;
                final cleanName = geoMap['name']?.toString();
                if (cleanName != null && cleanName.isNotEmpty) {
                  currentBody['name'] = cleanName;
                }
              }
            }
          } catch (_) {}
        }

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
