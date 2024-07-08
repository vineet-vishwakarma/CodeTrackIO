import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String username;

  const UserProfile({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Text('Welcome, $username!'),
      ),
    );
  }
}
