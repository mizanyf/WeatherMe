import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherme/main.dart';

void main() {
  testWidgets('WeatherMe Home screen smoke test', (WidgetTester tester) async {
    // Build WeatherMe app and trigger a frame.
    await tester.pumpWidget(const WeatherMeApp());

    // Verify location is present
    expect(find.text('Malang, Indonesia'), findsOneWidget);

    // Verify condition badge
    expect(find.text('Cerah Berawan'), findsOneWidget);

    // Verify temperature display
    expect(find.text('28'), findsOneWidget);

    // Verify current weather metrics card (Hujan, Kelembapan, Kec. Angin, Indeks UV)
    expect(find.text('Hujan'), findsOneWidget);
    expect(find.text('Kelembapan'), findsOneWidget);
    expect(find.text('Kec. Angin'), findsOneWidget);
    expect(find.text('Indeks UV'), findsOneWidget);
    expect(find.text('Sedang 5'), findsOneWidget);

    // Verify hourly forecast title
    expect(find.text('Perkiraan Hari Ini'), findsOneWidget);

    // Verify multi-day forecast title (3 hari mendatang di beranda)
    expect(find.text('Perkiraan 3 Hari Mendatang'), findsOneWidget);

    // Verify bottom navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kalender'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);
  });

  testWidgets('WeatherMe Calendar screen navigation and interaction test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WeatherMeApp());

    // Tap 'Kalender' in bottom navigation
    await tester.tap(find.text('Kalender'));
    await tester.pumpAndSettle();

    // Verify Calendar screen title and subtitle
    expect(find.text('Kalender Cuaca'), findsOneWidget);
    expect(
      find.text('Rencanakan harimu dengan perkiraan cuaca'),
      findsOneWidget,
    );

    // Verify Monthly calendar header (initial mock is October 2026)
    expect(find.text('Oktober 2026'), findsOneWidget);

    // Verify Fokus Perkiraan section
    expect(find.text('FOKUS PERKIRAAN'), findsOneWidget);
    expect(find.textContaining('Oktober'), findsWidgets);
    expect(find.text('Hujan'), findsOneWidget);

    // Verify 7-day forecast section (tanpa tombol Detail)
    expect(find.text('Perkiraan 7 Hari Mendatang'), findsOneWidget);
    expect(find.text('Detail'), findsNothing);

    // Tap 'Beranda' to navigate back to Home
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();

    // Verify we are back on Home screen
    expect(find.text('Perkiraan Hari Ini'), findsOneWidget);
  });

  testWidgets('WeatherMe Locations screen navigation and interaction test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WeatherMeApp());

    // Tap 'Lokasi' in bottom navigation
    await tester.tap(find.text('Lokasi'));
    await tester.pumpAndSettle();

    // Verify Locations screen title and subtitle
    expect(find.text('Jelajahi Lokasi'), findsOneWidget);
    expect(
      find.text('Temukan cuaca di berbagai belahan dunia'),
      findsOneWidget,
    );

    // Verify search field placeholder
    expect(find.text('Cari kota atau negara...'), findsOneWidget);

    // Verify Current Location card
    expect(find.text('LOKASI SAAT INI'), findsOneWidget);
    expect(find.text('Malang, Indonesia'), findsOneWidget);

    // Verify Saved Cities section
    expect(find.text('Kota Tersimpan'), findsOneWidget);
    expect(find.text('Tambah Lokasi'), findsOneWidget);
    expect(find.text('Jakarta, Indonesia'), findsOneWidget);
    expect(find.text('Tokyo, Jepang'), findsOneWidget);
    expect(find.text('London, Inggris'), findsOneWidget);
    expect(find.text('Sydney, Australia'), findsOneWidget);

    // Test search filter
    await tester.enterText(find.byType(TextField), 'Tokyo');
    await tester.pumpAndSettle();

    // Tokyo should still be visible, London should be filtered out
    expect(find.text('Tokyo, Jepang'), findsOneWidget);
    expect(find.text('London, Inggris'), findsNothing);

    // Clear search
    await tester.tap(find.byTooltip('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('London, Inggris'), findsOneWidget);

    // Tap 'Beranda' to navigate back to Home
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();

    // Verify we are back on Home screen
    expect(find.text('Perkiraan Hari Ini'), findsOneWidget);
  });
}
