import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-7979689703488774/6918601457', // Substitua pelo seu ID de unidade de anúncio
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Erro ao carregar anúncio intersticial: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context, Widget nextPage) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final subscriptionInfo =
          await SubscriptionService().getUserSubscriptionInfo(user.uid);
      final isPremium = subscriptionInfo['isPremium'] ?? false;
      final planType = subscriptionInfo['planType'] ?? '';

      if (isPremium || planType == 'ad_free') {
        // Usuário premium ou sem publicidade, não exibe o anúncio
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
        return;
      }
    }

    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('Erro ao exibir anúncio intersticial: $error');
          ad.dispose();
          loadInterstitialAd();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
      );
    } else {
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }
}
