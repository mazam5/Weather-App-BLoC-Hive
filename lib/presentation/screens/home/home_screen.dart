import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    super.initState();
    getWeatherAndLocation();
  }

  void getWeatherAndLocation() async {
    final weatherBloc = context.read<WeatherBloc>();
    final position = await determineLocation(context);
    weatherBloc.add(FetchWeatherByGeolocation(position));
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weather'),
          elevation: 1,
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLogout) {
                  AutoRouter.of(context).replace(const SignInForm());
                }
                return IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              authCubit.logout(context);
                            },
                            child: const Text('Yes'),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherSuccess) {
                return GestureDetector(
                  onVerticalDragDown: (details) {
                    // getWeatherAndLocation();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '📍 ${state.weather.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                getWeatherAndLocation();
                              },
                              icon: const Icon(Icons.refresh),
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: () {
                                AutoRouter.of(context).push(const AddCity());
                              },
                              icon: const Icon(Icons.change_circle),
                              label: const Text('Change'),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Today's Weather",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            '🌡️ ${state.weather.temp}°C',
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
                            DateFormat('h:mm a, EEEE d-MMM')
                                .format(state.weather.dt),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 25),
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
                                    '🌅 ${DateFormat('h:mm a').format(state.weather.sunrise)}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Sunset'),
                                Text(
                                    '🌇 ${DateFormat('h:mm a').format(state.weather.sunset)}'),
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
                        Row(children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Feels Like'),
                                Text('🌡️ ${state.weather.feelsLike}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Min Temp'),
                                Text('🌡️ ${state.weather.tempMin}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Max Temp'),
                                Text('🌡️ ${state.weather.tempMax}'),
                              ],
                            ),
                          ),
                        ]),
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
        ));
  }
}
