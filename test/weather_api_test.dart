import 'package:flutter_test/flutter_test.dart';
import 'package:weatherme/core/config/api_config.dart';
import 'package:weatherme/data/models/weather_model.dart';

void main() {
  group('ApiConfig Tests', () {
    test('ApiConfig has valid default base URL and endpoints', () {
      expect(ApiConfig.baseUrl, 'https://api.weatherapi.com/v1');
      expect(ApiConfig.currentEndpoint, '/current.json');
      expect(ApiConfig.forecastEndpoint, '/forecast.json');
      expect(ApiConfig.searchEndpoint, '/search.json');
      expect(ApiConfig.apiKeyVariable, 'WEATHER_API_KEY');
      expect(ApiConfig.defaultCity, 'Malang');
    });

    test('isApiKeyConfigured returns false when key is empty or placeholder', () {
      expect(ApiConfig.isApiKeyConfigured, isFalse);
    });
  });

  group('WeatherApiResponse Parsing Tests', () {
    test('Parses WeatherAPI json correctly and converts to CurrentWeather', () {
      final mockJson = {
        'location': {
          'name': 'Malang',
          'region': 'East Java',
          'country': 'Indonesia',
          'localtime': '2026-10-24 10:30',
        },
        'current': {
          'temp_c': 28.5,
          'feelslike_c': 30.2,
          'humidity': 72,
          'wind_kph': 14.4,
          'uv': 5.0,
          'condition': {
            'text': 'Partly cloudy',
            'code': 1003,
          },
        },
        'forecast': {
          'forecastday': [
            {
              'date': '2026-10-24',
              'day': {
                'maxtemp_c': 31.0,
                'mintemp_c': 22.0,
                'daily_chance_of_rain': 10,
                'avghumidity': 70,
                'maxwind_kph': 15.0,
                'uv': 5.0,
                'condition': {
                  'text': 'Partly cloudy',
                  'code': 1003,
                },
              },
              'hour': [
                {
                  'time': '2026-10-24 10:00',
                  'temp_c': 28.0,
                  'condition': {'text': 'Partly cloudy', 'code': 1003},
                },
              ],
            },
          ],
        },
      };

      final response = WeatherApiResponse.fromJson(mockJson);

      expect(response.cityName, 'Malang');
      expect(response.countryName, 'Indonesia');
      expect(response.conditionText, 'Cerah Berawan');
      expect(response.tempC, 28.5);
      expect(response.humidity, 72);
      expect(response.rainChance, 10);

      final currentWeather = response.toCurrentWeather();
      expect(currentWeather.location, 'Malang, Indonesia');
      expect(currentWeather.temperature, 29); // 28.5 rounded
      expect(currentWeather.humidity, 72);
      expect(currentWeather.rainChance, '10%');
      expect(currentWeather.uvIndex, 'Sedang 5');
    });

    test('Defensive fallback on empty or malformed json', () {
      final emptyJson = <String, dynamic>{};
      final response = WeatherApiResponse.fromJson(emptyJson);

      expect(response.cityName, 'Malang');
      expect(response.countryName, 'Indonesia');
      expect(response.tempC, 28.0);
      expect(response.humidity, 70);
      expect(response.hourlyList.isNotEmpty, isTrue);
      expect(response.dailyList.isNotEmpty, isTrue);

      final currentWeather = response.toCurrentWeather();
      expect(currentWeather.temperature, 28);
      expect(currentWeather.condition, isNotEmpty);
    });
  });
}
