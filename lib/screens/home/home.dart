import 'package:flutter/material.dart';
import '../loading/loading.dart';
import '../signin/signin.dart';
import '../signup/signup.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Image
            Image.asset(
              'assets/images/Heart3.png',
              width: 200.0,
              height: 200.0,
              // Adjust width and height as needed
            ),

            // Slogan
            Text(
              'We Care And Of You We Will Take Care ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.0),

            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                // Navigate to LoadingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingPage(destinationPage: SignUpPage())),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // background color
                foregroundColor: Colors.blue.shade900, // font color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: Size(300.0, 50.0), // button width and height
              ),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 40.0),
            // Sign In Button
            ElevatedButton(
              onPressed: () {
                // Navigate to LoadingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingPage(destinationPage: SignInPage())),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // background color
                foregroundColor: Colors.blue.shade900, // font color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: Size(300.0, 50.0), // button width and height
              ),
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}



