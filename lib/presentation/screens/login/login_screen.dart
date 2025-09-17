import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salesbets/config/constants/app_constants.dart';
import 'package:salesbets/config/dimension/dimensions.dart';
import 'package:salesbets/config/text/app_text.dart';
import 'package:salesbets/logic/cubits/google/google_signin_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            painter: ArcPainter(),
            child: SizedBox(
              width: Dimensions.screenWidth,
              height: Dimensions.screenHeight * 0.7,
            ),
          ),
          Positioned(
            top: 80,
            right: 5,
            left: 5,
            child: Column(
              children: [
                Lottie.asset(AppConstants.splashLottie),
                const AppText(
                  text: "Sign-in to Continue",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProximaNova',
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocConsumer<GoogleSignInCubit, GoogleSignInState>(
              listener: (context, state) {
                if (state is GoogleSignInSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => state.nextScreen),
                    (route) => false,
                  );
                }
                if (state is GoogleSignInFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    context.read<GoogleSignInCubit>().signInWithGoogle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.screenWidth * 0.02,
                      vertical: Dimensions.screenHeight * 0.01,
                    ),
                    width: Dimensions.screenWidth * 0.8,
                    margin: EdgeInsets.only(
                      bottom: Dimensions.screenHeight * 0.2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.google, color: Colors.blue),
                        const SizedBox(width: 20),
                        state is GoogleSignInLoading
                            ? const CircularProgressIndicator()
                            : const AppText(
                                text: "Sign-in with Google",
                                fontSize: 20,
                                fontColor: Colors.white,
                                fontFamily: 'ProximaNova',
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path redArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 170)
      ..quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        size.height - 170,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(redArc, Paint()..color = Colors.blue);

    Path whiteArc = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - 185)
      ..quadraticBezierTo(
        size.width / 2,
        size.height - 70,
        size.width,
        size.height - 185,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(whiteArc, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
