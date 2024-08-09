part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthLoading extends AuthState {
  AuthLoading();
}

final class AuthSuccess extends AuthState {
  final UserCredential userCredential;

  AuthSuccess(this.userCredential);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class AuthLogout extends AuthState {
  AuthLogout();
}
