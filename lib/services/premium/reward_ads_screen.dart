import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardAdsScreen extends StatefulWidget {
  const RewardAdsScreen({super.key});

  @override
  State<RewardAdsScreen> createState() => _RewardAdsScreenState();
}

class _RewardAdsScreenState extends State<RewardAdsScreen> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isRewardGranted = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId:
          'ca-app-pub-7979689703488774/6389624112', // substitua pelo seu ID real
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('RewardedAd carregado com sucesso.');
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Falha ao carregar RewardedAd: $error');
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anúncio não carregado. Tente novamente.')),
      );
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd(); // recarrega para próxima vez
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Erro ao exibir RewardedAd: $error');
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
      debugPrint('Usuário recebeu recompensa: ${reward.amount} ${reward.type}');
      await _grantReward();
    });

    _rewardedAd = null;
  }

  Future<void> _grantReward() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Define 7 dias de "ad_free_reward"
    final expiryDate = DateTime.now().add(const Duration(days: 7));

    // Atualiza Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'planType': 'ad_free_reward',
      'subscriptionStatus': 'active',
      'expiryDate': expiryDate,
      'hasEverSubscribedPremium': true,
    });

    // Atualiza provider local
    userProvider.updateSubscription(
      isLoggedIn: true,
      isPremium: true,
      planType: 'ad_free_reward',
      expiryDate: expiryDate,
      hasEverSubscribedPremium: true,
    );

    setState(() {
      _isRewardGranted = true;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Parabéns! Você ganhou 7 dias sem anúncios.')),
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganhe dias sem anúncios'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Assista ao anúncio abaixo para ganhar 7 dias sem anúncios!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    _isAdLoaded && !_isRewardGranted ? _showRewardedAd : null,
                child: Text(
                  _isRewardGranted
                      ? 'Recompensa concedida!'
                      : 'Assistir Anúncio',
                ),
              ),
              const SizedBox(height: 20),
              if (!_isAdLoaded)
                const Text('Carregando anúncio...',
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
