import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salesbets/logic/cubits/navigation/navigation_cubit.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.transparent)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) =>
                  context.read<NavigationCubit>().changeTab(index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black.withOpacity(0.3),
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              selectedFontSize: 13,
              unselectedFontSize: 11,
              showUnselectedLabels: true,
              items: [
                _navItem(
                  icon: FontAwesomeIcons.house,
                  activeIcon: FontAwesomeIcons.solidCircle,
                  label: 'Home',
                ),
                _navItem(
                  icon: FontAwesomeIcons.towerBroadcast,
                  activeIcon: FontAwesomeIcons.solidCircle,
                  label: 'Live',
                ),
                _navItem(
                  icon: FontAwesomeIcons.user,
                  activeIcon: FontAwesomeIcons.solidCircle,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20),
      ),
      activeIcon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(activeIcon, size: 22),
      ),
      label: label,
    );
  }
}
