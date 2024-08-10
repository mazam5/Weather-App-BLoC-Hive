import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/auth/auth_cubit.dart';
import 'package:weather_app/application/blocs/internet/internet_cubit.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';
import 'package:weather_app/presentation/widgets/my_textfield.dart';

@RoutePage()
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpForm> {
  late InternetCubit internetCubit;

  @override
  void initState() {
    super.initState();
    internetCubit = context.read<InternetCubit>();
    internetCubit.checkConnectivity();
    internetCubit.internetStatus.listen((event) {
      if (event.status == ConnectionStatus.disconnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 30),
            content: Text('No internet connection'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: BlocBuilder<InternetCubit, InternetStatus>(
                builder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    child: Form(
                      key: context.read<AuthCubit>().formKey,
                      child: state.status == ConnectionStatus.connected
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                myTextField(
                                  key: const ValueKey('email'),
                                  textInputAction: TextInputAction.next,
                                  controller:
                                      context.read<AuthCubit>().emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  labelText: 'Email',
                                  prefixIcon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                myTextField(
                                  key: const ValueKey('password'),
                                  textInputAction: TextInputAction.next,
                                  controller: context
                                      .read<AuthCubit>()
                                      .passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  labelText: 'Password',
                                  prefixIcon: Icons.lock,
                                  obscureText:
                                      context.read<AuthCubit>().passObscure1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  suffix: () {
                                    context
                                        .read<AuthCubit>()
                                        .togglePassVisibility(1);
                                  },
                                ),
                                const SizedBox(height: 10),
                                myTextField(
                                  key: const ValueKey('confirmPassword'),
                                  textInputAction: TextInputAction.done,
                                  controller: context
                                      .read<AuthCubit>()
                                      .confirmPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icons.lock,
                                  obscureText:
                                      context.read<AuthCubit>().passObscure2,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value !=
                                        context
                                            .read<AuthCubit>()
                                            .passwordController
                                            .text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  suffix: () {
                                    context
                                        .read<AuthCubit>()
                                        .togglePassVisibility(2);
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    onPressed: () {
                                      if (context
                                          .read<AuthCubit>()
                                          .formKey
                                          .currentState!
                                          .validate()) {
                                        context
                                            .read<AuthCubit>()
                                            .signup(context);
                                      }
                                    },
                                    child: state is AuthLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Sign Up'),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Already have an account?'),
                                    TextButton(
                                      onPressed: () {
                                        AutoRouter.of(context)
                                            .replace(const SignInForm());
                                      },
                                      child: const Text('Sign In'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('No internet connection'),
                                ElevatedButton(
                                  onPressed: () {
                                    internetCubit.checkConnectivity();
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
