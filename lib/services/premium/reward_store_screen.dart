import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class RewardStoreScreen extends StatelessWidget {
  const RewardStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    bool canActivateAdFree() {
      // 100 pontos só ativa se não houver recompensa ativa
      if (userProvider.hasRewardActive &&
          (userProvider.planType == 'reward_full_access' ||
              userProvider.planType == 'ad_free_reward')) {
        return false;
      }
      return userProvider.rewardPoints >= 100;
    }

    bool canActivatePremium() {
      // 400 pontos só ativa se premium via recompensa não estiver ativo
      if (userProvider.hasRewardActive &&
          userProvider.planType == 'reward_full_access') {
        return false;
      }
      return userProvider.rewardPoints >= 400;
    }

    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      return '$day/$month/$year';
    }

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seus pontos: ${userProvider.rewardPoints}',
                    style: const TextStyle(
                        fontFamily: 'Segoe Bold',
                        color: Colors.black,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  // Status da recompensa ativa
                  if (userProvider.hasRewardActive)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recompensa ativa: ${userProvider.planType == 'reward_full_access' ? 'Premium via Recompensa' : 'Sem Anúncios'}',
                          style: const TextStyle(
                              fontFamily: 'Segoe', fontSize: 14),
                        ),
                        Text(
                          'Válida até: ${formatDate(userProvider.rewardExpiryDate)}',
                          style: const TextStyle(
                              fontFamily: 'Segoe', fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  // Botões de recompensa
                  ElevatedButton(
                    onPressed: canActivateAdFree()
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

                  ElevatedButton(
                    onPressed: canActivatePremium()
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
