import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  final Widget destinationPage;

  LoadingPage({required this.destinationPage});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate some time-consuming task
    Future.delayed(Duration(seconds: 3), () {
      // Set loading to false when the task is complete
      setState(() {
        isLoading = false;
      });

      // Navigate to the destination page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.destinationPage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SpinKitPumpingHeart(
                color: Colors.white,
                size: 150.0,
              ),
          ],
        ),
      ),
    );
  }
}