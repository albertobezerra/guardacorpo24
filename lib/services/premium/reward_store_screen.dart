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
      appBar: AppBar(
        title: Text(
          'LOJA DE RECOMPENSAS'.toUpperCase(),
          style: const TextStyle(
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
                    'Seus pontos: ${userProvider.rewardPoints}'.toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Segoe Bold',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: userProvider.rewardPoints >= 100
                        ? () async {
                            await userProvider.activateAdFreeReward();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('🎉 7 dias sem anúncios!')));
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
                    child: Text(
                      '100 pontos por 7 dias sem anúncios'.toUpperCase(),
                      style: const TextStyle(fontFamily: 'Segoe Bold'),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                            userProvider.updateReward(
                                points: 0, expiry: expiry);
                            userProvider.updateSubscription(
                              isLoggedIn: true,
                              isPremium: true,
                              planType: 'reward_full_access',
                              expiryDate: expiry,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('🎉 14 dias premium!')));
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
                    child: Text(
                      '400 pontos por 14 dias + premium'.toUpperCase(),
                      style: const TextStyle(fontFamily: 'Segoe Bold'),
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
