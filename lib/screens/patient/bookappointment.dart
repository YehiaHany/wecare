import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatefulWidget {
  final String doctorId;
  AppointmentPage({required this.doctorId});
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String selectedDate = 'Select Date'; // Default selected date
  String selectedTime = 'Select Time'; // Default selected time
  TextEditingController concernsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Booking',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Appointment Booking!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('Select Date:'),
                DropdownButton<String>(
                  value: selectedDate,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDate = newValue!;
                    });
                  },
                  items: <String>[
                    'Select Date',
                    '2024-02-20',
                    '2024-02-21',
                    '2024-02-22'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text('Select Time:'),
                DropdownButton<String>(
                  value: selectedTime,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTime = newValue!;
                    });
                  },
                  items: <String>[
                    'Select Time',
                    '09:00 AM',
                    '10:00 AM',
                    '11:00 AM',
                    '01:00 PM',
                    '02:00 PM',
                    '03:00 PM'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: concernsController,
                  decoration: InputDecoration(
                    labelText: 'Specific Concerns (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate != 'Select Date' && selectedTime != 'Select Time') {
                      _confirmAppointment();
                    } else {
                      _showErrorDialog('Please select both date and time.');
                    }
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmAppointment() async {
    try {
 DocumentSnapshot<Map<String, dynamic>> doctorSnapshot =
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(widget.doctorId)
            .get();

    // Get current user (patient)
    // User? user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    // Retrieve patient ID
    // String patientId = user.uid;
    String patientId ='26q6nWwawl2tIxk12Zi1';

    // Fetch patient data from Firestore
    DocumentSnapshot<Map<String, dynamic>> patientSnapshot =
        await FirebaseFirestore.instance
            .collection('trial_patients')
            .doc(patientId)
            .get();

    // Check if patient data exists
    if (patientSnapshot.exists) {
      // Save appointment data to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctor_id': doctorSnapshot.id,
        'doctor_name': doctorSnapshot['username'],
        'doctor_speciality':doctorSnapshot['specialization'],
        'patient_id': patientSnapshot.id,
        'patient_name':
            '${patientSnapshot['username']}',
        'patient_gender': patientSnapshot['gender'],
        'patient_age': patientSnapshot['age'],
        'patient_email': patientSnapshot['email'],
        'appointment_date': selectedDate,
        'appointment_hour': selectedTime,
        'medical_history': patientSnapshot['medical_history'],
        'meds': patientSnapshot['meds'],
        'concerns': concernsController.text, // Include specific concerns
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appointment Confirmed'),
            content: Text(
                'Your appointment on $selectedDate at $selectedTime has been confirmed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Return to previous page
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      throw ('Patient data not found.');
    }
    // } else {
    //   throw ('User is not logged in.');
    // }
   } catch (error) {
      print('Error confirming appointment: $error');
      _showErrorDialog('Failed to confirm appointment. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}





