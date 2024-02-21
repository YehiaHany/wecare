// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:wecare/screens/loading/loading.dart';
import 'package:wecare/screens/doctor/mainPageDoc.dart';
import '../general/firebase_auth_services.dart';
import '../general/toast.dart';
import '../signup/signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isDoctor = false;
  bool isSigningIn = false;

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
                      'Sign In',
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
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 30),
                        isSigningIn
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isSigningIn = true;
                                  });
                                  String email = _emailController.text;
                                  String password = _passwordController.text;

                                  // Add your authentication logic here
                                  try {
                                    User? user =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    setState(() {
                                      isSigningIn = false;
                                    });
                                    if (user != null) {
                                      showToast(
                                          message:
                                              "User is successfully signed in");
                                      _isDoctor
                                          ? Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoadingPage(
                                                  destinationPage: MainDocPage(
                                                      userId: user.uid),
                                                ),
                                              ),
                                            )
                                          : Navigator.pushReplacementNamed(
                                        context, '/patientHome'
                                      );
                                    } else {}
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print(e);
                                  }
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
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to the sign-up page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15), // Add some spacing
                        const Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Or continue with',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // ignore: no_leading_underscores_for_local_identifiers
                            final GoogleSignIn _googleSignIn = GoogleSignIn();

                            try {
                              final GoogleSignInAccount? googleSignInAccount =
                                  await _googleSignIn.signIn();

                              if (googleSignInAccount != null) {
                                final GoogleSignInAuthentication
                                    googleSignInAuthentication =
                                    await googleSignInAccount.authentication;

                                final AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  idToken: googleSignInAuthentication.idToken,
                                  accessToken:
                                      googleSignInAuthentication.accessToken,
                                );

                                await _firebaseAuth
                                    .signInWithCredential(credential);
                                // Navigator.pushNamed(context, "/home");
                              }
                            } catch (e) {
                              showToast(message: "$e");
                            }
                          },
                          icon: const Icon(FontAwesomeIcons.google),
                          label: const Text('Sign In with Google'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
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
