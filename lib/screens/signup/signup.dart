// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_switch/sliding_switch.dart';
import '../general/firebase_auth_services.dart';
import '../general/toast.dart';
import '../signin/signin.dart';
import 'additionalDocInfo.dart';

// ignore: use_key_in_widget_constructors
class SignUpPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _passwordVisible = false;
  bool _isDoctor = false;
  File? _image;
  String _selectedGender = 'Select Gender';
  bool isSigningUp = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/Heart2.png',
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                elevation: 40.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: 80,
                              height: 80,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: _image != null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 40,
                                        backgroundImage: FileImage(_image!),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                          ),
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.black,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon:
                                const Icon(Icons.person, color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 3.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 3.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon:
                                const Icon(Icons.phone, color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 3.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Row for Gender and Age
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Gender Dropdown

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: Colors.black, width: 3),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedGender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue!;
                                  });
                                },
                                items:
                                    ['Select Gender', 'Male', 'Female']
                                        .map<DropdownMenuItem<String>>(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),

                            // Spacer for better alignment
                            const SizedBox(width: 20),

                            // Age Text Field
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: 100,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: _ageController,
                                decoration: InputDecoration(
                                  labelText: 'Age',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  contentPadding: const EdgeInsets.only(
                                      left:
                                          35), // Adjust the top padding to center the label
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      width: 3.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(width: 3.0),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Colors.black,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 3.0,
                                color: Colors.black,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(width: 3.0),
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                        const SizedBox(height: 15),
                        SlidingSwitch(
                          value: _isDoctor,
                          width: MediaQuery.of(context).size.width - 78,
                          onChanged: (bool value) {
                            setState(() {
                              _isDoctor = !_isDoctor; // Toggle the value
                            });
                          },
                          height: 55,
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                          textOff: "Patient",
                          textOn: "Doctor",
                          colorOn: Colors.blue,
                          colorOff: Colors.blue,
                          background: const Color(0xffe4e5eb),
                          buttonColor: const Color(0xfff7f5f7),
                          inactiveColor: const Color(0xff636f7b),
                        ),

                        const SizedBox(height: 15),
                        isSigningUp
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isSigningUp = true;
                                  });
                                  String username = _usernameController.text;
                                  String email = _emailController.text;
                                  String password = _passwordController.text;
                                  String phoneNumber =
                                      _phoneNumberController.text;
                                  // ignore: unused_local_variable
                                  String imagePath =
                                      _image != null ? _image!.path : '';
                                  String gender = _selectedGender;
                                  int age =
                                      int.tryParse(_ageController.text) ?? 0;
                                  User? user;
                                  if (_image != null) {
                                    user =
                                        await _auth.signUpWithEmailAndPassword(
                                            email,
                                            password,
                                            username,
                                            phoneNumber,
                                            gender,
                                            age,
                                            _isDoctor,
                                            _image!);
                                  } else {
                                    user =
                                        await _auth.signUpWithEmailAndPassword(
                                            email,
                                            password,
                                            username,
                                            phoneNumber,
                                            gender,
                                            age,
                                            _isDoctor,
                                            null);
                                  }
                                  setState(() {
                                    isSigningUp = false;
                                  });
                                  if (user != null) {
                                    showToast(
                                        message:
                                            "User is successfully created");
                                    _isDoctor
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DoctorInfo(userId: user!.uid),
                                            ),
                                          )
                                        : Navigator.pushReplacementNamed(context, '/pateintAdditionalInfo', arguments: {
                                      'age': age,
                                      'email': email,
                                      'gender': gender,
                                      'username': username,
                                      'phonenumber': phoneNumber,
                                    });
                                  } else {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  minimumSize: const Size(200.0, 50.0),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to the sign-in page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    // ignore: prefer_const_constructors
                                    builder: (context) => SignInPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
