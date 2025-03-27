import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Certifique-se de adicionar o pacote google_mobile_ads
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;

  static Future<void> showInterstitialAd(
      BuildContext context, Widget destination) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Usuário não logado, exibe anúncio
        await _loadAndShowAd(context, destination);
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
        await _loadAndShowAd(context, destination);
      }
    } catch (e) {
      debugPrint('Erro ao exibir anúncio intersticial: $e');
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  static Future<void> _loadAndShowAd(
      BuildContext context, Widget destination) async {
    await _createInterstitialAd();
    if (_interstitialAd == null) {
      // Se o anúncio não foi carregado, navegue diretamente
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Erro ao exibir anúncio intersticial: $error');
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );

    _interstitialAd!.show();
  }

  static Future<void> _createInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId:
          'ca-app-pub-7979689703488774/6918601457', // Substitua pelo seu ID de unidade de anúncio
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Erro ao carregar anúncio intersticial: $error');
          _interstitialAd = null;
        },
      ),
    );
  }
}
