import 'package:codetrackio/controllers/app_router.dart';
import 'package:codetrackio/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size.width;
    return MaterialApp.router(
      title: 'CodeTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      // home: const AuthGate(),
      routerConfig: AppRouter().route,
    );
  }
}
