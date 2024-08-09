import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/auth/auth_cubit.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

@RoutePage()
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: context.read<AuthCubit>().formKey,
                  child: Column(
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
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          key: const ValueKey('email'),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: context.read<AuthCubit>().emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_person_rounded),
                            suffix: IconButton(
                              onPressed: () {
                                context
                                    .read<AuthCubit>()
                                    .togglePassVisibility(1);
                              },
                              icon: Icon(
                                context.read<AuthCubit>().passObscure1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: context.read<AuthCubit>().passObscure1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          controller:
                              context.read<AuthCubit>().passwordController,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          key: const ValueKey('confirm_password'),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.lock_person_rounded),
                            suffix: IconButton(
                              onPressed: () {
                                context
                                    .read<AuthCubit>()
                                    .togglePassVisibility(2);
                              },
                              icon: Icon(
                                context.read<AuthCubit>().passObscure2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: context.read<AuthCubit>().passObscure2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value !=
                                context
                                    .read<AuthCubit>()
                                    .passwordController
                                    .text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          controller: context
                              .read<AuthCubit>()
                              .confirmPasswordController,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              context.read<AuthCubit>().signup(context);
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : const Text('Sign Up'),
                          ),
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
