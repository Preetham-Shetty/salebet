import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salesbets/config/constants/app_constants.dart';
import 'package:salesbets/config/dimension/dimensions.dart';
import 'package:salesbets/logic/services/google/google_signin.dart';
import 'package:salesbets/presentation/common/widgets/common/landing_page.dart';
import 'package:salesbets/presentation/screens/login/login_screen.dart';
import 'package:salesbets/presentation/screens/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool visible = true;
  bool skipScreen = false;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    if (seen) {
      setState(() {
        skipScreen = true;
      });
    } else {
      await prefs.setBool('seen', true);
      setState(() {
        skipScreen = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        visible = false;
      });
    });
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => skipScreen
              ? (GoogleSigninService().isSignedIn()
                    ? const LandingPage()
                    : const LoginScreen())
              : const OnboardingScreen(),
        ),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions.init(context: context);
    return Scaffold(
      body: Center(
        child: visible
            ? Lottie.asset(
                AppConstants.splashLottie,
                width: Dimensions.screenWidth,
                height: Dimensions.screenHeight * 0.3,
                repeat: false,
              )
            : const Text(
                "SalesBets",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontFamily: 'Splash',
                ),
              ),
      ),
    );
  }
}
