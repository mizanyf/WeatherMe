enum WeatherConditionType { sunny, partlyCloudy, cloudy, overcast, rainy }

class CurrentWeather {
  final String location;
  final String condition;
  final WeatherConditionType conditionType;
  final int temperature;
  final String dateTime;
  final int maxTemp;
  final int minTemp;
  final int feelsLike;
  final int humidity;
  final int windSpeed;
  final String? rainChance;
  final String? uvIndex;

  const CurrentWeather({
    required this.location,
    required this.condition,
    this.conditionType = WeatherConditionType.sunny,
    required this.temperature,
    required this.dateTime,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    this.rainChance = '5%',
    this.uvIndex = 'Sedang 5',
  });

  String get safeRainChance =>
      (rainChance != null && rainChance!.isNotEmpty) ? rainChance! : '5%';
  String get safeUvIndex =>
      (uvIndex != null && uvIndex!.isNotEmpty) ? uvIndex! : 'Sedang 5';

  CurrentWeather copyWith({
    String? location,
    String? condition,
    WeatherConditionType? conditionType,
    int? temperature,
    String? dateTime,
    int? maxTemp,
    int? minTemp,
    int? feelsLike,
    int? humidity,
    int? windSpeed,
    String? rainChance,
    String? uvIndex,
  }) {
    return CurrentWeather(
      location: location ?? this.location,
      condition: condition ?? this.condition,
      conditionType: conditionType ?? this.conditionType,
      temperature: temperature ?? this.temperature,
      dateTime: dateTime ?? this.dateTime,
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      rainChance: rainChance ?? this.rainChance,
      uvIndex: uvIndex ?? this.uvIndex,
    );
  }

  static const CurrentWeather mock = CurrentWeather(
    location: 'Malang, Indonesia',
    condition: 'Cerah Berawan',
    conditionType: WeatherConditionType.partlyCloudy,
    temperature: 28,
    dateTime: '10:30 WIB, Kamis, 24 Okt',
    maxTemp: 31,
    minTemp: 22,
    feelsLike: 30,
    humidity: 72,
    windSpeed: 12,
    rainChance: '5%',
    uvIndex: 'Sedang 5',
  );
}

class HourlyForecast {
  final String time;
  final int temperature;
  final WeatherConditionType conditionType;
  final bool isCurrent;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.conditionType,
    this.isCurrent = false,
  });

  static const List<HourlyForecast> mockList = [
    HourlyForecast(
      time: 'Sekarang',
      temperature: 28,
      conditionType: WeatherConditionType.partlyCloudy,
      isCurrent: true,
    ),
    HourlyForecast(
      time: '11:00',
      temperature: 29,
      conditionType: WeatherConditionType.sunny,
    ),
    HourlyForecast(
      time: '12:00',
      temperature: 31,
      conditionType: WeatherConditionType.sunny,
    ),
    HourlyForecast(
      time: '13:00',
      temperature: 30,
      conditionType: WeatherConditionType.partlyCloudy,
    ),
  ];
}

class DailyForecast {
  final String day;
  final String date;
  final int maxTemp;
  final int minTemp;
  final WeatherConditionType conditionType;
  final double progress; // between 0.0 and 1.0 for temperature bar

  const DailyForecast({
    required this.day,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionType,
    required this.progress,
  });

  static const List<DailyForecast> mockList = [
    DailyForecast(
      day: 'Jumat',
      date: '25 Okt',
      maxTemp: 29,
      minTemp: 22,
      conditionType: WeatherConditionType.sunny,
      progress: 0.75,
    ),
    DailyForecast(
      day: 'Sabtu',
      date: '26 Okt',
      maxTemp: 28,
      minTemp: 21,
      conditionType: WeatherConditionType.partlyCloudy,
      progress: 0.65,
    ),
    DailyForecast(
      day: 'Minggu',
      date: '27 Okt',
      maxTemp: 30,
      minTemp: 23,
      conditionType: WeatherConditionType.sunny,
      progress: 0.85,
    ),
  ];
}

