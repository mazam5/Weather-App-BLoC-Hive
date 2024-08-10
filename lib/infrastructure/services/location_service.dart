import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/application/blocs/weather/weather_bloc.dart';

void _showErrorDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Oops!'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () =>
              {Navigator.of(context).pop(), Geolocator.openLocationSettings()},
          child: const Text('Open'),
        ),
      ],
    ),
  );
}

Future<Position> determineLocation(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  await Geolocator.requestPermission();
  if (!serviceEnabled) {
    _showErrorDialog(
        'Location services are disabled. Please enable them in settings.',
        context);
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showErrorDialog('Location permissions are denied', context);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    _showErrorDialog(
        'Location permissions are permanently denied, we cannot request permissions.',
        context);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  Position position = await Geolocator.getCurrentPosition();
  FetchWeatherByGeolocation(position);
  return position;
}
