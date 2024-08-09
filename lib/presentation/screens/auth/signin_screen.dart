import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/blocs/auth/auth_cubit.dart';
import 'package:weather_app/presentation/routes/app_router.gr.dart';

@RoutePage()
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: context.read<AuthCubit>().formKey,
                  child: Column(
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
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          key: const ValueKey('email'),
                          controller: context.read<AuthCubit>().emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          key: const ValueKey('password'),
                          controller:
                              context.read<AuthCubit>().passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_person_rounded),
                            labelText: 'Password',
                            border: InputBorder.none,
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
                              color: Colors.black,
                            ),
                          ),
                          obscureText: context.read<AuthCubit>().passObscure1,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
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
                              context.read<AuthCubit>().signin(context);
                            }
                          },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
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
