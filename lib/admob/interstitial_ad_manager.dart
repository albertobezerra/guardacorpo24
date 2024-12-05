import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context, Widget nextPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (_isInterstitialAdReady) {
        SystemSound.play(SystemSoundType.click);
        _interstitialAd?.show();
        _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            loadInterstitialAd();
            SystemSound.play(SystemSoundType.click);
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            loadInterstitialAd();
            SystemSound.play(SystemSoundType.click);
          },
        );
      }
    });
  }
}
