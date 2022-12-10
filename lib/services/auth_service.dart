import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fax/pages/Auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createAccount(
      String name, String email, String password) async {
    try {
      UserCredential userCrendetial =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      print("Account created Succesfull");

      //userCrendetial.user!.updateDisplayName(name);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name.trim(),
        "email": email.trim(),
        "status": "Unavalible",
        "uid": _auth.currentUser!.uid,
      });

      return userCrendetial.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      print("Login Sucessfull");

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
