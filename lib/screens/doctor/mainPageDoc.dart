// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wecare/screens/doctor/patients_data.dart';
import 'package:wecare/screens/general/Logout.dart';

import 'doctorpage.dart';

class MainDocPage extends StatefulWidget {
  final String userId;
  const MainDocPage({super.key, required this.userId});

  @override
  State<MainDocPage> createState() => _MainDocPageState();
}

class _MainDocPageState extends State<MainDocPage> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final List<Widget> _pages = [
      // Add your pages here
      // Example: FirstPage(), SecondPage(), ThirdPage()
      DoctorPage(userId: widget.userId),
      PatientsDataPage(dr: widget.userId),
      // ignore: prefer_const_constructors
      LogOut(),
    ];
    return Scaffold(
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(left: 16,right: 16),
      //   child: Container(
      //     height: 45,
      //     decoration: BoxDecoration(
      //       border: Border.all(
      //         color: Colors.blue.shade800, // Set the border color to blue
      //         width: 1.0, // Set the border width
      //       ),
      //       color: Colors.blue.shade800,
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(50),
      //         bottomRight: Radius.circular(50)
      //       ),
      //     ),
      //     child: Row(children: [
      //        Padding(
      //          padding: EdgeInsets.only(left: 15.0),
      //          child: GestureDetector(
      //            child: Container(
      //              decoration: BoxDecoration(
      //                borderRadius: BorderRadius.circular(50),
      //                color: Colors.white,
      //              ),
      //
      //                child: Center(child: Icon(Icons.home,color: Colors.blue.shade800,size: 40,))),
      //          ),
      //        )
      //     ],),
      //   ),
      // ),
      // body: _pages[_pageIndex],
        body: DoctorPage(userId: widget.userId)
    );
  }
}
