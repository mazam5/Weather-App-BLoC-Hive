import 'package:weather_app/infrastructure/local/weather_hive.dart';

WeatherHive getWeather(Map<String, dynamic> data) {
  return WeatherHive(
    country: data['sys']['country'] ?? '',
    description: data['weather'][0]['description'] ?? 'No description',
    icon: data['weather'][0]['icon'] ?? '',
    visibility: data['visibility'] ?? 0,
    name: data['name'] ?? 'Unknown location',
    timezone: data['timezone'],
    main: data['weather'][0]['main'] ?? 'Unknown',
    clouds: data['clouds']['all'] ?? 0,
    windDeg: data['wind']['deg'] ?? 0,
    grndLevel: data['main']['grnd_level'] ?? 0,
    seaLevel: data['main']['sea_level'] ?? 0,
    humidity: data['main']['humidity'] ?? 0,
    pressure: data['main']['pressure'] ?? 0,
    temp: (data['main']['temp'] ?? 0).toDouble(),
    feelsLike: (data['main']['feels_like'] ?? 0).toDouble(),
    tempMin: (data['main']['temp_min'] ?? 0).toDouble(),
    tempMax: (data['main']['temp_max'] ?? 0).toDouble(),
    windSpeed: (data['wind']['speed'] ?? 0).toDouble(),
    sunrise:
        DateTime.fromMillisecondsSinceEpoch((data['sys']['sunrise']) * 1000),
    sunset: DateTime.fromMillisecondsSinceEpoch((data['sys']['sunset']) * 1000),
    dt: DateTime.fromMillisecondsSinceEpoch((data['dt']) * 1000),
    lastUpdated: DateTime.now(),
  );
}
