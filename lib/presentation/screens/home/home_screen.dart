import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/application/blocs/internet/internet_cubit.dart';

import '../../../application/blocs/auth/auth_cubit.dart';
import '../../../application/blocs/weather/weather_bloc.dart';
import '../../../domain/services/location_service.dart';
import '../../routes/app_router.gr.dart';

@RoutePage()
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late InternetCubit internetCubit;

  @override
  void initState() {
    super.initState();
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    if (context.read<InternetCubit>().state.status ==
        ConnectionStatus.connected) {
      getWeatherAndLocation();
    } else {
      context.read<WeatherBloc>().add(const FetchFromHive());
    }
  }

  void getWeatherAndLocation() async {
    final weatherBloc = context.read<WeatherBloc>();
    final position = await determineLocation(context);
    weatherBloc.add(FetchWeatherByGeolocation(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        elevation: 1,
        actions: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLogout) {
                AutoRouter.of(context).replace(const SignInForm());
              }
            },
            child: BlocBuilder<InternetCubit, InternetStatus>(
              builder: (context, state) {
                if (state.status == ConnectionStatus.connected) {
                  return IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                AutoRouter.of(context).back();
                              },
                              child: const Text('No'),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                context.read<AuthCubit>().logout(context);
                              },
                              child: const Text('Yes'),
                            )
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherSuccess) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                '📍 ${state.weather.name}, ${state.weather.country}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text('UTC: ${state.weather.timezone / 3600} hrs'),
                            ],
                          ),
                          const Spacer(),
                          BlocBuilder<InternetCubit, InternetStatus>(
                            builder: (context, state) {
                              return state.status == ConnectionStatus.connected
                                  ? IconButton(
                                      onPressed: () {
                                        getWeatherAndLocation();
                                      },
                                      icon: const Icon(Icons.refresh),
                                    )
                                  : Container();
                            },
                          ),
                          BlocBuilder<InternetCubit, InternetStatus>(
                            builder: (context, state) {
                              return state.status == ConnectionStatus.connected
                                  ? FilledButton.icon(
                                      onPressed: () {
                                        AutoRouter.of(context)
                                            .push(const AddCity());
                                      },
                                      icon: const Icon(Icons.change_circle),
                                      label: const Text('Change'),
                                    )
                                  : Container();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          '🌡️${state.weather.temp.round()}°C',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 40),
                        ),
                      ),
                      Center(
                        child: Text(
                          state.weather.main,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 30),
                        ),
                      ),
                      Center(
                        child: Text(
                          state.weather.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 25),
                        ),
                      ),
                      Center(
                        child: Text(
                          DateFormat('H:mm, EEEE d-MMM')
                              .format(state.weather.dt),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Sunrise'),
                              Text(
                                  '🌅 ${DateFormat('H:mm').format(state.weather.sunrise)}'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Sunset'),
                              Text(
                                  '🌇 ${DateFormat('H:mm').format(state.weather.sunset)}'),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Wind'),
                              Text('🌬️ ${state.weather.windSpeed} km/h'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Humidity'),
                              Text('💧 ${state.weather.humidity}%'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('Pressure'),
                              Text('🧭 ${state.weather.pressure} hPa'),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Feels Like'),
                                Text(
                                    '🌡️ ${state.weather.feelsLike.round()}°C'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Min Temp'),
                                Text('🌡️ ${state.weather.tempMin.round()} °C'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Max Temp'),
                                Text('🌡️ ${state.weather.tempMax.round()}°C'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Visibility'),
                                Text('👁️ ${state.weather.visibility} m'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Cloudiness'),
                                Text('☁️ ${state.weather.clouds}%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Ground Level'),
                                Text('🌏 ${state.weather.grndLevel}hPa'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Sea Level'),
                                Text('🌊 ${state.weather.seaLevel}hPa'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Wind Speed'),
                                Text('🌬️ ${state.weather.windSpeed} km/h'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Wind Degree'),
                                Text('🧭 ${state.weather.windDeg}°'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Last updated: ${DateFormat('h:mm a, d-MMM').format(state.weather.lastUpdated)}',
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is WeatherLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Fetching weather data...'),
                  ],
                ),
              );
            } else if (state is WeatherFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Try entering a city name'),
                    TextButton(
                      onPressed: () {
                        getWeatherAndLocation();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
