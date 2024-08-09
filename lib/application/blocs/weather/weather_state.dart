part of 'weather_bloc.dart';

@immutable
sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherSuccess extends WeatherState {
  final MyWeather weather;

  const WeatherSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherFailure extends WeatherState {
  final String message;

  const WeatherFailure(this.message);

  @override
  List<Object> get props => [message];
}
