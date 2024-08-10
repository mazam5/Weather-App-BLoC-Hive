import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/application/blocs/weather/weather_bloc.dart';
import 'package:weather_app/infrastructure/services/weather_api_calls.dart';
import 'package:weather_app/presentation/routes/app_router.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => WeatherApiCalls());
  sl.registerLazySingleton(() => AppRouter());
  sl.registerFactory(() => WeatherBloc());
  sl.registerLazySingleton(() => Connectivity());
}
