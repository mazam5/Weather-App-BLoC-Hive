import 'package:auto_route/auto_route.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoadingRoute.page),
        AutoRoute(page: SignInForm.page),
        AutoRoute(page: SignUpForm.page),
        AutoRoute(page: WeatherRoute.page),
        AutoRoute(page: AddCity.page),
      ];
}
