import 'package:flutter/material.dart';

class AchievementHighlightCard extends StatelessWidget {
  const AchievementHighlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🏆 Achievements",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 12),
          const Text(
            "Top Predictor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildStat(icon: Icons.check_circle, label: "Wins", value: "24"),
              const SizedBox(width: 24),
              _buildStat(icon: Icons.star, label: "Streak", value: "7"),
              const SizedBox(width: 24),
              _buildStat(icon: Icons.group, label: "Followers", value: "1.2K"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.amberAccent, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
