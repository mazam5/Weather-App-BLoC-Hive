import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/auth/auth_cubit.dart';
import 'package:weather_app/application/blocs/internet/internet_cubit.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';
import 'package:weather_app/presentation/widgets/my_textfield.dart';

@RoutePage()
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<SignInForm> {
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
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<InternetCubit, InternetStatus>(
                builder: (context, state) {
                  return Form(
                    key: context.read<AuthCubit>().formKey,
                    child: state.status == ConnectionStatus.connected
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
                              const SizedBox(height: 16),
                              myTextField(
                                  key: const ValueKey('password'),
                                  textInputAction: TextInputAction.done,
                                  controller: context
                                      .read<AuthCubit>()
                                      .passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  labelText: 'Password',
                                  prefixIcon: Icons.lock_person_rounded,
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
                                  }),
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
                                      context.read<AuthCubit>().signin(context);
                                    }
                                  },
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text('Sign In'),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an account?'),
                                  TextButton(
                                    onPressed: () {
                                      AutoRouter.of(context)
                                          .replace(const SignUpForm());
                                    },
                                    child: const Text('Register'),
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
