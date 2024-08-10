import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/constants.dart';
import 'package:weather_app/domain/entities/weather_model.dart';
import 'package:weather_app/domain/repositories/boxes.dart';
import 'package:weather_app/domain/value_objects/helper.dart';

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
        final weather = getWeather(response.data);
        emit(WeatherSuccess(weather));
        weatherBox.put('current', weather);
      } catch (e) {
        print('Error: $e');
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
        final weather = getWeather(response.data);
        emit(WeatherSuccess(weather));
        weatherBox.put('current', weather);
        searchCityController.clear();
        selectedCity = '';
      } catch (e) {
        emit(const WeatherFailure('Failed to fetch weather by city name'));
      }
    });
  }
}
