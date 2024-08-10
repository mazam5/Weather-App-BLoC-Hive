import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel {
  @HiveField(0)
  final String main;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final double temp;

  @HiveField(4)
  final double feelsLike;

  @HiveField(5)
  final double tempMin;

  @HiveField(6)
  final double tempMax;

  @HiveField(7)
  final int pressure;

  @HiveField(8)
  final int humidity;

  @HiveField(9)
  final int seaLevel;

  @HiveField(10)
  final int grndLevel;

  @HiveField(11)
  final int visibility;

  @HiveField(12)
  final double windSpeed;

  @HiveField(13)
  final int windDeg;

  @HiveField(14)
  final int clouds;

  @HiveField(15)
  final DateTime dt;

  @HiveField(16)
  final DateTime sunrise;

  @HiveField(17)
  final DateTime sunset;

  @HiveField(18)
  final String country;

  @HiveField(19)
  final String name;

  @HiveField(20)
  final int timezone;

  WeatherModel({
    required this.name,
    required this.country,
    required this.main,
    required this.description,
    required this.icon,
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.clouds,
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.seaLevel,
    required this.grndLevel,
    required this.timezone,
  });
}
