import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewAppointments extends StatefulWidget {
  @override
  _ViewAppointmentsScreenState createState() => _ViewAppointmentsScreenState();
}

class _ViewAppointmentsScreenState extends State<ViewAppointments> {
  late String currentPatientId;
  late List<DocumentSnapshot> appointments = [];

  @override
  void initState() {
    super.initState();
    // Fetch current logged-in patient ID
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentPatientId = user.uid; // Initialize currentPatientId here
      fetchAppointments();
    } else {
      throw ('User is not logged in.');
    }
  }

  void fetchAppointments() async {
    // Query appointments collection for appointments of the current patient
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patient_id', isEqualTo: currentPatientId)
        .get();

    setState(() {
      appointments = snapshot.docs;
    });
  }

  Future<void> _showCancelConfirmationDialog(String appointmentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this appointment?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                cancelAppointment(appointmentId);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void cancelAppointment(String appointmentId) async {
    try {
      // Delete appointment document from Firestore
      await FirebaseFirestore.instance.collection('appointments').doc(appointmentId).delete();
      // Update the UI by removing the canceled appointment from the list
      setState(() {
        appointments.removeWhere((appointment) => appointment.id == appointmentId);
      });
    } catch (error) {
      print('Error canceling appointment: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Appointments',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          DocumentSnapshot appointment = appointments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              title: Text('Doctor: ${appointment['doctor_name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Speciality: ${appointment['doctor_speciality']}'),
                  Text('Date: ${appointment['appointment_date']}'),
                  Text('Time: ${appointment['appointment_hour']}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _showCancelConfirmationDialog(appointment.id);
                },
                child: Text('Cancel Appointment'),
              ),
            ),
          );
        },
      ),
    );
  }
}












