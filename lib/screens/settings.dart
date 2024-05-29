import 'package:codetrackio/screens/navbar.dart';
import 'package:flutter/material.dart';

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
      body: Center(child: Text('Settings')),
      bottomNavigationBar:
          width < 768 ? const CustomBottomNavigationBar() : null,
    );
  }
}
