import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isLoadingAd = false;
  bool _isGranting = false;
  int _loadAttempts = 0;
  static const int maxLoadAttempts = 3;
  static const int pointsPerAd = 4;
  final Color primaryColor = const Color(0xFF006837);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _loadRewardedAd() {
    if (_isLoadingAd) return;

    setState(() {
      _isLoadingAd = true;
      _isAdLoaded = false;
    });

    RewardedAd.load(
      adUnitId: 'ca-app-pub-7979689703488774/6389624112',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
            _isLoadingAd = false;
            _loadAttempts = 0;
          });

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (!mounted) return;
          setState(() {
            _isLoadingAd = false;
            _isAdLoaded = false;
            _loadAttempts++;
          });
          if (_loadAttempts < maxLoadAttempts) {
            Future.delayed(Duration(seconds: _loadAttempts * 2), () {
              if (mounted) _loadRewardedAd();
            });
          }
        },
      ),
    );
  }

  Future<void> _onUserEarnedReward() async {
    if (_isGranting) return;
    _isGranting = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Faça login para ganhar pontos.')));
      }
      _isGranting = false;
      return;
    }

    try {
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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('🎉 Ganhou $pointsPerAd pontos! Total: $newPoints'),
          backgroundColor: primaryColor));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Erro ao conceder pontos. Tente novamente.')));
      }
    } finally {
      _isGranting = false;
    }
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aguarde, carregando anúncio...')));
      if (!_isLoadingAd) {
        _loadAttempts = 0;
        _loadRewardedAd();
      }
      return;
    }
    _rewardedAd!.show(onUserEarnedReward: (_, __) => _onUserEarnedReward());
    setState(() {
      _rewardedAd = null;
      _isAdLoaded = false;
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'GANHAR PONTOS',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Placar de Pontos
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  Text("SEUS PONTOS",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    "${userProvider.rewardPoints}",
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          "Troque por Premium na Loja",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[800]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const Spacer(),

            // Botão Gigante Pulsante
            ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: _isAdLoaded ? _showRewardedAd : null,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isAdLoaded
                          ? [primaryColor, Color(0xFF004D29)]
                          : [Colors.grey.shade300, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isAdLoaded ? primaryColor : Colors.grey)
                            .withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoadingAd)
                        const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      else
                        Icon(
                          _isAdLoaded
                              ? Icons.play_arrow_rounded
                              : Icons.lock_clock,
                          size: 60,
                          color: Colors.white,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoadingAd
                            ? "Carregando..."
                            : (_isAdLoaded
                                ? "ASSISTIR\n+4 Pontos"
                                : "Carregando..."),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Botão Loja
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RewardStoreScreen())),
                icon: Icon(Icons.shopping_bag_outlined, color: primaryColor),
                label: Text(
                  "ABRIR LOJA DE PONTOS",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: primaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
