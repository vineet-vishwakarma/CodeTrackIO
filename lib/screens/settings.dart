import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/screens/navbar.dart';
import 'package:codetrackio/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > 768
          ? CustomAppbar()
          : AppBar(
              title: Text('Settings'),
              centerTitle: true,
              toolbarHeight: 60,
              scrolledUnderElevation: 0,
            ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: CustomButton(
              title: 'Logout',
              onPressed: () {
                AuthController().logut();
                context.go('/');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          width < 768 ? const CustomBottomNavigationBar() : null,
    );
  }
}
