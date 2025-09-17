import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salesbets/logic/cubits/navigation/navigation_cubit.dart';
import '../../../screens/home/home_screen.dart';
import '../../../screens/live/live_screen.dart';
import '../../../screens/profile/profile_screen.dart';
import 'bottom_navigation_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              HomeScreen(),
              Live(matchId: 'M1'),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: const BottomNavigationWidget(),
        );
      },
    );
  }
}
