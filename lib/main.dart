import 'package:fax/pages/Auth/Authenticate.dart';
import 'package:fax/pages/home.dart';
import 'package:fax/pages/profil.dart';
import 'package:fax/pages/Auth/register.dart';
import 'package:fax/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          //primarySwatch: Colors.blue,
          primaryColor: const Color(0xff150F50),
        ),
        debugShowCheckedModeBanner: false,
        home:
            AuthenticatePage() //const ProfilePage(email: 'email', userName: 'userName'),
        );
  }
}
