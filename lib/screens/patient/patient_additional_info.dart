import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecare/screens/patient/patient_firebase_functions.dart';

class PatientAdditionalInfo extends StatefulWidget {
  const PatientAdditionalInfo({super.key});

  @override
  State<PatientAdditionalInfo> createState() => _PatientAdditionalInfoState();
}

class _PatientAdditionalInfoState extends State<PatientAdditionalInfo> {

  TextEditingController dreidTextController = TextEditingController();

  List medsControllers = [];
  List medsFields = [];

  List medHistoryControllers = [];
  List medHistoryFields = [];

  List meds = [];
  List medicalHistory = [];


  FirebaseInterface F = new FirebaseInterface();
  String patientID = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> patientInfo = {};

  void initializeMedsLists() {
    medsControllers = [
      {
        'dose_controller': TextEditingController(),
        'name_controller': TextEditingController(),
        'times_controller': TextEditingController(),
      }
    ];

    medsFields = [
      {
        'dose_field': TextFormField(
          decoration: InputDecoration(labelText: 'Dose'),
          controller: medsControllers[0]['dose_controller'],
        ),
        'name_field': TextFormField(
          decoration: InputDecoration(labelText: 'Name'),
          controller: medsControllers[0]['name_controller'],
        ),
        'times_field': TextFormField(
          decoration: InputDecoration(labelText: 'Times'),
          controller: medsControllers[0]['times_controller'],
        ),
      },
    ];
  }

  void initializeMedHistoryLists() {
    medHistoryControllers = [
      {
        'symptoms_controllers': [TextEditingController()],
        'diagnosis_controller': TextEditingController(),
        'date_controller': TextEditingController(),
      }
    ];

    medHistoryFields = [
      {
        'symptoms_fields': [TextFormField(
          decoration: InputDecoration(labelText: 'Symptom ' + medHistoryControllers[0]['symptoms_controllers'].length.toString()),
          controller: medHistoryControllers[0]['symptoms_controllers'][0],
        ),],
        'diagnosis_field': TextFormField(
          decoration: InputDecoration(labelText: 'Diagnosis'),
          controller: medHistoryControllers[0]['diagnosis_controller'],
        ),
        'date_field': TextFormField(
          decoration: InputDecoration(labelText: 'Date'),
          controller: medHistoryControllers[0]['date_controller'],
        ),
      }
    ];
  }

