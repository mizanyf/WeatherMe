enum WeatherConditionType { sunny, partlyCloudy, cloudy, rainy }

class CurrentWeather {
  final String location;
  final String condition;
  final int temperature;
  final String dateTime;
  final int maxTemp;
  final int minTemp;
  final int feelsLike;
  final int humidity;
  final int windSpeed;

  const CurrentWeather({
    required this.location,
    required this.condition,
    required this.temperature,
    required this.dateTime,
    required this.maxTemp,
    required this.minTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  static const CurrentWeather mock = CurrentWeather(
    location: 'Malang, Indonesia',
    condition: 'Cerah Berawan',
    temperature: 28,
    dateTime: 'Kamis, 24 Okt • 10:30 WIB',
    maxTemp: 31,
    minTemp: 22,
    feelsLike: 30,
    humidity: 72,
    windSpeed: 12,
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
