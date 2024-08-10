part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

// Event for fetching weather by geolocation
class FetchWeatherByGeolocation extends WeatherEvent {
  final Position position;
  const FetchWeatherByGeolocation(this.position);

  @override
  List<Object> get props => [position];
}

// Event for fetching weather by city name
class FetchWeatherByCityName extends WeatherEvent {
  final String cityName;
  // final BuildContext context;

  const FetchWeatherByCityName(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class FetchFromHive extends WeatherEvent {
  const FetchFromHive();
}