/// Model for the Calendar Day forecast detail (Fokus Prakiraan)
class CalendarDayForecast {
  final DateTime date;
  final String dayName;
  final String dateFormatted;
  final String condition;
  final WeatherConditionType conditionType;
  final int temperature;
  final int maxTemp;
  final int minTemp;
  final String rainChance;
  final String humidity;
  final String windSpeed;
  final String uvIndex;

  const CalendarDayForecast({
    required this.date,
    required this.dayName,
    required this.dateFormatted,
    required this.condition,
    required this.conditionType,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
  });

  // Default initial mock for Wednesday, 21 October 2026
  static final CalendarDayForecast initial = CalendarDayForecast(
    date: DateTime(2026, 10, 21),
    dayName: 'Rabu',
    dateFormatted: '21 Oktober',
    condition: 'Cerah Berawan',
    conditionType: WeatherConditionType.partlyCloudy,
    temperature: 27,
    maxTemp: 29,
    minTemp: 21,
    rainChance: '5%',
    humidity: '63%',
    windSpeed: '10 km/j',
    uvIndex: 'Sedang 5',
  );

  /// Mock database of forecast data for October 2026
  static final Map<int, CalendarDayForecast> mockOctober = {
    21: CalendarDayForecast(
      date: DateTime(2026, 10, 21),
      dayName: 'Rabu',
      dateFormatted: '21 Oktober',
      condition: 'Cerah Berawan',
      conditionType: WeatherConditionType.partlyCloudy,
      temperature: 27,
      maxTemp: 29,
      minTemp: 21,
      rainChance: '5%',
      humidity: '63%',
      windSpeed: '10 km/j',
      uvIndex: 'Sedang 5',
    ),
    22: CalendarDayForecast(
      date: DateTime(2026, 10, 22),
      dayName: 'Kamis',
      dateFormatted: '22 Oktober',
      condition: 'Cerah',
      conditionType: WeatherConditionType.sunny,
      temperature: 30,
      maxTemp: 32,
      minTemp: 21,
      rainChance: '0%',
      humidity: '58%',
      windSpeed: '12 km/j',
      uvIndex: 'Tinggi 7',
    ),
    23: CalendarDayForecast(
      date: DateTime(2026, 10, 23),
      dayName: 'Jumat',
      dateFormatted: '23 Oktober',
      condition: 'Hujan Ringan',
      conditionType: WeatherConditionType.rainy,
      temperature: 25,
      maxTemp: 29,
      minTemp: 22,
      rainChance: '65%',
      humidity: '82%',
      windSpeed: '14 km/j',
      uvIndex: 'Rendah 3',
    ),
    24: CalendarDayForecast(
      date: DateTime(2026, 10, 24),
      dayName: 'Sabtu',
      dateFormatted: '24 Oktober',
      condition: 'Cerah Berawan',
      conditionType: WeatherConditionType.partlyCloudy,
      temperature: 28,
      maxTemp: 29,
      minTemp: 20,
      rainChance: '0%',
      humidity: '60%',
      windSpeed: '11 km/j',
      uvIndex: 'Sedang 6',
    ),
    25: CalendarDayForecast(
      date: DateTime(2026, 10, 25),
      dayName: 'Minggu',
      dateFormatted: '25 Oktober',
      condition: 'Cerah',
      conditionType: WeatherConditionType.sunny,
      temperature: 31,
      maxTemp: 31,
      minTemp: 22,
      rainChance: '10%',
      humidity: '65%',
      windSpeed: '9 km/j',
      uvIndex: 'Tinggi 8',
    ),
    26: CalendarDayForecast(
      date: DateTime(2026, 10, 26),
      dayName: 'Senin',
      dateFormatted: '26 Oktober',
      condition: 'Cerah Berawan',
      conditionType: WeatherConditionType.partlyCloudy,
      temperature: 28,
      maxTemp: 29,
      minTemp: 21,
      rainChance: '5%',
      humidity: '64%',
      windSpeed: '10 km/j',
      uvIndex: 'Sedang 5',
    ),
    27: CalendarDayForecast(
      date: DateTime(2026, 10, 27),
      dayName: 'Selasa',
      dateFormatted: '27 Oktober',
      condition: 'Cerah',
      conditionType: WeatherConditionType.sunny,
      temperature: 29,
      maxTemp: 30,
      minTemp: 20,
      rainChance: '0%',
      humidity: '59%',
      windSpeed: '11 km/j',
      uvIndex: 'Sedang 6',
    ),
  };
}

