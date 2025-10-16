import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class RewardStoreScreen extends StatelessWidget {
  const RewardStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOJA DE RECOMPENSAS',
          style: TextStyle(
              fontFamily: 'Segoe Bold', color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 0, 104, 55), Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seus pontos: ${userProvider.rewardPoints}',
                    style: const TextStyle(
                        fontFamily: 'Segoe Bold',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // 100 pontos → 7 dias sem anúncios
                  ElevatedButton(
                    onPressed: userProvider.rewardPoints >= 100
                        ? () async {
                            await userProvider.activateReward(
                              cost: 100,
                              type: 'ad_free_reward',
                              days: 7,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('🎉 7 dias sem anúncios!')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 0, 104, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      '100 pontos por 7 dias sem anúncios',
                      style: TextStyle(fontFamily: 'Segoe Bold'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 400 pontos → 14 dias premium
                  ElevatedButton(
                    onPressed: userProvider.rewardPoints >= 400
                        ? () async {
                            await userProvider.activateReward(
                              cost: 400,
                              type: 'reward_full_access',
                              days: 14,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('🎉 14 dias premium!')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 0, 104, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      '400 pontos por 14 dias + premium',
                      style: TextStyle(fontFamily: 'Segoe Bold'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
