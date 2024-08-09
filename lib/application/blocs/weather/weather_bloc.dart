import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/constants.dart';
import 'package:weather_app/domain/entities/my_weather.dart';
import 'package:weather_app/domain/repositories/boxes.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  TextEditingController searchCityController = TextEditingController();
  String selectedCity = '';
  final Dio dio = Dio();
  WeatherBloc() : super(const WeatherInitial()) {
    on<FetchWeatherByGeolocation>((event, emit) async {
      emit(const WeatherLoading());
      try {
        final response = await dio.get(
            'https://api.openweathermap.org/data/2.5/weather',
            queryParameters: {
              'lat': event.position.latitude,
              'lon': event.position.longitude,
              'appId': openWeatherApiKey,
              'units': 'metric',
            });
        final weather = MyWeather(
          temp: response.data['main']['temp'].toDouble(),
          feelsLike: response.data['main']['feels_like'].toDouble(),
          tempMin: response.data['main']['temp_min'].toDouble(),
          tempMax: response.data['main']['temp_max'].toDouble(),
          pressure: response.data['main']['pressure'].toDouble(),
          humidity: response.data['main']['humidity'].toDouble(),
          windSpeed: response.data['wind']['speed'].toDouble(),
          description: response.data['weather'][0]['description'],
          icon: response.data['weather'][0]['icon'],
          name: response.data['name'],
          main: response.data['weather'][0]['main'],
          seaLevel: response.data['main']['sea_level'].toDouble(),
          grndLevel: response.data['main']['grnd_level'].toDouble(),
          sunrise: DateTime.fromMillisecondsSinceEpoch(
              response.data['sys']['sunrise'] * 1000),
          sunset: DateTime.fromMillisecondsSinceEpoch(
              response.data['sys']['sunset'] * 1000),
          dt: DateTime.fromMillisecondsSinceEpoch(
            response.data['dt'] * 1000,
          ),
        );
        emit(WeatherSuccess(weather));
        weatherBox.put('current', weather);
      } catch (e) {
        print(e);
        emit(const WeatherFailure('Failed to fetch weather by geolocation'));
      }
    });

    on<FetchWeatherByCityName>((event, emit) async {
      try {
        emit(const WeatherLoading());
        AutoRouter.of(event.context).back();
        final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'q': event.cityName,
            'appId': openWeatherApiKey,
            'units': 'metric',
          },
        );
        final weather = MyWeather(
          temp: response.data['main']['temp'].toDouble(),
          feelsLike: response.data['main']['feels_like'].toDouble(),
          tempMin: response.data['main']['temp_min'].toDouble(),
          tempMax: response.data['main']['temp_max'].toDouble(),
          pressure: response.data['main']['pressure'].toDouble(),
          humidity: response.data['main']['humidity'].toDouble(),
          windSpeed: response.data['wind']['speed'].toDouble(),
          description: response.data['weather'][0]['description'],
          icon: response.data['weather'][0]['icon'],
          name: response.data['name'],
          main: response.data['weather'][0]['main'],
          seaLevel: response.data['main']['sea_level'].toDouble(),
          grndLevel: response.data['main']['grnd_level'].toDouble(),
          sunrise: DateTime.fromMillisecondsSinceEpoch(
              response.data['sys']['sunrise'] * 1000),
          sunset: DateTime.fromMillisecondsSinceEpoch(
              response.data['sys']['sunset'] * 1000),
          dt: DateTime.fromMillisecondsSinceEpoch(
            response.data['dt'] * 1000,
          ),
        );
        emit(WeatherSuccess(weather));
        weatherBox.put('weather', weather);
        searchCityController.clear();
        selectedCity = '';
      } catch (e) {
        emit(const WeatherFailure('Failed to fetch weather by city name'));
      }
    });
  }
}