/// Item model for the 7-day forecast list (Prakiraan 7 Hari Mendatang)
class WeeklyForecastItem {
  final String day;
  final String date;
  final int maxTemp;
  final int minTemp;
  final WeatherConditionType conditionType;
  final int precipitation; // in percentage, e.g. 5 for 5%
  final double progress; // between 0.0 and 1.0 for temperature bar

  const WeeklyForecastItem({
    required this.day,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionType,
    required this.precipitation,
    required this.progress,
  });

  /// Sample mock entries matching user specification
  static const List<WeeklyForecastItem> mockList = [
    WeeklyForecastItem(
      day: 'Rabu',
      date: '21 Okt',
      maxTemp: 27,
      minTemp: 20,
      conditionType: WeatherConditionType.partlyCloudy,
      precipitation: 5,
      progress: 0.65,
    ),
    WeeklyForecastItem(
      day: 'Kamis',
      date: '22 Okt',
      maxTemp: 30,
      minTemp: 21,
      conditionType: WeatherConditionType.sunny,
      precipitation: 0,
      progress: 0.85,
    ),
    WeeklyForecastItem(
      day: 'Jumat',
      date: '23 Okt',
      maxTemp: 29,
      minTemp: 22,
      conditionType: WeatherConditionType.rainy,
      precipitation: 65,
      progress: 0.75,
    ),
    WeeklyForecastItem(
      day: 'Sabtu',
      date: '24 Okt',
      maxTemp: 28,
      minTemp: 20,
      conditionType: WeatherConditionType.sunny,
      precipitation: 0,
      progress: 0.70,
    ),
    WeeklyForecastItem(
      day: 'Minggu',
      date: '25 Okt',
      maxTemp: 31,
      minTemp: 22,
      conditionType: WeatherConditionType.partlyCloudy,
      precipitation: 10,
      progress: 0.90,
    ),
    WeeklyForecastItem(
      day: 'Senin',
      date: '26 Okt',
      maxTemp: 28,
      minTemp: 21,
      conditionType: WeatherConditionType.sunny,
      precipitation: 5,
      progress: 0.70,
    ),
    WeeklyForecastItem(
      day: 'Selasa',
      date: '27 Okt',
      maxTemp: 29,
      minTemp: 20,
      conditionType: WeatherConditionType.sunny,
      precipitation: 0,
      progress: 0.75,
    ),
  ];
}

/// Model for city weather information on the Locations screen
class CityWeather {
  final String id;
  final String cityName;
  final String country;
  final int temperature;
  final String condition;
  final WeatherConditionType conditionType;
  final int maxTemp;
  final int minTemp;
  final bool isFavorite;
  final bool isCurrentLocation;
  final String? localTime;

  const CityWeather({
    required this.id,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.conditionType,
    required this.maxTemp,
    required this.minTemp,
    this.isFavorite = false,
    this.isCurrentLocation = false,
    this.localTime,
  });

  String get displayName => '$cityName, $country';

  CityWeather copyWith({
    String? id,
    String? cityName,
    String? country,
    int? temperature,
    String? condition,
    WeatherConditionType? conditionType,
    int? maxTemp,
    int? minTemp,
    bool? isFavorite,
    bool? isCurrentLocation,
    String? localTime,
  }) {
    return CityWeather(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      conditionType: conditionType ?? this.conditionType,
      maxTemp: maxTemp ?? this.maxTemp,
      minTemp: minTemp ?? this.minTemp,
      isFavorite: isFavorite ?? this.isFavorite,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
      localTime: localTime ?? this.localTime,
    );
  }

