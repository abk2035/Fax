import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/pages/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (userCredential.user != null) {
        print("Login Sucessfull");
      } else {
        print("failled");
      }
      // _firestore
      //     .collection('users')
      //     .doc(_auth.currentUser!.uid)
      //     .get()
      //     .then((value) => userCredential.user!.updateDisplayName(value['name']));

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future logOut(BuildContext context) async {
    try {
      await _auth.signOut().then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      });
    } catch (e) {
      print("error");
    }
  }
}
