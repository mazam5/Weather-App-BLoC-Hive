import 'package:get_it/get_it.dart';
import 'package:weather_app/application/blocs/weather/weather_bloc.dart';
import 'package:weather_app/infrastructure/local/weather_hive.dart';
import 'package:weather_app/infrastructure/services/weather_api_calls.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // sl.registerLazySingleton<WeatherHive>(() => WeatherHive());
  sl.registerLazySingleton(() => WeatherApiCalls());
  sl.registerFactory(() => WeatherBloc(weatherApiCalls: sl()));
}
