import 'package:flutter/material.dart';


class Appointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments',
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/viewAppointments');
              },
              child: Text('View Appointments'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to search doctors by speciality page
                Navigator.pushNamed(context, '/searchBySpeciality');
              },
              icon: Icon(Icons.search),
              label: Text('Search for Doctors by Speciality'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to search doctors by location page
                // Navigator.pushNamed(context, '/searchByLocation');
              },
              icon: Icon(Icons.location_on),
              label: Text('Search for Doctors by Location'),
            ),
          ],
        ),
      ),
    );
  }
}


