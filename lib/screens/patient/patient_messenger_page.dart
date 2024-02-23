import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class PatientMessengerPage extends StatefulWidget {
  const PatientMessengerPage({super.key});

  @override
  State<PatientMessengerPage> createState() => _PatientMessengerPageState();
}

class _PatientMessengerPageState extends State<PatientMessengerPage> {

  Map<dynamic, dynamic> contact = {};
  String patientID = FirebaseAuth.instance.currentUser!.uid;
  FirebaseInterface F = new FirebaseInterface();

  Future<Map> getContacts() async{
    contact = await F.getContactsForPatient(patientID);
    return contact;
  }

  Widget chatHead(Map contact){

    String message_header = '';
    if(contact['last_sender'] != ''){
      if(contact['last_sender'] == 'patient') {
        message_header = 'You: ';
      } else {
        message_header = 'Dr.${contact['doctor_name']}: ';
      }
    }

    return Card(
      color: Colors.grey[100],
      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/p_chat', arguments: {
            'chat_id': contact['chat_id'],
            'doctor_name': contact['doctor_name'],
          });
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(contact['doctor_image_url']),
                radius: 30.0,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Dr. ' + contact['doctor_name'],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(message_header + contact['last_message']),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<dynamic, dynamic>>(
        future: getContacts(),
        builder: (context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                title: Text('Messages'),
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      chatHead(contact),
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
