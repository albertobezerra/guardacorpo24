import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7979689703488774/6918601457',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _interstitialAd?.setImmersiveMode(true);
          debugPrint('✅ Anúncio intersticial carregado');
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('⚠️ Falha ao carregar intersticial: $error');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context, Widget nextPage) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final showAds = !userProvider.isAdFree();

    if (!showAds) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => nextPage));
      return;
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => nextPage));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => nextPage));
        },
      );
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => nextPage));
    }
  }
}
