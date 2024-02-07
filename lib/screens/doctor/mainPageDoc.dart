// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      DoctorPage(
        userId: widget.userId,
      ),
      // ignore: prefer_const_constructors
      LogOut(),
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue.shade900,
        backgroundColor: Colors.white,
        height: 50,
        animationDuration: const Duration(milliseconds: 200),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(FontAwesomeIcons.userDoctor, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      body: _pages[_pageIndex],
    );
  }
}
