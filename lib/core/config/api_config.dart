import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi dasar untuk Weather API.
///
/// Menyediakan konstanta endpoint resmi WeatherAPI.com, timeout,
/// dan pengambil API Key aman dari environment file (.env).
class ApiConfig {
  /// Nama variabel environment untuk API Key di dalam file .env
  static const String apiKeyVariable = 'WEATHER_API_KEY';

  /// Base URL resmi WeatherAPI.com
  static const String baseUrl = 'https://api.weatherapi.com/v1';

  /// Endpoint untuk mengambil data cuaca saat ini
  static const String currentEndpoint = '/current.json';

  /// Endpoint untuk mengambil prakiraan cuaca (harian & per jam)
  static const String forecastEndpoint = '/forecast.json';

  /// Endpoint untuk pencarian nama kota atau koordinat
  static const String searchEndpoint = '/search.json';

  /// Durasi batas waktu (timeout) untuk permintaan HTTP
  static const Duration requestTimeout = Duration(seconds: 12);

  /// Kota default awal saat aplikasi dibuka
  static const String defaultCity = 'Malang';

  /// Mengambil API Key dari .env secara aman tanpa mengekspos exception
  static String get apiKey {
    try {
      final key = dotenv.env[apiKeyVariable] ?? '';
      return key.trim();
    } catch (_) {
      return '';
    }
  }

  /// Mengecek apakah pengguna sudah mengisi API Key yang valid di file .env
  static bool get isApiKeyConfigured {
    final key = apiKey;
    return key.isNotEmpty &&
        key != 'MASUKKAN_API_KEY_DI_SINI' &&
        !key.contains('MASUKKAN');
  }
}
