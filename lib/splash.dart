// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:rct/view-model/functions/check_token.dart';
// import 'dart:async';

// import 'package:rct/view/home_screen.dart';
// import 'package:rct/view/onboarding/onboarding_screen_1.dart';

// class SplashScreen extends StatefulWidget {
//   static String id = "SplashScreen";
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 1), () async {
//       bool token = await Checktoken().hasToken();
//       if (kDebugMode) {
//         print("Token: $token");
//       }
//       token
//           ? Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => HomeScreen()))
//           : Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => OnboardingScreen()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset(
//           'assets/images/splash.png', // Replace with your image path
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity,
//         ),
//       ),
//     );
//   }
// }

//google play  changes criteria
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import 'package:rct/view/home_screen.dart';
import 'package:rct/view/onboarding/onboarding_screen_1.dart';

class SplashScreen extends StatefulWidget {
  static String id = "SplashScreen";
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool hasCompletedOnboarding = false; // Initialize as false

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus(); // Check the onboarding status

    Timer(const Duration(seconds: 1), () {
      if (kDebugMode) {
        print("Onboarding status: $hasCompletedOnboarding");
      }
      // Navigate based on the boolean value
      hasCompletedOnboarding
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()))
          : Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => OnboardingScreen()));
    });
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.png', // Replace with your image path
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
