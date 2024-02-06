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
    final List<Widget> _pages = [
      // Add your pages here
      // Example: FirstPage(), SecondPage(), ThirdPage()
      DoctorPage(userId: widget.userId,),
      LogOut(),
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue.shade900,
        backgroundColor: Colors.white,
        height: 50,
        animationDuration: Duration(milliseconds: 200),
        items: [
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
