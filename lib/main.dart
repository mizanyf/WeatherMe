import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi environment variables dari .env
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // Berjalan dengan mode fallback jika file .env belum terisi
  }

  runApp(const WeatherMeApp());
}

class WeatherMeApp extends StatelessWidget {
  const WeatherMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
