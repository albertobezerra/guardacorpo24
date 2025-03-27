import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  BannerAdWidgetState createState() => BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isPremium = false; // Usuário não logado, não é premium
      });
      return;
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);

    setState(() {
      _isPremium = subscriptionInfo['isPremium'] ?? false;
    });

    if (!_isPremium) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-7979689703488774/4117286099', // Substitua pelo seu ID de unidade de anúncio
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (mounted) {
            setState(() {});
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Erro ao carregar anúncio: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPremium) {
      // Usuário premium ou livre de publicidade, não exibe o banner
      return const SizedBox.shrink();
    }

    return _bannerAd != null
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox
            .shrink(); // Use SizedBox.shrink() para evitar problemas de layout
  }
}
