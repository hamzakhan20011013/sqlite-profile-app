import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_profile_app/components/mytextfeild.dart';
import 'package:sqlite_profile_app/components/round_button.dart';
import 'package:sqlite_profile_app/json/users.dart';
import 'package:sqlite_profile_app/screens/profile_screen.dart';
import 'package:sqlite_profile_app/screens/signup.dart';
import 'package:sqlite_profile_app/sqlite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordvisibilty = true;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool islogintrue = false;

  final db = DatabaseHelper();

  login() async {
    Users? userDetails = await db.getUser(username.text);
    var res = await db
        .authenticate(Users(userName: username.text, password: password.text));
    if (res == true) {
      if (!mounted) return;
      username.clear();
      password.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    profile: userDetails,
                  )));
    } else {
      setState(() {
        islogintrue = true;

        Timer(Duration(seconds: 5), () {
          setState(() {
            islogintrue = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple),
                  ),
                  Image.asset("assets/background.jpg"),
                  SizedBox(
                    height: 15,
                  ),
                  MyTextFeild(
                    controller: username,
                    hinttext: "Username",
                    prefixicon: Icon(Icons.account_circle),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFeild(
                    controller: password,
                    hinttext: "Password",
                    obsecuretext: passwordvisibilty,
                    prefixicon: Icon(Icons.lock),
                    suffixicon: IconButton(
                      onPressed: () {
                        passwordvisibilty = !passwordvisibilty;
                        setState(() {});
                      },
                      icon: passwordvisibilty
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundButton(
                    onpressed: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      sp.setString('username', username.text);

                      login();
                    },
                    text: "Login",
                    width: double.maxFinite,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont Have an Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text("Signup"))
                    ],
                  ),
                  islogintrue
                      ? Text(
                          "Username or Password is incorrect",
                          style: TextStyle(color: Colors.red.shade300),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
