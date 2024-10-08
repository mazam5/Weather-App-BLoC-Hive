// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:weather_app/presentation/auth/loading.dart' as _i2;
import 'package:weather_app/presentation/auth/signin_screen.dart' as _i3;
import 'package:weather_app/presentation/auth/signup_screen.dart' as _i4;
import 'package:weather_app/presentation/home/home_screen.dart' as _i6;
import 'package:weather_app/presentation/location/location_screen.dart' as _i1;
import 'package:weather_app/presentation/splash/splash_screen.dart' as _i5;

/// generated route for
/// [_i1.AddCity]
class AddCity extends _i7.PageRouteInfo<void> {
  const AddCity({List<_i7.PageRouteInfo>? children})
      : super(
          AddCity.name,
          initialChildren: children,
        );

  static const String name = 'AddCity';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddCity();
    },
  );
}

/// generated route for
/// [_i2.LoadingRoute]
class LoadingRoute extends _i7.PageRouteInfo<void> {
  const LoadingRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoadingRoute();
    },
  );
}

/// generated route for
/// [_i3.SignInForm]
class SignInForm extends _i7.PageRouteInfo<void> {
  const SignInForm({List<_i7.PageRouteInfo>? children})
      : super(
          SignInForm.name,
          initialChildren: children,
        );

  static const String name = 'SignInForm';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.SignInForm();
    },
  );
}

/// generated route for
/// [_i4.SignUpForm]
class SignUpForm extends _i7.PageRouteInfo<void> {
  const SignUpForm({List<_i7.PageRouteInfo>? children})
      : super(
          SignUpForm.name,
          initialChildren: children,
        );

  static const String name = 'SignUpForm';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignUpForm();
    },
  );
}

/// generated route for
/// [_i5.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashScreen();
    },
  );
}

/// generated route for
/// [_i6.WeatherScreen]
class WeatherRoute extends _i7.PageRouteInfo<void> {
  const WeatherRoute({List<_i7.PageRouteInfo>? children})
      : super(
          WeatherRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeatherRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.WeatherScreen();
    },
  );
}
