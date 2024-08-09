import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/weather/weather_bloc.dart';
import 'package:weather_app/core/constants.dart';

@RoutePage()
class AddCity extends StatefulWidget {
  const AddCity({super.key});

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add City'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is WeatherFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Form(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: context
                                  .read<WeatherBloc>()
                                  .searchCityController,
                              decoration: const InputDecoration(
                                hintText: 'City Name',
                              ),
                              onChanged: (value) {
                                context
                                    .read<WeatherBloc>()
                                    .searchCityController
                                    .text = value;
                                print(value);
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<WeatherBloc>().add(
                                    FetchWeatherByCityName(
                                        context
                                            .read<WeatherBloc>()
                                            .searchCityController
                                            .text,
                                        context),
                                  );
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Popular Cities'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var city in popularCities)
                          ChoiceChip(
                            label: SizedBox(
                                width: 80,
                                child: Text(
                                  city,
                                  textAlign: TextAlign.center,
                                )),
                            selected: false,
                            onSelected: (value) {
                              context.read<WeatherBloc>().selectedCity = city;
                              context.read<WeatherBloc>().add(
                                    FetchWeatherByCityName(city, context),
                                  );
                            },
                          )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
