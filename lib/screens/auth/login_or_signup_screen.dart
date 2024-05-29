import 'package:codetrackio/screens/auth/login_screen.dart';
import 'package:codetrackio/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool isLogin = true;

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginScreen(
        onTap: toggleScreen,
      );
    } else {
      return SignupScreen(
        onTap: toggleScreen,
      );
    }
  }
}
