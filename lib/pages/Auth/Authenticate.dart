import 'package:fax/pages/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home.dart';

class AuthenticatePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

   AuthenticatePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
