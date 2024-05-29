import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/screens/mobile/mobile_home_screen.dart';
import 'package:codetrackio/screens/web/web_home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController().getCurrentUser()!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            snapshot.data!['username'];
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 768) {
                  return MobileHomeScreen(snapshot: snapshot.data!);
                } else {
                  return WebHomeScreen(snapshot: snapshot.data!);
                }
              },
            );
          }
          return Center(child: Text(snapshot.error.toString()));
        },
      ),
    );
  }
}
