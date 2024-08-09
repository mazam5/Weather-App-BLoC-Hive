// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:weather_app/presentation/screens/auth/signin_screen.dart'
    as _i3;
import 'package:weather_app/presentation/screens/auth/signup_screen.dart'
    as _i4;
import 'package:weather_app/presentation/screens/home/home_screen.dart' as _i5;
import 'package:weather_app/presentation/screens/location/location_screen.dart'
    as _i1;
import 'package:weather_app/presentation/screens/splash/splash_screen.dart'
    as _i2;

/// generated route for
/// [_i1.AddCity]
class AddCity extends _i6.PageRouteInfo<void> {
  const AddCity({List<_i6.PageRouteInfo>? children})
      : super(
          AddCity.name,
          initialChildren: children,
        );

  static const String name = 'AddCity';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddCity();
    },
  );
}

/// generated route for
/// [_i2.LoadingRoute]
class LoadingRoute extends _i6.PageRouteInfo<void> {
  const LoadingRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoadingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.LoadingRoute();
    },
  );
}

/// generated route for
/// [_i3.SignInForm]
class SignInForm extends _i6.PageRouteInfo<void> {
  const SignInForm({List<_i6.PageRouteInfo>? children})
      : super(
          SignInForm.name,
          initialChildren: children,
        );

  static const String name = 'SignInForm';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.SignInForm();
    },
  );
}

/// generated route for
/// [_i4.SignUpForm]
class SignUpForm extends _i6.PageRouteInfo<void> {
  const SignUpForm({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpForm.name,
          initialChildren: children,
        );

  static const String name = 'SignUpForm';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignUpForm();
    },
  );
}

/// generated route for
/// [_i5.WeatherScreen]
class WeatherRoute extends _i6.PageRouteInfo<void> {
  const WeatherRoute({List<_i6.PageRouteInfo>? children})
      : super(
          WeatherRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeatherRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.WeatherScreen();
    },
  );
}
