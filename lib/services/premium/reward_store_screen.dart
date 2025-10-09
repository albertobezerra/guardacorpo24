import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class RewardStoreScreen extends StatelessWidget {
  const RewardStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Loja de Recompensas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seus pontos: ${userProvider.rewardPoints}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: userProvider.rewardPoints >= 100
                  ? () async {
                      await userProvider.activateAdFreeReward();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Você ganhou 7 dias sem anúncios!'),
                        ),
                      );
                    }
                  : null,
              child: const Text('Trocar 100 pontos por 7 dias sem anúncios'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: userProvider.rewardPoints >= 400
                  ? () async {
                      final expiry =
                          DateTime.now().add(const Duration(days: 14));
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'rewardPoints': 0,
                          'rewardExpiryDate': expiry,
                          'planType': 'reward_full_access',
                          'subscriptionStatus': 'active',
                        });
                      }

                      userProvider.updateReward(points: 0, expiry: expiry);

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              '🎉 Você ganhou 14 dias sem anúncios + conteúdo premium!'),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                  'Trocar 400 pontos por 14 dias + conteúdo premium'),
            ),
          ],
        ),
      ),
    );
  }
}
