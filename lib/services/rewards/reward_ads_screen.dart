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
  bool _isLoadingAd = false;
  bool _isGranting = false;
  int _loadAttempts = 0;
  static const int maxLoadAttempts = 3;
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
    if (_isLoadingAd) return; // Evita múltiplas chamadas simultâneas

    setState(() {
      _isLoadingAd = true;
      _isAdLoaded = false;
    });

    debugPrint(
        'Tentando carregar anúncio (tentativa ${_loadAttempts + 1}/$maxLoadAttempts)...');

    RewardedAd.load(
      adUnitId: 'ca-app-pub-7979689703488774/6389624112',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Anúncio carregado com sucesso');
          if (!mounted) return;

          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
            _isLoadingAd = false;
            _loadAttempts = 0; // Reset contador de tentativas
          });

          // Configura callback de quando o anúncio for fechado/dispensado
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('Anúncio fechado, carregando próximo...');
              ad.dispose();
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Falha ao mostrar anúncio: $error');
              ad.dispose();
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint(
              '❌ Falha ao carregar anúncio: ${error.message} (código ${error.code})');
          if (!mounted) return;

          setState(() {
            _isLoadingAd = false;
            _isAdLoaded = false;
            _loadAttempts++;
          });

          // Retry automático com backoff exponencial
          if (_loadAttempts < maxLoadAttempts) {
            final delaySeconds = _loadAttempts * 2; // 2s, 4s, 6s
            debugPrint('Tentando novamente em ${delaySeconds}s...');
            Future.delayed(Duration(seconds: delaySeconds), () {
              if (mounted) _loadRewardedAd();
            });
          } else {
            // Após 3 tentativas, permite retry manual
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Não foi possível carregar o anúncio. Tente novamente em alguns instantes.'),
                  duration: Duration(seconds: 4),
                ),
              );
            }
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Faça login para ganhar pontos.')));
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

      if (!mounted) {
        _isGranting = false;
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('🎉 Ganhou $pointsPerAd pontos! Total: $newPoints'),
          backgroundColor: Colors.green));
    } catch (e) {
      debugPrint('Erro ao conceder pontos: $e');
      if (!mounted) {
        _isGranting = false;
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Erro ao conceder pontos. Tente novamente.')));
    } finally {
      _isGranting = false;
    }
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aguarde, carregando anúncio...')));

      // Força reload se não estiver carregando
      if (!_isLoadingAd) {
        _loadAttempts = 0; // Reset para tentar novamente
        _loadRewardedAd();
      }
      return;
    }

    _rewardedAd!.show(onUserEarnedReward: (_, __) => _onUserEarnedReward());

    // Limpa referência imediatamente após chamar show
    setState(() {
      _rewardedAd = null;
      _isAdLoaded = false;
    });
  }

  void _retryManually() {
    _loadAttempts = 0; // Reset contador
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

            // Botão principal com estados visuais
            Center(
              child: AnimatedBuilder(
                animation: _buttonGlow,
                builder: (_, __) {
                  if (_isLoadingAd) {
                    // Estado: carregando
                    return ElevatedButton.icon(
                      onPressed: null,
                      icon: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      label: const Text('Carregando...',
                          style: TextStyle(
                              fontFamily: 'Segoe Bold', color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    );
                  } else if (_isAdLoaded) {
                    // Estado: pronto para assistir
                    return ElevatedButton.icon(
                      onPressed: _showRewardedAd,
                      icon: const Icon(Icons.play_circle,
                          color: Colors.white, size: 28),
                      label: const Text('Assistir e Ganhar',
                          style: TextStyle(
                              fontFamily: 'Segoe Bold',
                              color: Colors.white,
                              fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonGlow.value,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        elevation: 4,
                      ),
                    );
                  } else {
                    // Estado: erro/falha
                    return ElevatedButton.icon(
                      onPressed: _retryManually,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Tentar Novamente',
                          style: TextStyle(
                              fontFamily: 'Segoe Bold', color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    );
                  }
                },
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
