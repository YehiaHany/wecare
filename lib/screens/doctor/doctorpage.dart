import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_switch/sliding_switch.dart';

class DoctorPage extends StatefulWidget {
  final String userId;
  const DoctorPage({super.key, required this.userId});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _doctorInfoStream;
  bool isOldPatient = false;
  @override
  void initState() {
    super.initState();
    // Replace 'doctors' with your actual Firestore collection name
    _doctorInfoStream = getDoctorInfoStream('doctors');
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDoctorInfoStream(
    String collection,
  ) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _doctorInfoStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data != null) {
                  Map<String, dynamic> doctorData = snapshot.data!.data() ?? {};
                  String doctorName = doctorData['username'] ?? '';
                  String imageUrl = doctorData['profileImage'] ?? '';
                  String email = doctorData['email'] ?? '';
                  String phoneNumber = doctorData['phonenumber'] ?? '';
                  var workingPlaces =
                      doctorData['workingPlaces'] ?? '';

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.shade500,
                            ),
                            child: const Center(
                              child: Text(''),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                doctorName,
                                style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -25,
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 270,
                                    height: 270,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Container(
                        alignment: Alignment.center,
                        child: SlidingSwitch(
                          value: isOldPatient,
                          width: MediaQuery.of(context).size.width - 31,
                          onChanged: (bool value) {
                            setState(() {
                              isOldPatient = value;
                            });
                          },
                          height: 90,
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                          textOff: "Available Patients",
                          textOn: "Old Patients",
                          colorOn: Colors.white,
                          colorOff: Colors.white,
                          background: Colors.grey.shade300,
                          buttonColor: Colors.blue.shade900,
                          inactiveColor: const Color(0xff636f7b),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.blue.shade900,
                                ),
                                title: Text(
                                  email,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Colors.blue.shade900,
                                ),
                                title: Text(
                                  phoneNumber,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              for (int i = 0; i < workingPlaces.length; i++)
                                ListTile(
                                  leading: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.blue.shade900,
                                  ),
                                  title: Text(
                                    workingPlaces[i],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  
}
