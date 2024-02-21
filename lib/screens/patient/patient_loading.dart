import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';
class PatientLoading extends StatefulWidget {
  const PatientLoading({super.key});

  @override
  State<PatientLoading> createState() => _PatientLoadingState();
}

class _PatientLoadingState extends State<PatientLoading> {

  FirebaseInterface F = new FirebaseInterface();

  void getPatientInfo() async{

    Map patient_info = await F.getPatientInfo('26q6nWwawl2tIxk12Zi1');

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'age': patient_info['age'],
      'email': patient_info['email'],
      'gender': patient_info['gender'],
      'first_name': patient_info['first_name'],
      'last_name': patient_info['last_name'],
      'phone_number': patient_info['phone_number'],
      'medical_history': patient_info['medical_history'],
      'meds': patient_info['meds'],
    });
  }

  @override
  void initState() {
    super.initState();
    getPatientInfo();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          SizedBox(height: 200.0,),
          Text(
            'Retrieving',
            style: TextStyle(
              fontSize: 27.0,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),Text(
            'Patient Data',
            style: TextStyle(
              fontSize: 27.0,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 150.0,),
          Center(
            child: SpinKitFoldingCube(
              color: Colors.white,
              size: 80.0,
            )
          ),
        ],
        ),
      );
  }
}
