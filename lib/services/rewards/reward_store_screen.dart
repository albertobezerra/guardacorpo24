import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class RewardStoreScreen extends StatelessWidget {
  const RewardStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    bool canActivateAdFree() {
      return userProvider.rewardPoints >= 100 &&
          !(userProvider.hasRewardActive &&
              userProvider.planType == 'ad_free_reward') &&
          !userProvider.hasActivePremiumReward;
    }

    bool canActivatePremium() {
      return userProvider.rewardPoints >= 400 &&
          !(userProvider.hasRewardActive &&
              userProvider.planType == 'reward_full_access');
    }

    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LOJA DE RECOMPENSAS',
            style: TextStyle(
                fontFamily: 'Segoe Bold', color: Colors.white, fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text('Seus pontos: ${userProvider.rewardPoints}',
                            style: const TextStyle(
                                fontFamily: 'Segoe Bold', fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (userProvider.hasRewardActive) ...[
                      const Text('Recompensa ativa:',
                          style: TextStyle(fontFamily: 'Segoe Bold')),
                      Text(userProvider.planDisplayName,
                          style: const TextStyle(fontFamily: 'Segoe')),
                      Text(
                          'Válida até: ${formatDate(userProvider.rewardExpiryDate)}',
                          style: const TextStyle(fontFamily: 'Segoe')),
                      const Divider(height: 24),
                    ],
                    _buildRewardButton(
                      context: context,
                      title: '100 pontos → 7 dias sem anúncios',
                      icon: Icons.visibility_off,
                      cost: 100,
                      canActivate: canActivateAdFree(),
                      onPressed: () => _confirmAndActivate(
                        context: context,
                        userProvider: userProvider,
                        title: '7 dias sem anúncios',
                        cost: 100,
                        type: 'ad_free_reward',
                        days: 7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRewardButton(
                      context: context,
                      title: '400 pontos → 14 dias premium',
                      icon: Icons.star,
                      cost: 400,
                      canActivate: canActivatePremium(),
                      onPressed: () => _confirmAndActivate(
                        context: context,
                        userProvider: userProvider,
                        title: '14 dias premium',
                        cost: 400,
                        type: 'reward_full_access',
                        days: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int cost,
    required bool canActivate,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: canActivate ? onPressed : null,
      icon: Icon(icon, color: Colors.white),
      label: Text(title,
          style:
              const TextStyle(fontFamily: 'Segoe Bold', color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
        disabledBackgroundColor: Colors.grey[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }

  void _confirmAndActivate({
    required BuildContext context,
    required UserProvider userProvider,
    required String title,
    required int cost,
    required String type,
    required int days,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirmar Troca',
            style: TextStyle(fontFamily: 'Segoe Bold')),
        content: Text(
          'Deseja trocar $cost pontos por:\n\n$title\n\nVálido por $days dias?',
          style: const TextStyle(fontFamily: 'Segoe'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 104, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await userProvider.activateReward(
                  cost: cost, type: type, days: days);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ativado: $title'),
                  backgroundColor: const Color.fromARGB(255, 0, 104, 55),
                ),
              );
            },
            child: const Text('Confirmar',
                style:
                    TextStyle(color: Colors.white, fontFamily: 'Segoe Bold')),
          ),
        ],
      ),
    );
  }
}
