import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:salesbets/presentation/screens/home/widgets/credit_overview_card.dart';
import 'package:salesbets/presentation/screens/home/widgets/live_events.dart';
import 'package:salesbets/presentation/screens/home/widgets/section_title.dart';
import 'package:salesbets/presentation/screens/home/widgets/most_followed_team_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FadeInDown(child: AchievementHighlightCard()),
              SizedBox(height: 30),
              FadeInUp(child: SectionTitle(label: "🔥Matches")),
              SizedBox(height: 16),
              FadeInUp(
                delay: Duration(milliseconds: 200),
                child: LiveEventsCarousel(),
              ),
              SizedBox(height: 30),
              FadeInUp(child: SectionTitle(label: "⭐Most Followed Teams")),
              SizedBox(height: 16),
              FadeInUp(
                delay: Duration(milliseconds: 400),
                child: MostFollowedTeamlist(
                  userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
