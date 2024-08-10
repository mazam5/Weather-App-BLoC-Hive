import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/domain/repositories/boxes.dart';
import 'package:weather_app/infrastructure/di/injection_container.dart';
import 'package:weather_app/infrastructure/local/weather_hive.dart';
import 'package:weather_app/infrastructure/services/weather_api_calls.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final Key formKey = GlobalKey<FormState>();
  TextEditingController searchCityController = TextEditingController();

  WeatherBloc() : super(const WeatherInitial()) {
    on<FetchWeatherByGeolocation>((event, emit) async {
      emit(const WeatherLoading());
      try {
        final weather = await sl<WeatherApiCalls>().fetchWeatherByGeolocation(
          event.position.latitude,
          event.position.longitude,
        );
        emit(WeatherSuccess(weather));
        await weatherBox.put('current', weather);
      } catch (e) {
        emit(const WeatherFailure('Failed to fetch weather by geolocation'));
      }
    });

    on<FetchWeatherByCityName>((event, emit) async {
      emit(const WeatherLoading());
      try {
        final weather = await sl<WeatherApiCalls>().fetchWeatherByCityName(
          event.cityName,
        );
        emit(WeatherSuccess(weather));
        await weatherBox.put('current', weather);
        searchCityController.clear();
      } catch (e) {
        emit(const WeatherFailure('Failed to fetch weather by city name'));
      }
    });

    on<FetchFromHive>((event, emit) {
      emit(const WeatherLoading());
      final weather = weatherBox.get('current');
      if (weather != null) {
        emit(WeatherSuccess(weather));
      } else {
        emit(const WeatherFailure('Failed to fetch weather from hive'));
      }
    });
  }
}