  /// Current location mock for Malang, Indonesia
  static const CityWeather currentLocation = CityWeather(
    id: 'malang',
    cityName: 'Malang',
    country: 'Indonesia',
    temperature: 28,
    condition: 'Cerah Berawan',
    conditionType: WeatherConditionType.partlyCloudy,
    maxTemp: 30,
    minTemp: 21,
    isCurrentLocation: true,
    localTime: '10:30 WIB, Kamis, 24 Okt',
  );

  /// Sample initial saved cities from specification
  static const List<CityWeather> initialSavedCities = [
    CityWeather(
      id: 'jakarta',
      cityName: 'Jakarta',
      country: 'Indonesia',
      temperature: 32,
      condition: 'Cerah',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 33,
      minTemp: 24,
      isFavorite: true,
    ),
    CityWeather(
      id: 'tokyo',
      cityName: 'Tokyo',
      country: 'Jepang',
      temperature: 19,
      condition: 'Hujan Ringan',
      conditionType: WeatherConditionType.rainy,
      maxTemp: 21,
      minTemp: 14,
      isFavorite: true,
    ),
    CityWeather(
      id: 'london',
      cityName: 'London',
      country: 'Inggris',
      temperature: 14,
      condition: 'Mendung',
      conditionType: WeatherConditionType.overcast,
      maxTemp: 16,
      minTemp: 9,
      isFavorite: true,
    ),
    CityWeather(
      id: 'sydney',
      cityName: 'Sydney',
      country: 'Australia',
      temperature: 24,
      condition: 'Langit Cerah',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 26,
      minTemp: 17,
      isFavorite: true,
    ),
  ];

  /// Available cities pool for search & add
  static const List<CityWeather> availableCitiesPool = [
    CityWeather(
      id: 'paris',
      cityName: 'Paris',
      country: 'Prancis',
      temperature: 22,
      condition: 'Cerah Berawan',
      conditionType: WeatherConditionType.partlyCloudy,
      maxTemp: 23,
      minTemp: 15,
    ),
    CityWeather(
      id: 'newyork',
      cityName: 'New York',
      country: 'Amerika Serikat',
      temperature: 18,
      condition: 'Berawan',
      conditionType: WeatherConditionType.cloudy,
      maxTemp: 20,
      minTemp: 12,
    ),
    CityWeather(
      id: 'bali',
      cityName: 'Bali',
      country: 'Indonesia',
      temperature: 30,
      condition: 'Cerah Tropis',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 31,
      minTemp: 25,
    ),
    CityWeather(
      id: 'seoul',
      cityName: 'Seoul',
      country: 'Korea Selatan',
      temperature: 16,
      condition: 'Sejuk Cerah',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 18,
      minTemp: 10,
    ),
    CityWeather(
      id: 'singapore',
      cityName: 'Singapura',
      country: 'Singapura',
      temperature: 31,
      condition: 'Hujan Petir',
      conditionType: WeatherConditionType.rainy,
      maxTemp: 32,
      minTemp: 26,
    ),
    CityWeather(
      id: 'bangkok',
      cityName: 'Bangkok',
      country: 'Thailand',
      temperature: 33,
      condition: 'Cerah Hangat',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 35,
      minTemp: 27,
    ),
    CityWeather(
      id: 'berlin',
      cityName: 'Berlin',
      country: 'Jerman',
      temperature: 13,
      condition: 'Mendung',
      conditionType: WeatherConditionType.overcast,
      maxTemp: 15,
      minTemp: 8,
    ),
    CityWeather(
      id: 'kairo',
      cityName: 'Kairo',
      country: 'Mesir',
      temperature: 29,
      condition: 'Cerah Kering',
      conditionType: WeatherConditionType.sunny,
      maxTemp: 32,
      minTemp: 20,
    ),
  ];
}
