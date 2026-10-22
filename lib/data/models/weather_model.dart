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

        final now = DateTime.now();
        final bool isToday =
            fDateTime.day == now.day && fDateTime.month == now.month;

        parsedCalendar[fDateTime.day] = CalendarDayForecast(
          date: fDateTime,
          dayName: dayNameIndo,
          dateFormatted: dateFormattedIndo,
          condition: isToday ? translatedCondition : _translateCondition(fCondText),
          conditionType: isToday
              ? _mapConditionType(conditionCode, conditionRawText)
              : conditionType,
          temperature: isToday ? tempC.round() : fAvgTemp,
          maxTemp: isToday ? maxTempC.round() : fMax,
          minTemp: isToday ? minTempC.round() : fMin,
          rainChance: isToday ? '$rainChance%' : '$fRain%',
          humidity: isToday ? '$humidity%' : '$fHum%',
          windSpeed: isToday ? '${windKph.round()} km/j' : '$fWind km/j',
          uvIndex: isToday ? _formatUvIndex(uvIndex.round()) : _formatUvIndex(fUv),
        );
      }
    }

    final nowTime = DateTime.now();
    if (!parsedCalendar.containsKey(nowTime.day)) {
      parsedCalendar[nowTime.day] = CalendarDayForecast(
        date: nowTime,
        dayName: _getDayNameIndo(nowTime.weekday),
        dateFormatted: '${nowTime.day} ${_getMonthNameIndo(nowTime.month)}',
        condition: translatedCondition,
        conditionType: _mapConditionType(conditionCode, conditionRawText),
        temperature: tempC.round(),
        maxTemp: maxTempC.round(),
        minTemp: minTempC.round(),
        rainChance: '$rainChance%',
        humidity: '$humidity%',
        windSpeed: '${windKph.round()} km/j',
        uvIndex: _formatUvIndex(uvIndex.round()),
      );
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
      conditionType: _mapConditionType(conditionCode, conditionText),
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

      final now = DateTime.now();

      itemsByDay.forEach((dayNum, dayItems) {
        double dayMax = -100;
        double dayMin = 100;
        int maxPop = 0;
        String dayCondText = 'Cerah';
        int dayCondCode = 800;
        DateTime dayDate = DateTime.now();

        Map<String, dynamic>? representativeSlot;

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

          // Pilih slot siang (11:00 - 15:00) sebagai representasi cuaca harian yang akurat
          final hour = dDt.hour;
          if (representativeSlot == null || (hour >= 11 && hour <= 15)) {
            representativeSlot = d;
          }
        }

        final repWeather =
            (representativeSlot?['weather'] as List<dynamic>?)?.firstOrNull
                as Map<String, dynamic>? ??
            (dayItems.firstOrNull?['weather'] as List<dynamic>?)
                ?.firstOrNull as Map<String, dynamic>? ??
            {};
        dayCondText = repWeather['description']?.toString() ??
            repWeather['main']?.toString() ??
            'Cerah';
        dayCondCode = _toInt(repWeather['id']) ?? 800;

        // Jika ada probabilitas hujan tinggi pada hari tersebut, tampilkan cuaca hujan
        if (maxPop >= 50) {
          for (var d in dayItems) {
            final dMap = d as Map<String, dynamic>? ?? {};
            final wList = (dMap['weather'] as List<dynamic>?) ?? [];
            for (var w in wList) {
              final wMap = w as Map<String, dynamic>? ?? {};
              final wId = _toInt(wMap['id']) ?? 800;
              if (wId < 600) {
                dayCondCode = wId;
                dayCondText = wMap['description']?.toString() ??
                    wMap['main']?.toString() ??
                    dayCondText;
                break;
              }
            }
          }
        }

        final dName = _getDayNameIndo(dayDate.weekday);
        final dFormatted = '${dayDate.day} ${_getMonthNameIndo(dayDate.month)}';
        final cType = _mapConditionType(dayCondCode, dayCondText);

        final bool isToday =
            dayDate.day == now.day && dayDate.month == now.month;

        parsedDaily.add(
          DailyForecast(
            day: isToday ? 'Hari ini' : dName,
            date: dFormatted,
            conditionType: isToday ? _mapConditionType(condCode, condDesc) : cType,
            maxTemp: isToday ? maxTempC.round() : dayMax.round(),
            minTemp: isToday ? minTempC.round() : dayMin.round(),
            progress: 0.70,
          ),
        );

        parsedWeekly.add(
          WeeklyForecastItem(
            day: isToday ? 'Hari ini' : dName,
            date: dFormatted,
            maxTemp: isToday ? maxTempC.round() : dayMax.round(),
            minTemp: isToday ? minTempC.round() : dayMin.round(),
            conditionType: isToday ? _mapConditionType(condCode, condDesc) : cType,
            precipitation: isToday ? rainChance : maxPop,
            progress: ((dayMax - dayMin) / 15.0).clamp(0.35, 0.95),
          ),
        );

        parsedCalendar[dayDate.day] = CalendarDayForecast(
          date: dayDate,
          dayName: dName,
          dateFormatted: dFormatted,
          condition: isToday ? translatedCondition : _translateCondition(dayCondText),
          conditionType: isToday ? _mapConditionType(condCode, condDesc) : cType,
          temperature: isToday ? tempC.round() : ((dayMax + dayMin) / 2).round(),
          maxTemp: isToday ? maxTempC.round() : dayMax.round(),
          minTemp: isToday ? minTempC.round() : dayMin.round(),
          rainChance: isToday ? '$rainChance%' : '$maxPop%',
          humidity: isToday ? '$humidity%' : '$humidity%',
          windSpeed: '${windKph.round()} km/j',
          uvIndex: 'Sedang 5',
        );
      });

      // Pastikan entri untuk hari ini selalu ada di calendarForecastMap
      if (!parsedCalendar.containsKey(now.day)) {
        parsedCalendar[now.day] = CalendarDayForecast(
          date: now,
          dayName: _getDayNameIndo(now.weekday),
          dateFormatted: '${now.day} ${_getMonthNameIndo(now.month)}',
          condition: translatedCondition,
          conditionType: _mapConditionType(condCode, condDesc),
          temperature: tempC.round(),
          maxTemp: maxTempC.round(),
          minTemp: minTempC.round(),
          rainChance: '$rainChance%',
          humidity: '$humidity%',
          windSpeed: '${windKph.round()} km/j',
          uvIndex: 'Sedang 5',
        );
      }
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

  /// Menerjemahkan dan menstandarisasi deskripsi kondisi cuaca ke Bahasa Indonesia dengan kapitalisasi di awal kata
  static String _translateCondition(String rawText) {
    final clean = rawText.trim();
    if (clean.isEmpty) return 'Cerah';
    final lower = clean.toLowerCase();

    // 1. Kamus padanan langsung istilah WeatherAPI, OpenWeatherMap, & BMKG
    const exactMap = {
      // OpenWeatherMap Clouds
      'broken clouds': 'Berawan Tebal',
      'scattered clouds': 'Berawan Sebagian',
      'few clouds': 'Cerah Berawan',
      'overcast clouds': 'Mendung',
      'clear sky': 'Cerah',
      'sunny': 'Cerah',
      'clear': 'Cerah',
      'partly cloudy': 'Cerah Berawan',
      'cloudy': 'Berawan',
      'overcast': 'Mendung',

      // Rain & Drizzle
      'light rain': 'Hujan Ringan',
      'moderate rain': 'Hujan Sedang',
      'heavy rain': 'Hujan Lebat',
      'heavy intensity rain': 'Hujan Lebat',
      'very heavy rain': 'Hujan Sangat Lebat',
      'extreme rain': 'Hujan Ekstrem',
      'freezing rain': 'Hujan Es',
      'light intensity shower rain': 'Hujan Ringan',
      'shower rain': 'Hujan',
      'heavy intensity shower rain': 'Hujan Lebat',
      'ragged shower rain': 'Hujan Lebat',
      'light intensity drizzle': 'Gerimis Ringan',
      'drizzle': 'Gerimis',
      'heavy intensity drizzle': 'Gerimis Lebat',
      'light intensity drizzle rain': 'Gerimis Ringan',
      'drizzle rain': 'Hujan Gerimis',
      'heavy intensity drizzle rain': 'Hujan Gerimis Lebat',
      'shower rain and drizzle': 'Hujan Gerimis',
      'heavy shower rain and drizzle': 'Hujan Gerimis Lebat',
      'shower drizzle': 'Hujan Gerimis',

      // Thunderstorm
      'thunderstorm with light rain': 'Hujan Petir Ringan',
      'thunderstorm with rain': 'Hujan Petir',
      'thunderstorm with heavy rain': 'Hujan Petir Lebat',
      'light thunderstorm': 'Petir Ringan',
      'heavy thunderstorm': 'Badai Petir',
      'ragged thunderstorm': 'Badai Petir',
      'thunderstorm with light drizzle': 'Hujan Gerimis Petir',
      'thunderstorm with drizzle': 'Hujan Gerimis Petir',
      'thunderstorm with heavy drizzle': 'Hujan Gerimis Petir',
      'thunderstorm': 'Hujan Petir',

      // Atmosphere
      'mist': 'Berkabut',
      'smoke': 'Berasap',
      'haze': 'Kabut Asap',
      'sand/ dust whirls': 'Pusaran Debu',
      'fog': 'Kabut',
      'freezing fog': 'Kabut Beku',
      'sand': 'Berpasir',
      'dust': 'Berdebu',
      'volcanic ash': 'Abu Vulkanik',
      'squalls': 'Angin Kencang',
      'tornado': 'Tornado',

      // Snow
      'light snow': 'Salju Ringan',
      'snow': 'Salju',
      'heavy snow': 'Salju Lebat',
      'sleet': 'Hujan Salju',
      'blizzard': 'Badai Salju',

      // WeatherAPI specific
      'patchy rain possible': 'Kemungkinan Hujan Ringan',
      'patchy light drizzle': 'Gerimis Ringan',
      'patchy light rain': 'Hujan Ringan',
      'moderate rain at times': 'Hujan Sedang',
      'heavy rain at times': 'Hujan Lebat',
      'patchy light rain with thunder': 'Hujan Petir Ringan',
      'moderate or heavy rain with thunder': 'Hujan Petir',
      'light rain shower': 'Hujan Ringan',
      'moderate or heavy rain shower': 'Hujan',
      'torrential rain shower': 'Hujan Lebat',

      // Istilah terjemahan OpenWeather (lang=id)
      'awan pecah': 'Berawan Tebal',
      'awan tersebar': 'Berawan Sebagian',
      'beberapa awan': 'Cerah Berawan',
      'awan mendung': 'Mendung',
      'langit cerah': 'Cerah',
      'hujan ringan': 'Hujan Ringan',
      'hujan sedang': 'Hujan Sedang',
      'hujan lebat': 'Hujan Lebat',
      'hujan rintik-rintik': 'Gerimis',
      'gerimis': 'Gerimis',
      'badai petir': 'Hujan Petir',
      'kabut': 'Berkabut',
      'kabut asap': 'Kabut Asap',
      'cerah': 'Cerah',
      'berawan': 'Berawan',
      'mendung': 'Mendung',
    };

    if (exactMap.containsKey(lower)) {
      return exactMap[lower]!;
    }

    // 2. Fallback pencocokan kata kunci
    if (lower.contains('thunder') || lower.contains('petir') || lower.contains('storm')) {
      if (lower.contains('heavy') || lower.contains('lebat')) return 'Hujan Petir Lebat';
      return 'Hujan Petir';
    }
    if (lower.contains('heavy rain') || lower.contains('torrential') || lower.contains('lebat')) {
      return 'Hujan Lebat';
    }
    if (lower.contains('light rain') || lower.contains('drizzle') || lower.contains('gerimis') || lower.contains('patchy light rain')) {
      return 'Hujan Ringan';
    }
    if (lower.contains('rain') || lower.contains('shower') || lower.contains('hujan')) {
      return 'Hujan';
    }
    if (lower.contains('broken clouds')) {
      return 'Berawan Tebal';
    }
    if (lower.contains('scattered clouds')) {
      return 'Berawan Sebagian';
    }
    if (lower.contains('partly cloudy') || lower.contains('few clouds') || lower.contains('cerah berawan')) {
      return 'Cerah Berawan';
    }
    if (lower.contains('overcast') || lower.contains('mendung')) {
      return 'Mendung';
    }
    if (lower.contains('cloudy') || lower.contains('clouds') || lower.contains('berawan') || lower.contains('awan')) {
      return 'Berawan';
    }
    if (lower.contains('sunny') || lower.contains('clear') || lower.contains('cerah')) {
      return 'Cerah';
    }
    if (lower.contains('fog') || lower.contains('mist') || lower.contains('haze') || lower.contains('kabut')) {
      return 'Berkabut';
    }
    if (lower.contains('snow') || lower.contains('salju') || lower.contains('ice') || lower.contains('sleet')) {
      return 'Salju';
    }

    // 3. Fallback umum: Kapitalisasi awal setiap kata (Title Case)
    return clean.split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Public accessor untuk pemetaan conditionType
  static WeatherConditionType mapConditionType(int code, String text) =>
      _mapConditionType(code, text);

  /// Memetakan kondisi WeatherAPI / OpenWeatherMap ke enum UI `WeatherConditionType`
  static WeatherConditionType _mapConditionType(int code, String text) {
    final lower = text.toLowerCase();
    if (lower.contains('thunder') ||
        lower.contains('storm') ||
        lower.contains('rain') ||
        lower.contains('drizzle') ||
        lower.contains('shower') ||
        lower.contains('hujan') ||
        lower.contains('petir') ||
        lower.contains('gerimis')) {
      return WeatherConditionType.rainy;
    }
    if (code == 801 ||
        code == 802 ||
        code == 803 ||
        code == 1003 ||
        lower.contains('partly') ||
        lower.contains('few clouds') ||
        lower.contains('sebagian') ||
        lower.contains('scattered') ||
        lower.contains('cerah berawan')) {
      return WeatherConditionType.partlyCloudy;
    }
    if (code == 804 ||
        code == 1006 ||
        code == 1009 ||
        lower.contains('cloudy') ||
        lower.contains('clouds') ||
        lower.contains('overcast') ||
        lower.contains('fog') ||
        lower.contains('mist') ||
        lower.contains('berawan') ||
        lower.contains('mendung') ||
        lower.contains('kabut') ||
        lower.contains('tebal') ||
        lower.contains('awan')) {
      return WeatherConditionType.cloudy;
    }
    return WeatherConditionType.sunny;
  }
}
