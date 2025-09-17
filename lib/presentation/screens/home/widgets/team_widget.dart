import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  final String name;
  final String followers;
  final bool isFollowing;
  final VoidCallback? onFollowToggle;

  const TeamWidget({
    required this.name,
    required this.followers,
    required this.isFollowing,
    this.onFollowToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1f1c2c), Color(0xFF928DAB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.people_alt, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                followers,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),

          const Spacer(),
          GestureDetector(
            onTap: onFollowToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isFollowing ? Colors.redAccent : Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFollowing ? Icons.check_circle : Icons.add_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFollowing ? "Unfollow" : "Follow",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
