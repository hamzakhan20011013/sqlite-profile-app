import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_profile_app/screens/profile_screen.dart';
import 'package:sqlite_profile_app/sqlite/database_helper.dart';

import '../json/users.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final db = DatabaseHelper();

  @override
  void initState() {
    islogin();
    super.initState();
  }

  void islogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? username = sp.getString('username') ?? "";
    // print('HI');
    // print(username);

    if (username.isEmpty || username.isNotEmpty) {
      // print("heelo 1");
      Users? userDetails = await db.getUser(username);
      if (userDetails != null) {
        print("hello");
        Timer(Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(profile: userDetails)),
          );
        });
      } else {
        Timer(Duration(seconds: 3), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  width: double.maxFinite,
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/background.jpg")),
              SizedBox(
                height: 10,
              ),
              Text(
                "Profile App",
                style: TextStyle(fontSize: 28, color: Colors.blue.shade500),
              )
            ],
          ),
        ));
  }
}
