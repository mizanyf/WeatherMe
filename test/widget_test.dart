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

    // Verify detail card labels
    expect(find.text('KELEMBAPAN\n'), findsOneWidget);

    // Verify hourly forecast title
    expect(find.text('Prakiraan Hari Ini'), findsOneWidget);

    // Verify 3-day forecast title
    expect(find.text('Prakiraan 3 Hari'), findsOneWidget);

    // Verify bottom navigation items
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kalender'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);
  });
}
