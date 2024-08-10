import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/presentation/widgets/weather_card.dart';

import '../../application/blocs/auth/auth_cubit.dart';
import '../../application/blocs/internet/internet_cubit.dart';
import '../../application/blocs/weather/weather_bloc.dart';
import '../../infrastructure/services/location_service.dart';
import '../routes/app_router.gr.dart';

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
    // try {
    WeatherBloc weatherBloc = context.read<WeatherBloc>();
    Position position = await determineLocation(context);
    weatherBloc.add(FetchWeatherByGeolocation(position));
    // } catch (e) {
    //   print('Error: $e');
    // }
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherSuccess) {
                  return Column(
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
                          BlocBuilder<InternetCubit, InternetStatus>(
                            builder: (context, state) {
                              return state.status == ConnectionStatus.connected
                                  ? IconButton(
                                      onPressed: () {
                                        getWeatherAndLocation();
                                        // determineLocation(context);
                                      },
                                      icon: const Icon(Icons.refresh),
                                    )
                                  : Container();
                            },
                          ),
                          const Spacer(),
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.2),
                              blurRadius: 8.0,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(children: [
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
                        ]),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Wind Speed',
                            icon: Icons.speed,
                            value: state.weather.windSpeed.toString(),
                            unit: 'km/h',
                          ),
                          WeatherCard(
                            title: 'Wind Degree',
                            icon: Icons.directions,
                            value: state.weather.windDeg.toString(),
                            unit: '°',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Wind',
                            icon: Icons.wind_power,
                            value: state.weather.windDeg.toString(),
                            unit: 'km/h',
                          ),
                          WeatherCard(
                              title: 'Humidity',
                              icon: Icons.heat_pump,
                              value: state.weather.humidity.toString(),
                              unit: '%'),
                          WeatherCard(
                            title: 'Pressure',
                            icon: Icons.precision_manufacturing_sharp,
                            value: state.weather.pressure.toString(),
                            unit: 'hPa',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Feels Like',
                            icon: Icons.equalizer_rounded,
                            value: state.weather.feelsLike.round().toString(),
                            unit: '°C',
                          ),
                          WeatherCard(
                            title: 'Min Temp',
                            icon: Icons.minimize,
                            value: state.weather.tempMin.round().toString(),
                            unit: '°C',
                          ),
                          WeatherCard(
                            title: 'Max Temp',
                            icon: Icons.highlight,
                            value: state.weather.tempMax.round().toString(),
                            unit: '°C',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Visibility',
                            icon: Icons.visibility,
                            value: state.weather.visibility.toString(),
                            unit: 'm',
                          ),
                          WeatherCard(
                            title: 'Cloudiness',
                            icon: Icons.cloud,
                            value: state.weather.clouds.toString(),
                            unit: '%',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Ground Level',
                            icon: Icons.landscape,
                            value: state.weather.grndLevel.toString(),
                            unit: 'hPa',
                          ),
                          WeatherCard(
                            title: 'Sea Level',
                            icon: Icons.water,
                            value: state.weather.seaLevel.toString(),
                            unit: 'hPa',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherCard(
                            title: 'Sunrise',
                            icon: Icons.wb_sunny,
                            value: DateFormat('H:mm')
                                .format(state.weather.sunrise),
                            unit: '',
                          ),
                          WeatherCard(
                            title: 'Sunset',
                            icon: Icons.nightlight_round,
                            value:
                                DateFormat('H:mm').format(state.weather.sunset),
                            unit: '',
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Last updated: ${DateFormat('h:mm a, d-MMM').format(state.weather.lastUpdated)}',
                          ),
                        ],
                      ),
                    ],
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
                            context
                                .read<WeatherBloc>()
                                .add(const FetchWeatherByCityName('Mumbai'));
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
        ),
      ),
    );
  }
}
