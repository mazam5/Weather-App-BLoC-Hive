// package imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

// local imports
import 'application/blocs/auth/auth_cubit.dart';
import 'application/blocs/internet/internet_cubit.dart';
import 'application/blocs/weather/weather_bloc.dart';
import 'core/firebase_options.dart';
import 'domain/repositories/boxes.dart';
import 'infrastructure/local/weather_hive.dart';
import 'presentation/routes/app_router.dart';
import 'infrastructure/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherHiveAdapter());
  weatherBox = await Hive.openBox<WeatherHive>('weather');
  settingsBox = await Hive.openBox('settings');

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(weatherApiCalls: di.sl()),
        ),
        BlocProvider<InternetCubit>(create: (context) => InternetCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
