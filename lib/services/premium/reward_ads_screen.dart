import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarda_corpo_2024/services/premium/reward_store_screen.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';

class RewardAdsScreen extends StatefulWidget {
  const RewardAdsScreen({super.key});

  @override
  State<RewardAdsScreen> createState() => _RewardAdsScreenState();
}

class _RewardAdsScreenState extends State<RewardAdsScreen> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  static const int pointsPerAd = 4; // ajuste aqui (sugestão)
  bool _isGranting = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId:
          'ca-app-pub-7979689703488774/6389624112', // teu Rewarded Ad Unit
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Erro ao carregar RewardedAd: $err');
          setState(() {
            _rewardedAd = null;
            _isAdLoaded = false;
          });
        },
      ),
    );
  }

  Future<void> _onUserEarnedReward() async {
    if (_isGranting) return;
    _isGranting = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isGranting = false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para ganhar pontos.')),
      );
      return;
    }

    final uid = user.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      // Incrementa pontos de forma atômica
      await userDoc.set({'rewardPoints': FieldValue.increment(pointsPerAd)},
          SetOptions(merge: true));

      // Atualiza provider local (ele tem listener onSnapshot e deveria pegar mudança automaticamente;
      // mas aqui forçamos uma leitura rápida para sincronizar UI imediatamente)
      final snapshot = await userDoc.get();
      final data = snapshot.data();
      final newPoints = (data != null && data['rewardPoints'] != null)
          ? data['rewardPoints'] as int
          : 0;
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).updateReward(
            points: newPoints,
            expiry: (data?['rewardExpiryDate'] != null
                ? (data!['rewardExpiryDate'] as Timestamp).toDate()
                : null));
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Você ganhou $pointsPerAd pontos! Total: $newPoints')),
      );
    } catch (e) {
      debugPrint('Erro ao creditar pontos: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao creditar pontos. Tente novamente.')),
      );
    } finally {
      _isGranting = false;
    }
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anúncio não está pronto. Tente novamente.')),
      );
      _loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        debugPrint('Erro ao mostrar RewardedAd: $err');
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) async {
      await _onUserEarnedReward();
    });

    // limpa referência para forçar reload
    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentPoints = userProvider.rewardPoints;

    return Scaffold(
      appBar: AppBar(title: const Text('Ganhe pontos')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Seus pontos: $currentPoints',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Cada vídeo dá $pointsPerAd pontos.'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isAdLoaded ? _showRewardedAd : null,
              icon: const Icon(Icons.ondemand_video),
              label: const Text('Assistir anúncio e ganhar pontos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RewardStoreScreen()),
                );
              },
              child: const Text('Loja de Recompensa'),
            )
          ],
        ),
      ),
    );
  }
}
