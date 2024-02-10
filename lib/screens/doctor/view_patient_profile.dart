// 'workingPlaces': _workingPlaceControllers
//             .map((controller) => controller.text)
//             .toList(),

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CollectionReference patients =
    FirebaseFirestore.instance.collection('patients');

class PatientProfile extends StatelessWidget {
  final String patient;
  const PatientProfile({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: patients.doc(patient).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.background,
                title: Text("name: ${data['username']}"),
              ),
              body: Text("name: ${data['username']}"));
        }

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(50),
            child: SpinKitCubeGrid(
              color: Colors.blue[900],
              duration: const Duration(seconds: 2),
            ),
          ),
        );
      },
    );
  }
}
