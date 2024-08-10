import 'package:weather_app/infrastructure/local/weather_hive.dart';

WeatherHive getWeather(Map<String, dynamic> data) {
  return WeatherHive(
    country: data['sys']['country'],
    description: data['weather'][0]['description'],
    icon: data['weather'][0]['icon'],
    visibility: data['visibility'],
    name: data['name'],
    timezone: data['timezone'],
    main: data['weather'][0]['main'],
    clouds: data['clouds']['all'],
    windDeg: data['wind']['deg'],
    grndLevel: data['main']['grnd_level'],
    seaLevel: data['main']['sea_level'],
    humidity: data['main']['humidity'],
    pressure: data['main']['pressure'],
    temp: (data['main']['temp']).toDouble(),
    feelsLike: (data['main']['feels_like']).toDouble(),
    tempMin: (data['main']['temp_min']).toDouble(),
    tempMax: (data['main']['temp_max']).toDouble(),
    windSpeed: (data['wind']['speed']).toDouble(),
    sunrise:
        DateTime.fromMillisecondsSinceEpoch((data['sys']['sunrise']) * 1000),
    sunset: DateTime.fromMillisecondsSinceEpoch((data['sys']['sunset']) * 1000),
    dt: DateTime.fromMillisecondsSinceEpoch((data['dt']) * 1000),
    lastUpdated: DateTime.now(),
  );
}
