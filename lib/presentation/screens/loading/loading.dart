import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

@RoutePage()
class LoadingRoute extends StatelessWidget {
  const LoadingRoute({super.key});

  Future<void> _checkAuth(BuildContext context) async {
    final box = await Hive.openBox('settings');
    final uid = box.get('uid');

    if (uid == null) {
      context.router.replace(const SignInForm());
    } else {
      context.router.replace(const WeatherRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkAuth(context),
        builder: (context, snapshot) {
          return Scaffold(
            body: Center(
              child: Container(),
            ),
          );
        });
  }
}
