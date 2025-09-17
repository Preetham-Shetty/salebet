import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salesbets/logic/services/firebase/firebase_services.dart';
import 'package:salesbets/presentation/screens/home/widgets/team_widget.dart';

class MostFollowedTeamlist extends StatelessWidget {
  final String userId;
  const MostFollowedTeamlist({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: FirebaseServices().getUserFollowing(userId),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final followingTeamIds = userSnapshot.data!;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('teams').snapshots(),
          builder: (context, teamSnapshot) {
            if (teamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!teamSnapshot.hasData || teamSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No teams found"));
            }

            final teams = teamSnapshot.data!.docs;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teams.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final team = teams[index].data() as Map<String, dynamic>;
                final teamId = teams[index].id;

                return TeamWidget(
                  name: team['Name'] ?? "Unknown",
                  followers: team['followers']?.toString() ?? "0",
                  isFollowing: followingTeamIds.contains(teamId),
                  onFollowToggle: () {
                    FirebaseServices().toggleFollow(
                      userId,
                      teamId,
                      followingTeamIds.contains(teamId),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
