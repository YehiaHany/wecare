import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class P_PatientProfile extends StatefulWidget {
  const P_PatientProfile({super.key});

  @override
  State<P_PatientProfile> createState() => _P_PatientProfileState();
}

class _P_PatientProfileState extends State<P_PatientProfile> {

  Map patient_info = {};
  List medical_history = [];
  FirebaseInterface F = new FirebaseInterface();
  String patientID = '';

  Future<Map> getPatientInfo() async{
    patientID = ModalRoute.of(context)!.settings.arguments as String;
    patient_info = await F.getPatientInfo(patientID);
    medical_history = patient_info['medical_history'] ?? [];
    return patient_info;
  }

  void showEditInfoForm(BuildContext context) {

    final TextEditingController nameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    nameController.text = patient_info['username'];
    ageController.text = patient_info['age'].toString();
    emailController.text = patient_info['email'];
    phoneNumberController.text = patient_info['phonenumber'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text('Enter Updated Information'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      controller: nameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Age'),
                      controller: ageController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: emailController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      controller: phoneNumberController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> new_data = {
                              'age': int.parse(ageController.text),
                              'email': patient_info['email'],
                              'gender': patient_info['gender'],
                              'username': nameController.text,
                              'phonenumber': phoneNumberController.text,
                              'medical_history': patient_info['medical_history'],
                              'meds': patient_info['meds'],
                            };

                            await F.updatePatientInfo(new_data, patientID);
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget medicalHistoryEntry(entry){
    List symptoms = entry['symptoms'];

    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                      children: [
                        Text(
                          'Symptoms:',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: symptoms.map((symptom) => Text(
                      symptom,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                    ).toList(),
                  ),
                  Row(
                    children: [
                      Text(
                        'Diagnosis:',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        entry['diagnosis'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Date:',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        entry['date'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )
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
                title: Text('Profile'),
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(patient_info['profileImage']),
                          radius: 100,
                        ),
                      ),
                      Divider(
                        height: 30,
                        color: Colors.grey[800],
                      ),
                      Text(
                        'Personal Info',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Name:',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            patient_info['username'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Age:',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            patient_info['age'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Gender:',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            patient_info['gender'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Email:',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            patient_info['email'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            'Phone number:',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            patient_info['phonenumber'],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: (){
                          showEditInfoForm(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('edit'),
                        ),
                      ),
                      Divider(
                        height: 30,
                        color: Colors.grey[800],
                      ),
                      Text(
                        'Medical History',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children:  medical_history.map((entry) => medicalHistoryEntry(entry)).toList(),
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