  Widget generateMedicationFieldsCard(medication,int medication_index){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Medication no. ' + medication_index.toString(),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 19,
              ),
            ),
            medication['dose_field'],
            medication['name_field'],
            medication['times_field'],
          ],
        ),
      ),
    );
  }
  Widget generateSymptomsFieldCard(symptomField, int symptom_index){
    return Card(
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: symptomField,
      ),
    );
  }

  Widget generateSymptomsFields(List symptomsFields) {
    return Column(
      children: symptomsFields.asMap().entries.map((entry) {
        int index = entry.key;
        TextFormField symptomField = entry.value;
        return generateSymptomsFieldCard(symptomField, index + 1);
      }).toList(),
    );
  }

  Widget generateMedicalHistoryFieldsCard(medicalEntry,int medicalEntry_index){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Entry no. ' + medicalEntry_index.toString(),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 19,
              ),
            ),
            generateSymptomsFields(medicalEntry['symptoms_fields']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    medHistoryControllers[medicalEntry_index-1]['symptoms_controllers'].add(TextEditingController());
                    medHistoryFields[medicalEntry_index-1]['symptoms_fields'].add(TextFormField(
                      decoration: InputDecoration(labelText: 'Symptom ' + medHistoryControllers.last['symptoms_controllers'].length.toString()),
                      controller: medHistoryControllers.last['symptoms_controllers'].last,
                    ),);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Text('Add'),
                      Text('symptom'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(medHistoryFields[medicalEntry_index-1]['symptoms_fields'].length > 1) {
                      medHistoryFields[medicalEntry_index - 1]['symptoms_fields'].removeLast();
                      medHistoryControllers[medicalEntry_index - 1]['symptoms_controllers'].removeLast();
                      setState(() {});
                    }
                  },
                  child: Column(
                    children: [
                      Text('Remove'),
                      Text('last symptom'),
                    ],
                  ),
                ),
              ],
            ),
            medicalEntry['diagnosis_field'],
            medicalEntry['date_field'],
          ],
        ),
      ),
    );
  }

  Widget generateMedFields(){
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: medsFields.asMap().entries.map((entry) {
            int index = entry.key;
            Map medication = entry.value;
            return generateMedicationFieldsCard(medication, index + 1);
          }).toList(),
        ),
      ),
    );
  }

  Widget generateMedHistoryFields(){
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: medHistoryFields.asMap().entries.map((entry) {
            int index = entry.key;
            Map medicalRecord = entry.value;
            return generateMedicalHistoryFieldsCard(medicalRecord, index + 1);
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(medsFields.isEmpty) {
      initializeMedsLists();
    }

    if(medHistoryFields.isEmpty) {
      initializeMedHistoryLists();
    }

    patientInfo = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Additional info'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    'Insert Medications',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  generateMedFields(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Map medsControllersNewEntry = {
                            'dose_controller': TextEditingController(),
                            'name_controller': TextEditingController(),
                            'times_controller': TextEditingController(),
                          };

                          medsControllers.add(medsControllersNewEntry);

                          Map medsFieldsNewEntry = {
                            'dose_field': TextFormField(
                              decoration: InputDecoration(labelText: 'Dose'),
                              controller: medsControllers.last['dose_controller'],
                            ),
                            'name_field': TextFormField(
                              decoration: InputDecoration(labelText: 'Name'),
                              controller: medsControllers.last['name_controller'],
                            ),
                            'times_field': TextFormField(
                              decoration: InputDecoration(labelText: 'Times'),
                              controller: medsControllers.last['times_controller'],
                            ),
                          };

                          medsFields.add(medsFieldsNewEntry);

                          setState(() {});
                        },
                        child: Text('Add medication'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          medsFields.removeLast();
                          medsControllers.removeLast();
                          setState(() {});
                        },
                        child: Text('Remove last medication'),
                      ),
                    ],
                  ),
                  Divider(height: 20),
                  Text(
                    'Insert Medical History',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  generateMedHistoryFields(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Map medHistoryControllersNewEntry = {
                            'symptoms_controllers': [TextEditingController()],
                            'diagnosis_controller': TextEditingController(),
                            'date_controller': TextEditingController(),
                          };

                          medHistoryControllers.add(medHistoryControllersNewEntry);

                          Map medHistoryFieldsNewEntry = {
                            'symptoms_fields': [TextFormField(
                              decoration: InputDecoration(labelText: 'Symptom ' + medHistoryControllers.last['symptoms_controllers'].length.toString()),
                              controller: medHistoryControllers.last['symptoms_controllers'].last,
                            ),],
                            'diagnosis_field': TextFormField(
                              decoration: InputDecoration(labelText: 'Diagnosis'),
                              controller: medHistoryControllers.last['diagnosis_controller'],
                            ),
                            'date_field': TextFormField(
                              decoration: InputDecoration(labelText: 'Date'),
                              controller: medHistoryControllers.last['date_controller'],
                            ),
                          };

                          medHistoryFields.add(medHistoryFieldsNewEntry);

                          setState(() {});
                        },
                        child: Text('Add entry'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          medHistoryFields.removeLast();
                          medHistoryControllers.removeLast();
                          setState(() {});
                        },
                        child: Text('Remove last entry'),
                      ),
                    ],
                  ),
                  Divider(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Assigned doctor ID (hard coded)'),
                    controller: dreidTextController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        for(int i=0; i<medsFields.length; i++){
                          Map medsEntry = {
                            'dose': medsControllers[i]['dose_controller'].text,
                            'name': medsControllers[i]['name_controller'].text,
                            'times': medsControllers[i]['times_controller'].text,
                            'alarm_set' : false,
                          };

                          meds.add(medsEntry);
                        }

                        for(int i=0; i<medHistoryFields.length; i++){
                          List entrySymptoms = [];
                          for(int j=0; j<medHistoryFields[i]['symptoms_fields'].length; j++){
                            entrySymptoms.add(medHistoryControllers[i]['symptoms_controllers'][j].text);
                          }

                          Map medHistoryEntry = {
                            'symptoms': entrySymptoms,
                            'diagnosis': medHistoryControllers[i]['diagnosis_controller'].text,
                            'date': medHistoryControllers[i]['date_controller'].text,
                          };

                          medicalHistory.add(medHistoryEntry);
                        }

                        patientInfo['medical_history'] = medicalHistory;
                        patientInfo['meds'] = meds;
                        patientInfo['dreid'] = dreidTextController.text;
                        F.updatePatientInfo(patientInfo, patientID);

                        Navigator.pushReplacementNamed(context, '/patientHome');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                  )
                ],
              ),
            ),
            ),
          ),
        ),
    );
  }
}
