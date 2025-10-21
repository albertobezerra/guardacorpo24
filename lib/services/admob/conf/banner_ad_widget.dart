import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      setState(() => _isPremium = false);
      return;
    }

    // Pega os dados do usuário do Firebase
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      setState(() => _isPremium = false);
      return;
    }

    final data = doc.data()!;
    final expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
    final rewardExpiryDate = (data['rewardExpiryDate'] as Timestamp?)?.toDate();

    final now = DateTime.now();
    // Premium ativo se assinatura válida ou recompensa válida
    final premiumActive = (expiryDate != null && expiryDate.isAfter(now)) ||
        (rewardExpiryDate != null && rewardExpiryDate.isAfter(now));

    setState(() {
      _isPremium = premiumActive;
    });

    if (!_isPremium) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7979689703488774/4117286099',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (mounted) setState(() {});
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
    // Se premium ou recompensa ativa, não mostra banner
    if (_isPremium) return const SizedBox.shrink();

    return _bannerAd != null
        ? Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox.shrink();
  }
}
