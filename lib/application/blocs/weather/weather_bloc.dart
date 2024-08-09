import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/core/constants.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  TextEditingController searchCityController = TextEditingController();
  String selectedCity = '';
  final Dio dio = Dio();
  final Box weatherBox = Hive.box<Weather>('weather');
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
            });
        final weather = Weather(response.data);
        weatherBox.put('weather', weather);
        emit(WeatherSuccess(weather));
      } catch (e) {
        print(e);
        emit(const WeatherFailure('Failed to fetch weather by geolocation'));
      }
    });

    // Handling the event to fetch weather by city name
    on<FetchWeatherByCityName>((event, emit) async {
      try {
        emit(const WeatherLoading());
        AutoRouter.of(event.context).back();
        final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather',
          queryParameters: {
            'q': event.cityName,
            'appId': openWeatherApiKey,
          },
        );
        final weatherData = response.data;
        print(weatherData);
        final weather = Weather(weatherData);
        emit(WeatherSuccess(weather));
        searchCityController.clear();
        selectedCity = '';
      } catch (e) {
        emit(const WeatherFailure('Failed to fetch weather by city name'));
      }
    });
  }
}
// https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appId=dbbfd2a8203a8f1f0a2fb761955a35a4