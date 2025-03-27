import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/admob/conf/banner_ad_widget.dart';

class ConditionalBannerAdWidget extends StatelessWidget {
  const ConditionalBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        // Se ainda está carregando, exibe um espaço vazio temporário
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 50); // Altura fixa enquanto carrega
        }

        // Verifica o status do usuário
        final isPremium = snapshot.data?['isPremium'] ?? false;
        final planType = snapshot.data?['planType'] ?? '';

        // Exibe o banner apenas se o usuário não for premium nem "ad_free"
        if (!isPremium && planType != 'ad_free') {
          return const BannerAdWidget(); // Widget do banner de anúncio
        }

        // Caso contrário, retorna um espaço vazio
        return const SizedBox.shrink();
      },
    );
  }

  Future<Map<String, dynamic>> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'isPremium': false, 'planType': ''};
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);
    return {
      'isPremium': subscriptionInfo['isPremium'] ?? false,
      'planType': subscriptionInfo['planType'] ?? '',
    };
  }
}
