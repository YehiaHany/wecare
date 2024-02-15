import 'package:flutter/material.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({super.key});

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {

  Map data = {};

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic> ?? {};

    List<Map> medications = [
      {'name': 'adol', 'time_to_take': '10.00'},
      {'name': 'panadol', 'time_to_take': '10.00'},
      {'name': 'paracitamol', 'time_to_take': '10.00'},
      {'name': 'allear', 'time_to_take': '10.00'},
      {'name': 'adol', 'time_to_take': '10.00'},
      {'name': 'panadol', 'time_to_take': '10.00'},
      {'name': 'paracitamol', 'time_to_take': '10.00'},
      {'name': 'allear', 'time_to_take': '10.00'},
    ];

    Widget medicationCardTemplate(medication){
      return Card(
        margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(
                medication['name'],
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[600]
                ),
              ),
              Spacer(),
              Text(
                medication['time_to_take'],
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[800]
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('check'),
              )
            ],
          ),
        ),
      );
    }

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
                    onPressed: () {},
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
                      Navigator.pushNamed(context, '/profile', arguments: {
                        'age': data['age'],
                        'email': data['email'],
                        'gender': data['gender'],
                        'first_name': data['first_name'],
                        'last_name': data['last_name'],
                        'password': data['password'],
                        'phone_number': data['phone_number'],
                        'medical_history': data['medical_history'],
                      });
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
                      Navigator.pushNamed(context, '/chat', arguments: {});
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
          SizedBox(height: 10),
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
                        'Medication times',
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
          SizedBox(height: 20),
          Column(
            children: [
              SizedBox(
                width: 250,
                child: TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                    foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'view personal doctors',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.medical_services,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                    foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'search doctors',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
