import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/domain/repositories/boxes.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

@RoutePage()
class LoadingRoute extends StatelessWidget {
  const LoadingRoute({super.key});

  Future<void> _checkAuth(BuildContext context) async {
    settingsBox = await Hive.openBox('settings');
    final uid = settingsBox.get('uid');

    if (uid == null) {
      context.router.replace(const SignInForm());
      print('No user found');
    } else {
      context.router.replace(const WeatherRoute());
      print('User found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkAuth(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Container(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
