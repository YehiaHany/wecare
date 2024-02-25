import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loadingnormal extends StatefulWidget {
  const Loadingnormal({super.key});

  @override
  State<Loadingnormal> createState() => _LoadingnormalState();
}

class _LoadingnormalState extends State<Loadingnormal> {
  @override
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate some time-consuming task
    Future.delayed(const Duration(seconds: 3), () {
      // Set loading to false when the task is complete
      setState(() {
        isLoading = false;
      });

    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SpinKitPumpingHeart(
                color: Colors.white,
                size: 150.0,
              ),
          ],
        ),
      ),
    );
  }
}
