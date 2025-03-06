import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/conf/banner_ad_widget.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class ConditionalBannerAdWidget extends StatelessWidget {
  const ConditionalBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuário não logado, exibe o banner
      return const BannerAdWidget();
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: SubscriptionService().getUserSubscriptionInfo(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Não exibe nada enquanto carrega
        }

        if (snapshot.hasData && snapshot.data!['isPremium']) {
          // Usuário premium ou ad-free, não exibe o banner
          return const SizedBox.shrink();
        }

        // Exibe o banner para usuários gratuitos
        return const BannerAdWidget();
      },
    );
  }
}
