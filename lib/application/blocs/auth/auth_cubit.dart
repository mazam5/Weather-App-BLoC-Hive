import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passObscure1 = true;
  bool passObscure2 = true;

  void signin(BuildContext context) async {
    emit(AuthLoading());
    try {
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await Hive.openBox('settings').then((loggedIn) {
        loggedIn.put('uid', userCredential.user!.uid);
      });
      emit(AuthSuccess(userCredential));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Logged In successfully'),
        ),
      );
      AutoRouter.of(context).replace(const WeatherRoute());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An error occurred'));
    }
    _clearControllers();
    emit(AuthInitial());
  }

  void signup(BuildContext context) async {
    emit(AuthLoading());
    formKey.currentState!.validate();
    try {
      emit(AuthLoading());
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await Hive.openBox('settings').then((loggedIn) {
        loggedIn.put('uid', userCredential.user!.uid);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Account created successfully'),
        ),
      );
      emit(AuthSuccess(userCredential));
      await AutoRouter.of(context).replace(const WeatherRoute());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'An error occurred'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred'),
        ),
      );
    }
    _clearControllers();
    emit(AuthInitial());
  }

  void logout(BuildContext context) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signOut();
      await Hive.openBox('settings').then((loggedIn) {
        loggedIn.delete('uid');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Logged out successfully'),
        ),
      );
      emit(AuthLogout());
      AutoRouter.of(context).replace(const SignInForm());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred'),
        ),
      );
      emit(AuthFailure(e.message ?? 'An error occurred'));
    }
    emit(AuthInitial());
  }

  void togglePassVisibility(int index) {
    if (index == 1) {
      passObscure1 = !passObscure1;
    } else {
      passObscure2 = !passObscure2;
    }
    emit(AuthInitial());
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    formKey.currentState!.reset();
  }
}
