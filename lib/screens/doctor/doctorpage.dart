import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:wecare/screens/doctor/patients_data.dart';

import '../home/home.dart';
import '../loading/loading.dart';

class DoctorPage extends StatefulWidget {
  final String userId;
  const DoctorPage({super.key, required this.userId});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _doctorInfoStream;
  // bool isOldPatient = false;
  @override
  void initState() {
    super.initState();
    // Replace 'doctors' with your actual Firestore collection name
    _doctorInfoStream = getDoctorInfoStream('doctors');
  }

  String capitalize_First_Name(String input) {
    if (input == null || input.isEmpty) {
      return input;
    }

    List<String> words = input.split(" ");
    for (int i = 0; i < 1; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(" ");
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
      appBar:AppBar(
        backgroundColor: Colors.blue.shade800,
        leading: Text(''),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert, // Change the icon as needed
              color: Colors.white, // Change the icon color as needed
            ),
            onSelected: (value) async {
              if (value == 'profile') {
                // Handle profile action
                print('Profile selected');
              } else if (value == 'logout') {
                // Handle logout action
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoadingPage(destinationPage: const Home()),
                  ),
                );
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Adjust the border radius
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.account_circle), // Add icon next to 'Profile'
                      SizedBox(width: 8.0), // Add space between icon and text
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app), // Add icon next to 'Logout'
                      SizedBox(width: 8.0), // Add space between icon and text
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
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
              var workingPlaces = doctorData['workingPlaces'] ?? '';

              return Container(
                color: Colors.blue.shade800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    Container(
                      height: 100,
                      child: Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi, ${capitalize_First_Name(doctorName)}', style: TextStyle(fontSize: 25, color: Colors.white)),
                                Text('Welcome Back', style: TextStyle(fontSize: 30, color: Colors.white)),
                              ],
                            ),
                            Spacer(), // Adds space between the text and the image
                            Image.asset(
                              'assets/images/doctor6.png', // Replace with the actual path to your asset image
                              width: 150, // Adjust the width of the image
                              height: 350, // Adjust the height of the image
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                        borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(20.0), // Adjust the radius for rounded corners
                          // bottomLeft: Radius.circular(100.0), // Adjust the radius for rounded corners
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(140.0), // Adjust the radius for rounded corners
                            // bottomLeft: Radius.circular(100.0), // Adjust the radius for rounded corners
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left:48.0,top: 48),
                              child: Row(
                                children: [Text('Category',style: TextStyle(fontSize: 23,color: Colors.black54),),],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                       child: Padding(
                                         padding: EdgeInsets.only(left: 48,top: 14),
                                         child: Container(
                                           height: 130,
                                           width: 120,
                                           decoration: BoxDecoration(
                                             color: Colors.blue.shade800,
                                             borderRadius: BorderRadius.circular(22)
                                           ),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                              Icon(Icons.work_outline_rounded,color: Colors.white,size: 40,),
                                               SizedBox(height: 5,),
                                               Text("Work places",style: TextStyle(fontSize: 14,color: Colors.white),),
                                             ],
                                           ),
                                         ),
                                       
                                       ),
                                     ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PatientsDataPage(dr: widget.userId)),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15,top: 14),
                                      child: Container(
                                        height: 130,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade800,
                                            borderRadius: BorderRadius.circular(22)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person_4_outlined,color: Colors.white,size: 40,),
                                            SizedBox(height: 5,),
                                            Text("Current Patients",style: TextStyle(fontSize: 14,color: Colors.white),),
                                          ],
                                        ),
                                      ),

                                    ),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 15,top: 14,right: 15),
                                      child: Container(
                                        height: 130,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade800,
                                            borderRadius: BorderRadius.circular(22)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person_2_outlined,color: Colors.white,size: 40,),
                                            SizedBox(height: 5,),
                                            Text("Old Patients",style: TextStyle(fontSize: 14,color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                    
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            Expanded(child: Padding(
                              padding:  EdgeInsets.only(left: 48.0,top: 8),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      children: [
                                        Transform(
                                          alignment: Alignment.bottomCenter,
                                          transform: Matrix4.rotationZ(-90 * 3.1415927 / 180), // Rotate 90 degrees clockwise
                                          child: Text(
                                            'Appointments',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 270,
                                              width: 290,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 20.0,top: 40),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Ahmed Ismail',style: TextStyle(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.bold),),
                                                        Text('Time : 3:15 Pm',style: TextStyle(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.bold),),
                                                        Text('Problem in heart',style: TextStyle(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.bold),),


                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Icon(
                                                        FontAwesomeIcons.hospitalUser,
                                                        size: 95.0, // Adjust the size as needed
                                                        color: Colors.blue.shade800, // Adjust the color as needed
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.blue.shade900.withOpacity(1),
                                        Colors.blue.shade700.withOpacity(0.9),
                                        Colors.blue.shade500.withOpacity(0.4),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40)
                                    )
                                ),

                              ),
                            ),),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 48.0,top: 8),
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //           child: Text('here'),
                            //           decoration: BoxDecoration(
                            //               gradient: LinearGradient(
                            //                 begin: Alignment.topLeft,
                            //                 end: Alignment.bottomLeft,
                            //                 colors: [
                            //                   Colors.blue.shade900.withOpacity(0.8),
                            //                   Colors.blue.shade700.withOpacity(0.5),
                            //                   Colors.blue.shade500.withOpacity(0.3),
                            //                 ],
                            //               ),
                            //             borderRadius: BorderRadius.only(
                            //               topLeft: Radius.circular(20)
                            //             )
                            //           ),
                            //
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],

                        ),
                      ),
                    )
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: SlidingSwitch(
                    //     value: isOldPatient,
                    //     width: MediaQuery.of(context).size.width - 31,
                    //     onChanged: (bool value) {
                    //       setState(() {
                    //         isOldPatient = value;
                    //       });
                    //     },
                    //     height: 90,
                    //     onTap: () {},
                    //     onDoubleTap: () {},
                    //     onSwipe: () {},
                    //     textOff: "Available Patients",
                    //     textOn: "Old Patients",
                    //     colorOn: Colors.white,
                    //     colorOff: Colors.white,
                    //     background: Colors.grey.shade300,
                    //     buttonColor: Colors.blue.shade900,
                    //     inactiveColor: const Color(0xff636f7b),
                    //   ),
                    // ),
                    // Card(
                    //   elevation: 15,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(34),
                    //     side: BorderSide(
                    //       color: Colors.grey.shade300,
                    //       width: 1,
                    //     ),
                    //   ),
                    //   color: Colors.white,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Column(
                    //       children: [
                    //         ListTile(
                    //           leading: Icon(
                    //             Icons.email,
                    //             color: Colors.blue.shade900,
                    //           ),
                    //           title: Text(
                    //             email,
                    //             style: const TextStyle(color: Colors.black),
                    //           ),
                    //         ),
                    //         ListTile(
                    //           leading: Icon(
                    //             Icons.phone,
                    //             color: Colors.blue.shade900,
                    //           ),
                    //           title: Text(
                    //             phoneNumber,
                    //             style: const TextStyle(color: Colors.black),
                    //           ),
                    //         ),
                    //         for (int i = 0; i < workingPlaces.length; i++)
                    //           ListTile(
                    //             leading: Icon(
                    //               Icons.location_on_outlined,
                    //               color: Colors.blue.shade900,
                    //             ),
                    //             title: Text(
                    //               workingPlaces[i],
                    //               style: const TextStyle(color: Colors.black),
                    //             ),
                    //           ),
                    //       ],
                    //     ),
                    //   ),
                    // ),


                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
