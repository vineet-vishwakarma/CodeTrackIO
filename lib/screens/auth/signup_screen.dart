import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/utils/utils.dart';
import 'package:codetrackio/widgets/custom_button.dart';
import 'package:codetrackio/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _cPasswordController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _fullnameController = TextEditingController();

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void _signup() async {
  final auth = AuthController();
  final uniqueUsername = await _firestore
      .collection('usernames')
      .doc(_usernameController.text.trim())
      .get();
  if (!uniqueUsername.exists) {
    if (_passwordController.text == _cPasswordController.text) {
      if (_passwordController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty) {
        try {
          await auth.signUpWithEmailPassword(
              _emailController.text,
              _passwordController.text,
              _usernameController.text,
              _fullnameController.text);

          _firestore
              .collection('usernames')
              .doc(_usernameController.text.trim())
              .set({});

          _emailController.clear();
          _passwordController.clear();
          _usernameController.clear();
          _cPasswordController.clear();
          _fullnameController.clear();
        } catch (e) {
          toast(e.toString());
        }
      } else {
        toast('Fill All Fields!!');
      }
    } else {
      toast('Password Not Matched!');
    }
  } else {
    toast('Username Not Available');
  }
}

class SignupScreen extends StatelessWidget {
  final void Function()? onTap;
  const SignupScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 768) {
        return SignUpWeb(onTap: onTap);
      } else {
        return SignUpMobile(onTap: onTap);
      }
    });
  }
}

class SignUpWeb extends StatelessWidget {
  final void Function()? onTap;
  const SignUpWeb({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 50.0, horizontal: 60),
              child: Card(
                elevation: 1,
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
                      controller: _emailController,
                      labelText: 'Email',
                      icon: Icons.email,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    TextInputField(
                      width: width,
                      controller: _usernameController,
                      labelText: 'Username',
                      icon: Icons.person,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    TextInputField(
                      width: width,
                      controller: _fullnameController,
                      labelText: 'Full Name',
                      icon: Icons.abc,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    TextInputField(
                      isObscure: true,
                      width: width,
                      controller: _passwordController,
                      labelText: 'Password',
                      icon: Icons.remove_red_eye,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    TextInputField(
                      isObscure: true,
                      width: width,
                      controller: _cPasswordController,
                      labelText: 'Confirm Password',
                      icon: Icons.password,
                      vertical: 10,
                      horizontal: 30,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
                      child: CustomButton(
                        title: 'Sign Up',
                        onPressed: _signup,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an acoount ?'),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: onTap,
                            child: const Text('Log In'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Lottie.asset('assets/animations/userlaptop.json',
                width: 400, height: 400),
          ),
        ],
      ),
    );
  }
}

class SignUpMobile extends StatelessWidget {
  final void Function()? onTap;
  const SignUpMobile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
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
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email_outlined,
                vertical: 10,
                horizontal: 30,
              ),
              TextInputField(
                width: width,
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
                vertical: 10,
                horizontal: 30,
              ),
              TextInputField(
                width: width,
                controller: _fullnameController,
                labelText: 'Full Name',
                icon: Icons.abc,
                vertical: 10,
                horizontal: 30,
              ),
              TextInputField(
                isObscure: true,
                width: width,
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.remove_red_eye,
                vertical: 10,
                horizontal: 30,
              ),
              TextInputField(
                isObscure: true,
                width: width,
                controller: _cPasswordController,
                labelText: 'Confirm Password',
                icon: Icons.password,
                vertical: 10,
                horizontal: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
                child: CustomButton(
                  title: 'Sign Up',
                  onPressed: _signup,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an acoount ?'),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: onTap,
                      child: const Text('Log In'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
