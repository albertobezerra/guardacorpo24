// lib/components/reward_cta_widget.dart
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_ads_screen.dart';

class RewardCTAWidget extends StatelessWidget {
  final String contextMessage;

  const RewardCTAWidget(
      {super.key, this.contextMessage = 'Ganhe pontos e troque por bônus!'});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 0, 104, 55), Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEM PUBLICIDADE!',
                  style: TextStyle(
                    fontFamily: 'Segoe Bold',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  contextMessage,
                  style: const TextStyle(
                    fontFamily: 'Segoe',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RewardAdsScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Assistir',
              style: TextStyle(
                fontFamily: 'Segoe Bold',
                color: Color.fromARGB(255, 0, 104, 55),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
