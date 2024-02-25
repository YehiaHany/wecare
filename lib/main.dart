// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/doctor/components/doctor_chat_page.dart';
import 'package:wecare/screens/doctor/view_patient_profile.dart';
import 'package:wecare/screens/home/home.dart';
import 'package:wecare/screens/doctor/mainPageDoc.dart';
import 'package:wecare/screens/loading/Loadingnormal.dart';
import 'package:wecare/screens/loading/loading.dart';
import 'package:wecare/screens/patient/appointments.dart';
import 'package:wecare/screens/patient/bookappointment.dart';
import 'package:wecare/screens/patient/patient_chat_page.dart';
import 'package:wecare/screens/patient/patient_messenger_page.dart';
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
  Future<Widget> checkUserRole(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot doctorSnapshot =
          await firestore.collection('doctors').doc(userId).get();
      DocumentSnapshot patientSnapshot =
          await firestore.collection('patients').doc(userId).get();

      if (doctorSnapshot.exists) {
        return MainDocPage(userId: userId);
      } else if (patientSnapshot.exists) {
        return PatientHome();
      } else {
        // The user is neither a doctor nor a patient
        print('User is not a doctor or patient');
        return Home(); // You can return a default page or handle it as needed
      }
    } catch (e) {
      print('Error checking user role: $e');
      return Home(); // Return a default page or handle errors as needed
    }
  }


  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("==============================User is signed out");
      } else {
        print("==============================User is currently signed in");
        checkUserRole(FirebaseAuth.instance.currentUser!.uid);
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
      // home: Home(),
      home: FirebaseAuth.instance.currentUser == null
          ? Home()
          : FutureBuilder(
        future: checkUserRole(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data as Widget;
          } else {
            return Loadingnormal();
          }
        },
      ),
      routes: {
        '/pateintAdditionalInfo': (context) => PatientAdditionalInfo(),
        '/patientHome': (context) => PatientHome(),
        '/profile': (context) => P_PatientProfile(),
        '/p_messenger': (context) => PatientMessengerPage(),
        '/p_chat': (context) => PatientChatPage(),
        '/d_chat': (context) => DoctorChatPage(),
        '/appointments': (context) => Appointments(),
        '/bookappointment': (context) => AppointmentPage(doctorId: ''),
        '/viewAppointments': (context) => ViewAppointments(),
        '/searchBySpeciality':(context) => DoctorSearchPage(),
      },
    );

  }
}
