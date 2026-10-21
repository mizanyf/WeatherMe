import '../../models/weather_models.dart';

/// Model respons cuaca dari WeatherAPI.com.
///
/// Bertanggung jawab untuk parsing JSON resmi dari endpoint WeatherAPI
/// dan mengonversinya ke model antarmuka WeatherMe.
class WeatherApiResponse {
  final String cityName;
  final String countryName;
  final String localTime;
  final double tempC;
  final double feelsLikeC;
  final int humidity;
  final double windKph;
  final double uvIndex;
  final String conditionText;
  final int conditionCode;
  final double maxTempC;
  final double minTempC;
  final int rainChance;
  final List<HourlyForecast> hourlyList;
  final List<DailyForecast> dailyList;
  final List<WeeklyForecastItem> weeklyList;
  final Map<int, CalendarDayForecast> calendarForecastMap;

  const WeatherApiResponse({
    required this.cityName,
    required this.countryName,
    required this.localTime,
    required this.tempC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKph,
    required this.uvIndex,
    required this.conditionText,
    required this.conditionCode,
    required this.maxTempC,
    required this.minTempC,
    required this.rainChance,
    required this.hourlyList,
    required this.dailyList,
    required this.weeklyList,
    required this.calendarForecastMap,
  });

  /// Factory untuk parsing respons JSON dari endpoint /forecast.json atau /current.json
  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) {
    // 1. Parsing Location
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final cityName = location['name']?.toString() ?? 'Malang';
    final countryName = location['country']?.toString() ?? 'Indonesia';
    final localTimeRaw = location['localtime']?.toString() ?? '';

    // 2. Parsing Current Weather
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final tempC = _toDouble(current['temp_c']) ?? 28.0;
    final feelsLikeC = _toDouble(current['feelslike_c']) ?? tempC;
    final humidity = _toInt(current['humidity']) ?? 70;
    final windKph = _toDouble(current['wind_kph']) ?? 10.0;
    final uvIndex = _toDouble(current['uv']) ?? 5.0;

    final conditionObj = current['condition'] as Map<String, dynamic>? ?? {};
    final conditionRawText =
        conditionObj['text']?.toString() ?? 'Partly cloudy';
    final conditionCode = _toInt(conditionObj['code']) ?? 1003;
    final translatedCondition = _translateCondition(conditionRawText);

    // 3. Parsing Forecast
    final forecastObj = json['forecast'] as Map<String, dynamic>? ?? {};
    final forecastDays = forecastObj['forecastday'] as List<dynamic>? ?? [];

    double maxTempC = tempC + 3.0;
    double minTempC = tempC - 5.0;
    int rainChance = 5;

    final List<HourlyForecast> parsedHourly = [];
    final List<DailyForecast> parsedDaily = [];
    final List<WeeklyForecastItem> parsedWeekly = [];
    final Map<int, CalendarDayForecast> parsedCalendar = {};

    if (forecastDays.isNotEmpty) {
      final todayForecast = forecastDays.first as Map<String, dynamic>? ?? {};
      final todayDay = todayForecast['day'] as Map<String, dynamic>? ?? {};

      maxTempC = _toDouble(todayDay['maxtemp_c']) ?? maxTempC;
      minTempC = _toDouble(todayDay['mintemp_c']) ?? minTempC;
      rainChance = _toInt(todayDay['daily_chance_of_rain']) ?? rainChance;

      // Parsing Hourly dari hari ini & hari berikutnya
      final hours = todayForecast['hour'] as List<dynamic>? ?? [];
      final currentHourInt = _parseHourFromLocaltime(localTimeRaw);

      for (var i = 0; i < hours.length; i++) {
        final h = hours[i] as Map<String, dynamic>? ?? {};
        final timeStr = h['time']?.toString() ?? '';
        final hourPart = _extractHourString(timeStr);
        final hourInt = int.tryParse(hourPart.split(':').first) ?? -1;
        final isCurrent = hourInt == currentHourInt;

        final hTemp = _toDouble(h['temp_c'])?.round() ?? 28;
        final hCond = h['condition'] as Map<String, dynamic>? ?? {};
        final hCode = _toInt(h['code']) ?? 1000;
        final hText = hCond['text']?.toString() ?? 'Clear';

        parsedHourly.add(
          HourlyForecast(
            time: isCurrent ? 'Sekarang' : hourPart,
            temperature: hTemp,
            conditionType: _mapConditionType(hCode, hText),
            isCurrent: isCurrent,
          ),
        );
      }

      // Parsing Daily Forecast
      for (var f in forecastDays) {
        final fMap = f as Map<String, dynamic>? ?? {};
        final fDateStr = fMap['date']?.toString() ?? '';
        final fDateTime = DateTime.tryParse(fDateStr) ?? DateTime.now();
        final fDay = fMap['day'] as Map<String, dynamic>? ?? {};
        final fCond = fDay['condition'] as Map<String, dynamic>? ?? {};
        final fCondText = fCond['text']?.toString() ?? 'Cerah';
        final fCondCode = _toInt(fCond['code']) ?? 1000;

        final fMax = _toDouble(fDay['maxtemp_c'])?.round() ?? 30;
        final fMin = _toDouble(fDay['mintemp_c'])?.round() ?? 22;
        final fAvgTemp = _toDouble(fDay['avgtemp_c'])?.round() ?? 26;
        final fRain = _toInt(fDay['daily_chance_of_rain']) ?? 0;
        final fHum = _toInt(fDay['avghumidity']) ?? 70;
        final fWind = _toDouble(fDay['maxwind_kph'])?.round() ?? 10;
        final fUv = _toDouble(fDay['uv'])?.round() ?? 5;

        final dayNameIndo = _getDayNameIndo(fDateTime.weekday);
        final dateFormattedIndo =
            '${fDateTime.day} ${_getMonthNameIndo(fDateTime.month)}';
        final conditionType = _mapConditionType(fCondCode, fCondText);

        parsedDaily.add(
          DailyForecast(
            day: dayNameIndo,
            date: dateFormattedIndo,
            conditionType: conditionType,
            maxTemp: fMax,
            minTemp: fMin,
            progress: 0.70,
          ),
        );

        parsedWeekly.add(
          WeeklyForecastItem(
            day: dayNameIndo,
            date: dateFormattedIndo,
            maxTemp: fMax,
            minTemp: fMin,
            conditionType: conditionType,
            precipitation: fRain,
            progress: ((fMax - fMin) / 15.0).clamp(0.35, 0.95),
          ),
        );

        parsedCalendar[fDateTime.day] = CalendarDayForecast(
          date: fDateTime,
          dayName: dayNameIndo,
          dateFormatted: dateFormattedIndo,
          condition: _translateCondition(fCondText),
          conditionType: conditionType,
          temperature: fAvgTemp,
          maxTemp: fMax,
          minTemp: fMin,
          rainChance: '$fRain%',
          humidity: '$fHum%',
          windSpeed: '$fWind km/j',
          uvIndex: _formatUvIndex(fUv),
        );
      }
    }

    return WeatherApiResponse(
      cityName: cityName,
      countryName: countryName,
      localTime: _formatDateTimeIndo(localTimeRaw),
      tempC: tempC,
      feelsLikeC: feelsLikeC,
      humidity: humidity,
      windKph: windKph,
      uvIndex: uvIndex,
      conditionText: translatedCondition,
      conditionCode: conditionCode,
      maxTempC: maxTempC,
      minTempC: minTempC,
      rainChance: rainChance,
      hourlyList: parsedHourly.isNotEmpty
          ? parsedHourly
          : HourlyForecast.mockList,
      dailyList: parsedDaily.isNotEmpty
          ? parsedDaily
          : DailyForecast.mockList,
      weeklyList: parsedWeekly.isNotEmpty
          ? parsedWeekly
          : WeeklyForecastItem.mockList,
      calendarForecastMap: parsedCalendar,
    );
  }

  /// Konversi ke model `CurrentWeather` untuk halaman Beranda
  CurrentWeather toCurrentWeather() {
    return CurrentWeather(
      location: '$cityName, $countryName',
      condition: conditionText,
      temperature: tempC.round(),
      dateTime: localTime.isNotEmpty ? localTime : 'Hari ini',
      maxTemp: maxTempC.round(),
      minTemp: minTempC.round(),
      feelsLike: feelsLikeC.round(),
      humidity: humidity,
      windSpeed: windKph.round(),
      rainChance: '$rainChance%',
      uvIndex: _formatUvIndex(uvIndex.round()),
    );
  }

  /// Konversi ke model `CityWeather` untuk halaman Lokasi
  CityWeather toCityWeather({bool isCurrentLocation = false, String? id}) {
    return CityWeather(
      id: id ?? cityName.toLowerCase().replaceAll(' ', '_'),
      cityName: cityName,
      country: countryName,
      temperature: tempC.round(),
      condition: conditionText,
      conditionType: _mapConditionType(conditionCode, conditionText),
      maxTemp: maxTempC.round(),
      minTemp: minTempC.round(),
      isCurrentLocation: isCurrentLocation,
      localTime: localTime.isNotEmpty ? 'Waktu lokal $localTime' : null,
    );
  }

  /// Factory untuk parsing respons JSON dari OpenWeatherMap (fallback multi-provider)
  factory WeatherApiResponse.fromOpenWeatherJson(
    Map<String, dynamic> currentJson,
    Map<String, dynamic>? forecastJson,
  ) {
    final cityName = currentJson['name']?.toString() ?? 'Malang';
    final sys = currentJson['sys'] as Map<String, dynamic>? ?? {};
    final countryCode = sys['country']?.toString() ?? 'ID';
    final countryName = countryCode == 'ID' ? 'Indonesia' : countryCode;

    final main = currentJson['main'] as Map<String, dynamic>? ?? {};
    final tempC = _toDouble(main['temp']) ?? 28.0;
    final feelsLikeC = _toDouble(main['feels_like']) ?? tempC;
    final humidity = _toInt(main['humidity']) ?? 70;
    final wind = currentJson['wind'] as Map<String, dynamic>? ?? {};
    final windSpeedMps = _toDouble(wind['speed']) ?? 3.0;
    final windKph = windSpeedMps * 3.6; // m/s ke km/h

    final weatherList = currentJson['weather'] as List<dynamic>? ?? [];
    final firstWeather = weatherList.isNotEmpty
        ? (weatherList.first as Map<String, dynamic>? ?? {})
        : {};
    final condMain = firstWeather['main']?.toString() ?? 'Clear';
    final condDesc = firstWeather['description']?.toString() ?? condMain;
    final condCode = _toInt(firstWeather['id']) ?? 800;
    final translatedCondition = _translateCondition(condDesc);

    double maxTempC = _toDouble(main['temp_max']) ?? (tempC + 2.0);
    double minTempC = _toDouble(main['temp_min']) ?? (tempC - 3.0);
    int rainChance = 10;

    final List<HourlyForecast> parsedHourly = [];
    final List<DailyForecast> parsedDaily = [];
    final List<WeeklyForecastItem> parsedWeekly = [];
    final Map<int, CalendarDayForecast> parsedCalendar = {};

    final forecastList = forecastJson?['list'] as List<dynamic>? ?? [];
    if (forecastList.isNotEmpty) {
      // Hourly Forecast (ambil 8 slot pertama = 24 jam)
      for (var i = 0; i < forecastList.length && i < 8; i++) {
        final item = forecastList[i] as Map<String, dynamic>? ?? {};
        final dtTxt = item['dt_txt']?.toString() ?? '';
        final hourPart = _extractHourString(dtTxt);
        final itemMain = item['main'] as Map<String, dynamic>? ?? {};
        final hTemp = _toDouble(itemMain['temp'])?.round() ?? 28;

        final itemWeather =
            (item['weather'] as List<dynamic>?)?.firstOrNull
                    as Map<String, dynamic>? ??
                {};
        final hCode = _toInt(itemWeather['id']) ?? 800;
        final hText = itemWeather['main']?.toString() ?? 'Clear';

        final isCurrent = i == 0;
        parsedHourly.add(
          HourlyForecast(
            time: isCurrent ? 'Sekarang' : hourPart,
            temperature: hTemp,
            conditionType: _mapConditionType(hCode, hText),
            isCurrent: isCurrent,
          ),
        );
      }

      // Kelompokkan per tanggal
      final Map<int, List<Map<String, dynamic>>> itemsByDay = {};
      for (var item in forecastList) {
        final itemMap = item as Map<String, dynamic>? ?? {};
        final dtTxt = itemMap['dt_txt']?.toString() ?? '';
        final dt = DateTime.tryParse(dtTxt);
        if (dt != null) {
          itemsByDay.putIfAbsent(dt.day, () => []).add(itemMap);
        }
      }

      itemsByDay.forEach((dayNum, dayItems) {
        double dayMax = -100;
        double dayMin = 100;
        int maxPop = 0;
        String dayCondText = 'Cerah';
        int dayCondCode = 800;
        DateTime dayDate = DateTime.now();

        for (var d in dayItems) {
          final dDt =
              DateTime.tryParse(d['dt_txt']?.toString() ?? '') ??
              DateTime.now();
          dayDate = dDt;
          final dMain = d['main'] as Map<String, dynamic>? ?? {};
          final tMax = _toDouble(dMain['temp_max']) ?? 28.0;
          final tMin = _toDouble(dMain['temp_min']) ?? 22.0;
          if (tMax > dayMax) dayMax = tMax;
          if (tMin < dayMin) dayMin = tMin;

          final pop = (_toDouble(d['pop']) ?? 0.0) * 100;
          if (pop.round() > maxPop) maxPop = pop.round();

          final dWeather =
              (d['weather'] as List<dynamic>?)?.firstOrNull
                  as Map<String, dynamic>? ??
              {};
          dayCondText =
              dWeather['description']?.toString() ??
              dWeather['main']?.toString() ??
              'Cerah';
          dayCondCode = _toInt(dWeather['id']) ?? 800;
        }

        final dName = _getDayNameIndo(dayDate.weekday);
        final dFormatted = '${dayDate.day} ${_getMonthNameIndo(dayDate.month)}';
        final cType = _mapConditionType(dayCondCode, dayCondText);

        parsedDaily.add(
          DailyForecast(
            day: dName,
            date: dFormatted,
            conditionType: cType,
            maxTemp: dayMax.round(),
            minTemp: dayMin.round(),
            progress: 0.70,
          ),
        );

        parsedWeekly.add(
          WeeklyForecastItem(
            day: dName,
            date: dFormatted,
            maxTemp: dayMax.round(),
            minTemp: dayMin.round(),
            conditionType: cType,
            precipitation: maxPop,
            progress: ((dayMax - dayMin) / 15.0).clamp(0.35, 0.95),
          ),
        );

        parsedCalendar[dayDate.day] = CalendarDayForecast(
          date: dayDate,
          dayName: dName,
          dateFormatted: dFormatted,
          condition: _translateCondition(dayCondText),
          conditionType: cType,
          temperature: ((dayMax + dayMin) / 2).round(),
          maxTemp: dayMax.round(),
          minTemp: dayMin.round(),
          rainChance: '$maxPop%',
          humidity: '$humidity%',
          windSpeed: '${windKph.round()} km/j',
          uvIndex: 'Sedang 5',
        );
      });
    }

    final now = DateTime.now();
    final nowStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return WeatherApiResponse(
      cityName: cityName,
      countryName: countryName,
      localTime: _formatDateTimeIndo(nowStr),
      tempC: tempC,
      feelsLikeC: feelsLikeC,
      humidity: humidity,
      windKph: windKph,
      uvIndex: 5.0,
      conditionText: translatedCondition,
      conditionCode: condCode,
      maxTempC: maxTempC,
      minTempC: minTempC,
      rainChance: rainChance,
      hourlyList:
          parsedHourly.isNotEmpty ? parsedHourly : HourlyForecast.mockList,
      dailyList: parsedDaily.isNotEmpty ? parsedDaily : DailyForecast.mockList,
      weeklyList:
          parsedWeekly.isNotEmpty ? parsedWeekly : WeeklyForecastItem.mockList,
      calendarForecastMap: parsedCalendar,
    );
  }

  // ========================================================
  // HELPER PARSING & PENERJEMAHAN
  // ========================================================

  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }

  static int? _toInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString());
  }

  static String _extractHourString(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      if (parts.length > 1) {
        return parts[1];
      }
    } catch (_) {}
    return timeStr;
  }

  static int _parseHourFromLocaltime(String localtime) {
    try {
      final parts = localtime.split(' ');
      if (parts.length > 1) {
        final timeParts = parts[1].split(':');
        return int.tryParse(timeParts[0]) ?? -1;
      }
    } catch (_) {}
    return -1;
  }

  static String _getDayNameIndo(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return 'Hari Ini';
    }
  }

  static String _getMonthNameIndo(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  static String _formatDateTimeIndo(String rawLocaltime) {
    try {
      // raw format: "2026-10-24 10:30"
      final parts = rawLocaltime.split(' ');
      if (parts.length >= 2) {
        final date = DateTime.tryParse(parts[0]);
        if (date != null) {
          final dayName = _getDayNameIndo(date.weekday);
          final monthName = _getMonthNameIndo(date.month);
          return '$dayName, ${date.day} $monthName • ${parts[1]} WIB';
        }
      }
    } catch (_) {}
    return rawLocaltime;
  }

  static String _formatUvIndex(int uv) {
    if (uv <= 2) return 'Rendah $uv';
    if (uv <= 5) return 'Sedang $uv';
    if (uv <= 7) return 'Tinggi $uv';
    if (uv <= 10) return 'Sangat Tinggi $uv';
    return 'Ekstrem $uv';
  }

  /// Menerjemahkan deskripsi kondisi dari bahasa Inggris WeatherAPI ke Bahasa Indonesia
  static String _translateCondition(String englishText) {
    final lower = englishText.toLowerCase();
    if (lower.contains('sunny') || lower.contains('clear')) {
      return 'Cerah';
    }
    if (lower.contains('partly cloudy')) {
      return 'Cerah Berawan';
    }
    if (lower.contains('overcast') || lower.contains('cloudy')) {
      return 'Mendung';
    }
    if (lower.contains('heavy rain') || lower.contains('torrential')) {
      return 'Hujan Lebat';
    }
    if (lower.contains('thunder') || lower.contains('storm')) {
      return 'Hujan Petir';
    }
    if (lower.contains('rain') || lower.contains('drizzle') || lower.contains('shower')) {
      return 'Hujan';
    }
    if (lower.contains('fog') || lower.contains('mist')) {
      return 'Berkabut';
    }
    return englishText;
  }

  /// Memetakan kondisi WeatherAPI ke enum UI `WeatherConditionType`
  static WeatherConditionType _mapConditionType(int code, String text) {
    final lower = text.toLowerCase();
    if (lower.contains('thunder') || lower.contains('storm') || lower.contains('rain') || lower.contains('drizzle') || lower.contains('shower')) {
      return WeatherConditionType.rainy;
    }
    if (lower.contains('cloudy') || lower.contains('overcast') || lower.contains('fog') || lower.contains('mist')) {
      return WeatherConditionType.cloudy;
    }
    if (lower.contains('partly')) {
      return WeatherConditionType.partlyCloudy;
    }
    return WeatherConditionType.sunny;
  }
}
