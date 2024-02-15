import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:source_span/source_span.dart';

class PatientLoading extends StatefulWidget {
  const PatientLoading({super.key});

  @override
  State<PatientLoading> createState() => _PatientLoadingState();
}

class _PatientLoadingState extends State<PatientLoading> {

  void getPatientInfo() async{
    Map patient_info = await Future.delayed(Duration(seconds: 10), () {
      return {
        'age': 22,
        'email': "moneim@yahoo.com",
        'gender': 'male',
        'first_name': 'harry',
        'last_name': 'potter',
        'password': '123456',
        'phone_number': '0123456789',
        'medical_history': [
          {
            'symptoms': ['Fever', 'cough', 'fatigue'],
            'diagnosis': 'Influenza',
            'date': 'January 15, 2023',
          },
          {
            'symptoms': ['Headache', 'sore throat', 'muscle aches'],
            'diagnosis': 'Common cold',
            'date': 'March 5, 2023',
          },
          {
            'symptoms': ['Shortness of breath', 'chest pain', 'cough'],
            'diagnosis': 'Pneumonia',
            'date': 'April 20, 2023',
          },
        ]
      };
    });

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'age': patient_info['age'],
      'email': patient_info['email'],
      'gender': patient_info['gender'],
      'first_name': patient_info['first_name'],
      'last_name': patient_info['last_name'],
      'password': patient_info['password'],
      'phone_number': patient_info['phone_number'],
      'medical_history': patient_info['medical_history'],
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
