import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bookappointment.dart';

class Doctor {
  final String doctorId;
  final String name;
  final String specialty;

  Doctor({    required this.doctorId,
required this.name, required this.specialty});
}

class DoctorSearchPage extends StatefulWidget {
  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  String selectedSpecialty = 'Speciality';
  late List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    List<Doctor> doctorList = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Doctor(
        doctorId: doc.id,
        name: data['username'],
        specialty: data['specialization'],
      );
    }).toList();

    setState(() {
      doctors = doctorList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Search',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          ),
           centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Specialty:'),
            DropdownButton<String>(
              value: selectedSpecialty,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSpecialty = newValue!;
                });
              },
              items: <String>[
                'Speciality',
                'Dentist',
                'Cardiologist',
                'Dermatologist',
                'Family Medicine',
                'General Surgeon',
                'Internal Medicine',
                'Neurological Surgeon',
                'Gynecologist',
                'Orthopaedic',
                'Pediatrics',
                'Plastic Surgeon',
                'Radiologist',
                'Psychiatrist',
                'Urologist',
                'Anesthesiologist'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Doctors:'),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  Doctor doctor = doctors[index];
                  if (doctor.specialty == selectedSpecialty) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(doctor.name),
                        subtitle: Text(doctor.specialty),
                        trailing: ElevatedButton(
                          onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AppointmentPage(doctorId: doctor.doctorId),
    ),
  );
},

  child: Text('Book Appointment'),
),

                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}





