import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/utils/utils.dart';
import 'package:codetrackio/widgets/custom_button.dart';
import 'package:codetrackio/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatelessWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void login() async {
      final authController = AuthController();

      try {
        await authController.signInWithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        toast(e.toString());
      }
    }

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          width > 768
              ? Expanded(
                  child: Lottie.asset('assets/animations/userlaptop.json',
                      width: 400, height: 400),
                )
              : const SizedBox(height: 0, width: 0),
          Expanded(
            child: Padding(
              padding: width > 768
                  ? const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60)
                  : const EdgeInsets.all(0),
              child: Card(
                elevation: width > 768 ? 1 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Code', style: TextStyle(fontSize: 30)),
                        Text(
                          'Track',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextInputField(
                      width: width,
                      controller: emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    TextInputField(
                      isObscure: true,
                      width: width,
                      controller: passwordController,
                      labelText: 'Password',
                      icon: FontAwesomeIcons.eye,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30.0),
                      child: CustomButton(
                        title: 'Log In',
                        onPressed: login,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Text('Forgot Password ?'),
                          ),
                          InkWell(
                            onTap: onTap,
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
