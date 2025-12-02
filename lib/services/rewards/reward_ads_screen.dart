import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_store_screen.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';

class RewardAdsScreen extends StatefulWidget {
  const RewardAdsScreen({super.key});

  @override
  State<RewardAdsScreen> createState() => _RewardAdsScreenState();
}

class _RewardAdsScreenState extends State<RewardAdsScreen>
    with SingleTickerProviderStateMixin {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  bool _isGranting = false;
  static const int pointsPerAd = 4;

  late AnimationController _controller;
  late Animation<Color?> _buttonGlow;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _buttonGlow = ColorTween(
      begin: const Color.fromARGB(255, 0, 104, 55),
      end: Colors.green[700],
    ).animate(_controller);
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-7979689703488774/6389624112',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (err) => setState(() => _isAdLoaded = false),
      ),
    );
  }

  Future<void> _onUserEarnedReward() async {
    if (_isGranting) return;
    _isGranting = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faça login para ganhar pontos.')));
      _isGranting = false;
      return;
    }

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.update({'rewardPoints': FieldValue.increment(pointsPerAd)});

    final data = (await userDoc.get()).data();
    final newPoints = data?['rewardPoints'] ?? 0;

    if (!mounted) {
      _isGranting = false;
      return;
    }

    Provider.of<UserProvider>(context, listen: false).updateReward(
        points: newPoints, expiry: data?['rewardExpiryDate']?.toDate());

    if (!mounted) {
      _isGranting = false;
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('🎉 Ganhou $pointsPerAd pontos! Total: $newPoints')));

    _isGranting = false;
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Anúncio não pronto.')));
      _loadRewardedAd();
      return;
    }

    _rewardedAd!.show(onUserEarnedReward: (_, __) => _onUserEarnedReward());
    _rewardedAd = null;
    _isAdLoaded = false;
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GANHAR PONTOS'.toUpperCase(),
          style: const TextStyle(
              fontFamily: 'Segoe Bold', color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ganhe pontos assistindo anúncios'.toUpperCase(),
              style: const TextStyle(
                  fontFamily: 'Segoe Bold',
                  color: Color.fromARGB(255, 0, 104, 55),
                  fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cada vídeo vale 4 pontos. Troque por benefícios como dias sem anúncios ou premium.',
              style: TextStyle(
                  fontFamily: 'Segoe', color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Center(
              child: AnimatedBuilder(
                animation: _buttonGlow,
                builder: (_, __) => ElevatedButton.icon(
                  onPressed: _isAdLoaded ? _showRewardedAd : null,
                  icon: const Icon(Icons.play_circle, color: Colors.white),
                  label: const Text('Assistir e Ganhar',
                      style: TextStyle(
                          fontFamily: 'Segoe Bold', color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _buttonGlow.value,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Pontos atuais: ${userProvider.rewardPoints}',
                style: const TextStyle(
                    fontFamily: 'Segoe Bold',
                    color: Color.fromARGB(255, 0, 104, 55),
                    fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RewardStoreScreen())),
              icon: const Icon(Icons.store, color: Colors.white),
              label: const Text('Loja de Recompensas',
                  style:
                      TextStyle(fontFamily: 'Segoe Bold', color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 104, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
