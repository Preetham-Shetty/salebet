import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salesbets/config/constants/app_constants.dart';
import 'package:salesbets/logic/cubits/google/google_signin_cubit.dart';
import 'package:salesbets/logic/cubits/navigation/navigation_cubit.dart';
import 'package:salesbets/logic/services/google/google_signin.dart';
import 'package:salesbets/presentation/screens/splash/splash_screen.dart';

class SalesBetsApp extends StatelessWidget {
  const SalesBetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GoogleSignInCubit(GoogleSigninService()),
        ),
        BlocProvider(create: (context) => NavigationCubit()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
