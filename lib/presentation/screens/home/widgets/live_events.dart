import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salesbets/presentation/screens/home/widgets/match_event_card.dart';

class LiveEventsCarousel extends StatelessWidget {
  const LiveEventsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No live events"));
        }

        final events = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: events.length,
          itemBuilder: (context, index, realIndex) {
            final data = events[index].data() as Map<String, dynamic>;

            final String title = data['Name'] ?? "Unknown Match";
            final String teamA = data['teamA'] ?? "Team A";
            final String teamB = data['teamB'] ?? "Team B";
            final bool live = data['isLive'] ?? false;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MatchEventCard(
                title: title,
                teams: [teamA, teamB],
                live: live,
              ),
            );
          },
          options: CarouselOptions(
            height: 160,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 0.8,
          ),
        );
      },
    );
  }
}
