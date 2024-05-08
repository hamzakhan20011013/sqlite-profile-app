import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite_profile_app/components/dropdown_button.dart';
import 'package:sqlite_profile_app/components/round_button.dart';
import 'package:sqlite_profile_app/json/users.dart';
import 'package:sqlite_profile_app/screens/login.dart';

import '../components/mytextfeild.dart';
import '../sqlite/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passwordvisibilty = true;
  bool confirmpasswordvisibilty = true;
  final TextEditingController fullName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  String dateOfBirth = "";
  final TextEditingController email = TextEditingController();
  final TextEditingController Phonenumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  String Gender = "Select Gender";
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateOfBirth = picked.toIso8601String().split('T')[0];
      });
    }
  }

  final db = DatabaseHelper();

  signup() async {
    var res = await db.createUser(Users(
        fullName: fullName.text,
        userName: username.text,
        password: password.text,
        dateOfBirth: dateOfBirth,
        phoneNumber: Phonenumber.text,
        email: email.text,
        address: address.text,
        gender: Gender));

    if (res > 0) {
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                Text(
                  "Register New Account",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFeild(
                  controller: fullName,
                  hinttext: "Full Name",
                  prefixicon: Icon(Icons.verified_user),
                ),
                SizedBox(
                  height: 10,
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
                  controller: email,
                  hinttext: "Email Address",
                  prefixicon: Icon(Icons.email),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFeild(
                  controller: Phonenumber,
                  hinttext: "Phone Number",
                  inputType: TextInputType.phone,
                  prefixicon: Icon(Icons.phone),
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextFeild(
                  controller: address,
                  hinttext: "Address",
                  prefixicon: Icon(Icons.location_on),
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
                  height: 10,
                ),
                MyTextFeild(
                  controller: confirmpassword,
                  hinttext: "Confirm Password",
                  obsecuretext: confirmpasswordvisibilty,
                  prefixicon: Icon(Icons.lock),
                  suffixicon: IconButton(
                    onPressed: () {
                      confirmpasswordvisibilty = !confirmpasswordvisibilty;
                      setState(() {});
                    },
                    icon: confirmpasswordvisibilty
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dateOfBirth.isEmpty
                              ? "Select Date of Birth"
                              : "$dateOfBirth",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.calendar_month)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: DropdownBtn(
                      text: Gender,
                      item: ["Male", "Female"],
                      onselected: (selecteValue) {
                        setState(() {
                          Gender = selecteValue ?? Gender;
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                RoundButton(
                  onpressed: () {
                    signup();
                  },
                  text: 'Signup',
                  width: double.maxFinite,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have An Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text("Login"))
                  ],
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
