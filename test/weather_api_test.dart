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

    test('HourlyForecast.mockList dynamically generates Sekarang and sequential future hours', () {
      final mock = responseOrMock();
      expect(mock.first.time, 'Sekarang');
      expect(mock.first.isCurrent, isTrue);
      expect(mock.length, greaterThanOrEqualTo(8));

      // Verifikasi jam-jam berikutnya adalah jam berurutan
      final now = DateTime.now();
      for (int i = 1; i < mock.length; i++) {
        final expectedHour = (now.hour + i) % 24;
        final expectedHourStr = '${expectedHour.toString().padLeft(2, '0')}:00';
        expect(mock[i].time, expectedHourStr);
        expect(mock[i].isCurrent, isFalse);
      }
    });

    test('fromOpenWeatherJson parses hourly forecast with Sekarang and sequential future hours', () {
      final currentJson = {
        'name': 'Malang',
        'sys': {'country': 'ID'},
        'main': {'temp': 30.0, 'feels_like': 32.0, 'humidity': 65, 'temp_max': 32.0, 'temp_min': 24.0},
        'weather': [{'id': 800, 'main': 'Clear', 'description': 'langit cerah'}],
        'wind': {'speed': 3.5},
      };

      final nowUtcSec = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final forecastJson = {
        'city': {'name': 'Malang', 'timezone': 25200},
        'list': [
          // Slot 3 jam ke depan
          {
            'dt': nowUtcSec + 7200, // +2 jam
            'main': {'temp': 29.0},
            'weather': [{'id': 801, 'main': 'Clouds', 'description': 'cerah berawan'}],
          },
          {
            'dt': nowUtcSec + 18000, // +5 jam
            'main': {'temp': 27.0},
            'weather': [{'id': 802, 'main': 'Clouds', 'description': 'berawan'}],
          },
        ],
      };

      final response = WeatherApiResponse.fromOpenWeatherJson(currentJson, forecastJson);
      expect(response.hourlyList.first.time, 'Sekarang');
      expect(response.hourlyList.first.isCurrent, isTrue);

      final nowCity = DateTime.now().toUtc().add(const Duration(seconds: 25200));
      for (int i = 1; i < response.hourlyList.length; i++) {
        final expectedHour = (nowCity.add(Duration(hours: i))).hour;
        final expectedHourStr = '${expectedHour.toString().padLeft(2, '0')}:00';
        expect(response.hourlyList[i].time, expectedHourStr);
        expect(response.hourlyList[i].isCurrent, isFalse);
      }
    });
  });
}

List<dynamic> responseOrMock() => WeatherApiResponse.fromJson({}).hourlyList;

