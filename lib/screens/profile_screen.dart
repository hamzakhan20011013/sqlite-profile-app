import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_profile_app/components/round_button.dart';
import 'package:sqlite_profile_app/sqlite/database_helper.dart';
import '../json/users.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final Users? profile;
  const ProfileScreen({super.key, this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final db = DatabaseHelper();

  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  late String _originalDateOfBirth;
  late String _originalPhoneNumber;
  late String _originalAddress;

  bool _detailsEdited = false;

  @override
  void initState() {
    super.initState();

    _dateOfBirthController =
        TextEditingController(text: widget.profile?.dateOfBirth);
    _phoneNumberController =
        TextEditingController(text: widget.profile?.phoneNumber.toString());
    _addressController = TextEditingController(text: widget.profile?.address);

    _originalDateOfBirth = widget.profile?.dateOfBirth ?? "";
    _originalPhoneNumber = widget.profile?.phoneNumber ?? "";
    _originalAddress = widget.profile?.address ?? "";
    _image = null;
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    await db.updateUserProfile(widget.profile!.userName,
        dateOfBirth: _dateOfBirthController!.text,
        phoneNumber: int.tryParse(_phoneNumberController!.text) ?? 0,
        address: _addressController!.text,
        imagePath: _image != null ? _image!.path : null);
    setState(() {
      _detailsEdited = false;
    });
  }

  Future<void> _revertChanges() async {
    setState(() {
      _dateOfBirthController.text = _originalDateOfBirth;
      _phoneNumberController.text = _originalPhoneNumber.toString();
      _addressController.text = _originalAddress;
      _detailsEdited = false;
    });
  }

  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _detailsEdited = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController!.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
        _detailsEdited = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
          child: Column(
            children: [
              Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple, width: 2),
                      shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider<Object>
                        : widget.profile!.imagePath != null
                            ? FileImage(File(widget.profile!.imagePath!))
                                as ImageProvider<Object>
                            : AssetImage("assets/imagesuser.png"),
                    radius: 60,
                  ),
                ),
                Positioned(
                    top: 90,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(Icons.camera_alt)))
              ]),
              const SizedBox(height: 10),
              Text(
                widget.profile!.userName ?? "",
                style: const TextStyle(fontSize: 28, color: Colors.purple),
              ),
              Text(
                widget.profile!.email ?? "",
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
              SizedBox(
                height: 15,
              ),
              RoundButton(
                  width: double.maxFinite,
                  onpressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.clear();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  text: "Logout"),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                subtitle: Text(widget.profile!.fullName ?? ""),
                title: Text("Full name"),
              ),
              ListTile(
                title: Text("Date Of Birth"),
                leading: const Icon(Icons.date_range, size: 30),
                subtitle: Text(_dateOfBirthController!.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone, size: 30),
                title: const Text("Phone number"),
                subtitle: Text(_phoneNumberController.text),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Update Phone Number"),
                          content: TextField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Enter new phone number"),
                            onChanged: (value) {
                              setState(() {
                                _detailsEdited = true;
                              });
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, size: 30),
                subtitle: Text(_addressController.text),
                title: const Text("Address"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Update Address"),
                          content: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                                hintText: "Update Your Address"),
                            onChanged: (value) {
                              setState(() {
                                _detailsEdited = true;
                              });
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                subtitle: Text(widget.profile!.gender ?? ""),
                title: const Text("Gender"),
              ),
              _detailsEdited
                  ? RoundButton(
                      width: double.maxFinite,
                      onpressed: () async {
                        await _updateProfile();
                      },
                      text: "SAVE",
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              _detailsEdited
                  ? RoundButton(
                      width: double.maxFinite,
                      onpressed: () async {
                        await _revertChanges();
                      },
                      text: "Revert Changes",
                    )
                  : SizedBox(),
            ],
          ),
        )),
      ),
    );
  }
}
