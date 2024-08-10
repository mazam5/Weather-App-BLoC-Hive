import 'package:dio/dio.dart';
import 'package:weather_app/core/constants.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/infrastructure/local/weather_hive.dart';

class WeatherApiCalls {
  final Dio dio = Dio();

  Future<WeatherHive> fetchWeatherByGeolocation(double lat, double lon) async {
    try {
      final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'lat': lat,
            'lon': lon,
            'appId': openWeatherApiKey,
            'units': 'metric',
          });
      return getWeather(response.data);
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherHive> fetchWeatherByCityName(String cityName) async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'appId': openWeatherApiKey,
          'units': 'metric',
        },
      );
      return getWeather(response.data);
    } catch (e) {
      throw Exception('Failed to load weather data');
    }
  }
}
