// import 'dart:convert';

import 'package:hive/hive.dart';

part 'my_weather.g.dart';

@HiveType(typeId: 0)
class MyWeather {
  @HiveField(0)
  final double temp;
  @HiveField(1)
  final double feelsLike;
  @HiveField(2)
  final double tempMin;
  @HiveField(3)
  final double tempMax;
  @HiveField(4)
  final double pressure;
  @HiveField(5)
  final double humidity;
  @HiveField(6)
  final double windSpeed;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final String icon;
  @HiveField(9)
  final String name;
  @HiveField(10)
  final String main;
  @HiveField(11)
  final double seaLevel;
  @HiveField(12)
  final double grndLevel;
  @HiveField(13)
  final DateTime sunrise;
  @HiveField(14)
  final DateTime sunset;
  @HiveField(15)
  final DateTime dt;

  MyWeather({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.name,
    required this.main,
    required this.seaLevel,
    required this.grndLevel,
    required this.sunrise,
    required this.sunset,
    required this.dt,
  });

  factory MyWeather.fromJson(Map<String, dynamic> json) {
    return MyWeather(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      name: json['name'],
      main: json['weather'][0]['main'],
      seaLevel: json['main']['sea_level'].toDouble(),
      grndLevel: json['main']['grnd_level'].toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
// {
//   "coord": {
//     "lon": -94.04,
//     "lat": 33.44
//   },
//   "weather": [
//     {
//       "id": 800,
//       "main": "Clear",
//       "description": "clear sky",
//       "icon": "01d"
//     }
//   ],
//   "base": "stations",
//   "main": {
//     "temp": 306.15,
//     "feels_like": 308.1,
//     "temp_min": 304.26,
//     "temp_max": 307.19,
//     "pressure": 1016,
//     "humidity": 45,
//     "sea_level": 1016,
//     "grnd_level": 1004
//   },
//   "visibility": 10000,
//   "wind": {
//     "speed": 3.09,
//     "deg": 10
//   },
//   "clouds": {
//     "all": 0
//   },
//   "dt": 1723227792,
//   "sys": {
//     "type": 2,
//     "id": 62880,
//     "country": "US",
//     "sunrise": 1723203286,
//     "sunset": 1723252110
//   },
//   "timezone": -18000,
//   "id": 4133367,
//   "name": "Texarkana",
//   "cod": 200
// }