// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/doctor/view_patient_profile.dart';
import 'package:wecare/screens/home/home.dart';
import 'package:wecare/screens/doctor/mainPageDoc.dart';
import 'package:wecare/screens/patient/appointments.dart';
import 'package:wecare/screens/patient/bookappointment.dart';
import 'package:wecare/screens/patient/chat_page.dart';
import 'package:wecare/screens/patient/messenger_page.dart';
import 'package:wecare/screens/patient/patient_additional_info.dart';
import 'package:wecare/screens/patient/patient_home.dart';
import 'package:wecare/screens/patient/patient_profile.dart';
import 'package:wecare/screens/patient/search.dart';
import 'package:wecare/screens/patient/viewAppointments.dart';
// import 'package:wecare/screens/doctor/doctorpage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("==============================User is signed out");
      } else {
        print("==============================User is currently signed in");
      }
    });
    super.initState();
  }
  // BLA BLA

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue[900]!)),
      home: Home(),
      // home: FirebaseAuth.instance.currentUser == null
      //     ? Home()
      //     : MainDocPage(userId: FirebaseAuth.instance.currentUser!.uid),
      routes: {
        '/pateintAdditionalInfo': (context) => PatientAdditionalInfo(),
        '/patientHome': (context) => PatientHome(),
        '/profile': (context) => P_PatientProfile(),
        '/messenger': (context) => MessengerPage(),
        '/chat': (context) => ChatPage(),
        '/appointments': (context) => Appointments(),
        '/bookappointment': (context) => AppointmentPage(doctorId: ''),
        '/viewAppointments': (context) => ViewAppointments(),
        '/searchBySpeciality':(context) => DoctorSearchPage(),
      },
    );

  }
}
