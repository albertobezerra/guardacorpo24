import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class InterstitialAdManager {
  static Future<void> showInterstitialAd(
      BuildContext context, Widget destination) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuário não logado, exibe anúncio
      await _showAdAndNavigate(context, destination);
      return;
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);

    if (subscriptionInfo['isPremium']) {
      // Usuário premium ou ad-free, não exibe anúncio
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } else {
      if (!context.mounted) return;
      // Exibe anúncio antes de navegar
      await _showAdAndNavigate(context, destination);
    }
  }

  static Future<void> _showAdAndNavigate(
      BuildContext context, Widget destination) async {
    // Exibe o anúncio interstitial aqui
    // Certifique-se de usar o pacote google_mobile_ads ou outro SDK de anúncios

    // Após o anúncio ser exibido, navegue para a tela de destino
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
