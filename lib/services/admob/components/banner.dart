import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/services/admob/conf/banner_ad_widget.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class ConditionalBannerAdWidget extends StatelessWidget {
  const ConditionalBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 50);
        }

        final isPremium = snapshot.data?['isPremium'] ?? false;
        final planType = snapshot.data?['planType'] ?? '';
        final expiryDate = snapshot.data?['expiryDate'] as DateTime?;
        final rewardExpiryDate =
            snapshot.data?['rewardExpiryDate'] as DateTime?;

        final now = DateTime.now();

        // Considera premium ativo ou recompensa válida apenas se a data ainda estiver no futuro
        final premiumActive =
            (isPremium && expiryDate != null && expiryDate.isAfter(now)) ||
                (rewardExpiryDate != null &&
                    rewardExpiryDate.isAfter(now) &&
                    planType == 'reward_full_access');

        if (!premiumActive) {
          return const BannerAdWidget();
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<Map<String, dynamic>> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {
        'isPremium': false,
        'planType': '',
        'expiryDate': null,
        'rewardExpiryDate': null
      };
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);
    return {
      'isPremium': subscriptionInfo['isPremium'] ?? false,
      'planType': subscriptionInfo['planType'] ?? '',
      'expiryDate': subscriptionInfo['expiryDate'],
      'rewardExpiryDate': subscriptionInfo['rewardExpiryDate'],
    };
  }
}
