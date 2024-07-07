import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetrackio/screens/auth/login_or_signup_screen.dart';
import 'package:codetrackio/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Login
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    }
  }

  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String username, String fullname) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // save user to database
      if (userCredential.user != null) {
        try {
          // save user to database
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
            'username': username,
            'leetcodeUsername': '',
            'gfgUsername': '',
            'languages': [],
            'gfgData': [],
            'leetcodeData': [],
            'submissionData': {},
            'fullname': fullname,
            'badges': [],
            'city': '',
            'college': '',
            'rank': -1,
            'platform': {
              'All': {'All': 0, 'Easy': 0, 'Medium': 0, 'Hard': 0},
              'Leetcode': {'All': 0, 'Easy': 0, 'Medium': 0, 'Hard': 0},
              'Gfg': {'All': 0, 'Easy': 0, 'Medium': 0, 'Hard': 0}
            },
          });
        } catch (e) {
          // handle the error
          print('Error saving user to database: $e');
        }
      } else {
        // handle the case where userCredential.user is null
        throw 'Failed to create user';
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw (e.code);
    }
  }

  // Logout
  Future<void> logut() async {
    return await _auth.signOut();
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: AuthController().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const LoginOrSignup();
        },
      ),
    );
  }
}
