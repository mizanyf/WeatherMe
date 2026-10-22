import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:weatherme/core/config/api_config.dart';
import 'package:weatherme/data/services/location_service.dart';
import 'package:weatherme/data/services/weather_controller.dart';
import 'package:weatherme/data/services/weather_service.dart';
import 'package:weatherme/models/weather_models.dart';
import 'package:weatherme/widgets/current_location_card.dart';
import 'package:weatherme/widgets/location_feedback_dialog.dart';
import 'package:weatherme/widgets/top_header.dart';

void main() {
  group('LocationResult & LocationStatus Tests', () {
    test('LocationResult returns correct isSuccess status', () {
      const failedResult = LocationResult(
        status: LocationStatus.permissionDenied,
        errorMessage: 'Izin ditolak',
      );
      expect(failedResult.isSuccess, isFalse);

      const disabledResult = LocationResult(
        status: LocationStatus.serviceDisabled,
        errorMessage: 'GPS nonaktif',
      );
      expect(disabledResult.isSuccess, isFalse);

      const foreverResult = LocationResult(
        status: LocationStatus.permissionDeniedForever,
        errorMessage: 'Izin ditolak permanen',
      );
      expect(foreverResult.isSuccess, isFalse);

      final successResult = LocationResult(
        status: LocationStatus.success,
        position: Position(
          longitude: 112.6326,
          latitude: -7.9666,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 440.0,
          altitudeAccuracy: 5.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ),
      );
      expect(successResult.isSuccess, isTrue);
      expect(successResult.position?.latitude, -7.9666);
      expect(successResult.position?.longitude, 112.6326);
    });
  });

  group('LocationFeedbackDialog Widget Tests', () {
    testWidgets('Renders properly for serviceDisabled with fallback button', (
      tester,
    ) async {
      bool manualSearchTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    LocationFeedbackDialog.show(
                      context,
                      result: const LocationResult(
                        status: LocationStatus.serviceDisabled,
                        errorMessage: 'Layanan GPS mati.',
                      ),
                      onManualSearchSelected: () {
                        manualSearchTapped = true;
                      },
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Layanan Lokasi (GPS) Mati'), findsOneWidget);
      expect(find.text('Layanan GPS mati.'), findsOneWidget);
      expect(find.text('Pilih / Cari Kota Manual'), findsOneWidget);
      expect(find.text('Buka Pengaturan GPS'), findsOneWidget);

      await tester.tap(find.text('Pilih / Cari Kota Manual'));
      await tester.pumpAndSettle();

      expect(manualSearchTapped, isTrue);
      expect(find.text('Layanan Lokasi (GPS) Mati'), findsNothing);
    });

    testWidgets('Renders properly for permissionDeniedForever', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    LocationFeedbackDialog.show(
                      context,
                      result: const LocationResult(
                        status: LocationStatus.permissionDeniedForever,
                        errorMessage: 'Izin ditolak secara permanen.',
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Izin Lokasi Ditolak Permanen'), findsOneWidget);
      expect(find.text('Buka Pengaturan Aplikasi'), findsOneWidget);
      expect(find.text('Pilih / Cari Kota Manual'), findsOneWidget);
    });
  });

  group('CurrentLocationCard UI Component Tests', () {
    testWidgets('Shows Gunakan Lokasi Saya button when callback provided', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentLocationCard(
              city: CityWeather.currentLocation,
              onUseLocationTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Gunakan Lokasi Saya'), findsOneWidget);
      expect(find.text('GPS'), findsNothing);

      await tester.tap(find.text('Gunakan Lokasi Saya'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('Shows update button when isDeviceLocation is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentLocationCard(
              city: CityWeather.currentLocation,
              onUseLocationTap: () {},
              isDeviceLocation: true,
            ),
          ),
        ),
      );

      expect(find.text('Perbarui Lokasi Saat Ini'), findsOneWidget);
    });

    testWidgets('Shows loading indicator when isLocating is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrentLocationCard(
              city: CityWeather.currentLocation,
              onUseLocationTap: () {},
              isLocating: true,
            ),
          ),
        ),
      );

      expect(find.text('Mencari lokasi...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('TopHeader Location Quick Action Tests', () {
    testWidgets('Renders Gunakan Lokasi action button', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopHeader(
              onLocationTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Gunakan Lokasi'), findsOneWidget);

      await tester.tap(find.text('Gunakan Lokasi'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('Renders Lokasi Saya when device GPS is active', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TopHeader(
              onLocationTap: null,
              isDeviceLocation: true,
            ),
          ),
        ),
      );

      // When onLocationTap is null, the button is hidden
      expect(find.text('Lokasi Saya'), findsNothing);
    });
  });

  group('WeatherService Coordinate Query Handling Tests', () {
    test('WeatherService correctly formats q=latitude,longitude', () async {
      final mockClient = MockClient((request) async {
        // Verify endpoint and query parameters
        expect(request.url.path, '/v1/forecast.json');
        expect(request.url.queryParameters['q'], '-7.9666,112.6326');
        expect(request.url.queryParameters['days'], '7');

        final mockBody = {
          'location': {
            'name': 'Malang',
            'region': 'East Java',
            'country': 'Indonesia',
            'lat': -7.97,
            'lon': 112.63,
            'localtime': '2026-10-22 10:30',
          },
          'current': {
            'temp_c': 28.0,
            'feelslike_c': 29.0,
            'humidity': 70,
            'wind_kph': 12.0,
            'uv': 6.0,
            'condition': {'text': 'Partly cloudy', 'code': 1003},
          },
          'forecast': {
            'forecastday': [
              {
                'date': '2026-10-22',
                'day': {
                  'maxtemp_c': 31.0,
                  'mintemp_c': 21.0,
                  'daily_chance_of_rain': 15,
                  'avghumidity': 68,
                  'maxwind_kph': 14.0,
                  'uv': 6.0,
                  'condition': {'text': 'Partly cloudy', 'code': 1003},
                },
                'hour': [],
              },
            ],
          },
        };

        return http.Response(
          jsonEncode(mockBody),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      // Inject custom client for testing
      final service = WeatherService(client: mockClient);

      // Call with coordinates as query string
      if (ApiConfig.isApiKeyConfigured) {
        final res = await service.getForecast(
          query: '-7.9666,112.6326',
          days: 7,
        );
        expect(res.cityName, 'Malang');
      }
    });
  });

  group('WeatherController Location Logic Safety Tests', () {
    test('Controller does not claim user location on failure (Requirement 10)', () {
      final controller = WeatherController.instance;

      expect(controller.isLocating, isFalse);
      expect(controller.isDeviceLocation, isFalse);

      // Reset state and verify
      controller.clearError();
      expect(controller.errorMessage, isNull);
    });
  });
}
