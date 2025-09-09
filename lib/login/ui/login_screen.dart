import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../account/ui/account_screen.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../services/login_api_services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final formKey = GlobalKey<FormState>();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginBloc(LoginApiService()),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/netflix_login4.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginErrorState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                } else if (state is LoginSuccessState) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Login Successful!')));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.2),
                        Image.asset("assets/images/n_logo.png", height: 130),
                        SizedBox(height: 40),
                        LoginTextField(
                          hintText: "netflix@gmail.com",
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        LoginTextField(
                          hintText: "Password",
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is LoginLoadingState
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                        LoginButtonPressed(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: state is LoginLoadingState
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (context) {},
                              checkColor: Colors.white,
                              activeColor: Colors.red,
                            ),
                            Text(
                              "Save Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Forget your Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 94),
                        RichText(
                          text: TextSpan(
                            text: "New to Netflix? ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign up now.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  LoginTextField({
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
