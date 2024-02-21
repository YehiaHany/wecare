import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';


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
      margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['name'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Dosage: ',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['dose'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Times: ',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      medication['times'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Adjust the value to change the button's corner radius
                ),
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
              ),
              child: Column(
                children: [
                  Icon(Icons.alarm),
                  Text('Set'),
                  Text('Alarm'),
                ],
              ),
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
              body: Column(
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
                              Navigator.pushNamed(context, '/messenger', arguments: {});
                            },
                            icon: Icon(Icons.mail),
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.logout),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 380,
                    height: 470,
                    child: Card(
                        color: Colors.blue,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  'Medications',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  children: medications.map((medication) => medicationCardTemplate(medication)).toList(),)
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
