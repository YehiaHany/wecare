import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

import '../home/home.dart';
import '../loading/loading.dart';


class PatientHome extends StatefulWidget {

  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {

  Map patient_info = {};
  List medications = [];
  FirebaseInterface F = new FirebaseInterface();
  String patientID = FirebaseAuth.instance.currentUser!.uid;

  Future<Map> getPatientInfo() async{
    patient_info = await F.getPatientInfo(patientID);
    medications = patient_info['meds'] ?? [] ;
    return patient_info;
  }

  Widget medicationCardTemplate(medication){

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['name'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      color: Colors.grey[600],
                      width: 200,
                      height: 1.5,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dosage',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['dose'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      color: Colors.grey[600],
                      width: 200,
                      height: 1.5,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Times',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['times'],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                Container(
                  width: 110,
                  height: 87,
                  child: ElevatedButton(
                    onPressed: () {
                      medication['alarm_set'] = !medication['alarm_set'];
                      patient_info['meds'] = medications;
                      F.updatePatientInfo(patient_info as Map<String, dynamic>, patientID);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Adjust the value to change the button's corner radius
                      ),
                      backgroundColor: medication['alarm_set'] ? Colors.red[400] : Colors.green[400],
                      foregroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.alarm),
                        Text(medication['alarm_set'] ? 'Remove' : 'Set'),
                        Text('Alarm'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 110,
                  height: 87,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Adjust the value to change the button's corner radius
                      ),
                      backgroundColor: Colors.blue[400],
                      foregroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        Text('View'),
                        Text('Pamphlet'),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map<dynamic, dynamic>>(
        future: getPatientInfo(),
        builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'We care',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        size: 30,
                      ),
                    ],
                  )
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/appointments');
                                },
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                  foregroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                                ),
                                child: Text('Appointmnets'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile', arguments: patientID);
                                },
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                                  foregroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                                ),
                                child: Text('Profile'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/p_messenger', arguments: {});
                                },
                                icon: Icon(Icons.mail),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: IconButton(
                                onPressed: () async {
                                  GoogleSignIn googleSignIn = GoogleSignIn();
                                  googleSignIn.disconnect();
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        LoadingPage(destinationPage: const Home()),
                                      ),
                                  );
                                },
                                icon: Icon(Icons.logout),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                               Text(
                                'Medications',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: medications.map((medication) => medicationCardTemplate(medication)).toList(),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
