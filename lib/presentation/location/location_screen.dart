import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/weather/weather_bloc.dart';
import 'package:weather_app/core/constants.dart';
import 'package:weather_app/presentation/widgets/my_textfield.dart';

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
        title: const Text('Change City'),
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
                      key: context.read<WeatherBloc>().formKey,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: myTextField(
                              key: const Key('search'),
                              labelText: 'Search City',
                              prefixIcon: Icons.location_city_rounded,
                              controller: context
                                  .read<WeatherBloc>()
                                  .searchCityController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a city';
                                }
                                return null;
                              },
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () {
                              context.read<WeatherBloc>().add(
                                    FetchWeatherByCityName(
                                      context
                                          .read<WeatherBloc>()
                                          .searchCityController
                                          .text,
                                      // context,
                                    ),
                                  );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Search'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Popular Cities',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (var city in popularCities)
                          ChoiceChip(
                            label: SizedBox(
                              width: 80,
                              child: Text(
                                city,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: false,
                            onSelected: (value) {
                              AutoRouter.of(context).back();
                              // context.read<WeatherBloc>().selectedCity = city;
                              context.read<WeatherBloc>().add(
                                    FetchWeatherByCityName(
                                      city,
                                      // context,
                                    ),
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
