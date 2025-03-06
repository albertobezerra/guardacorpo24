import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente_calculadora.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart'; // Adicione esta importação

class AcidenteRaiz extends StatefulWidget {
  const AcidenteRaiz({super.key});

  @override
  AcidenteRaizState createState() => AcidenteRaizState();
}

class AcidenteRaizState extends State<AcidenteRaiz> {
  late Future<Map<String, dynamic>> _subscriptionFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionFuture = _checkUserSubscription();
  }

  Future<Map<String, dynamic>> _checkUserSubscription() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {'isPremium': false};
    return SubscriptionService().getUserSubscriptionInfo(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double itemFontSize;
    double tamanhoBotaoLista;

    if (screenHeight < 800) {
      itemFontSize = 12;
      tamanhoBotaoLista = screenHeight * 0.10;
    } else if (screenHeight < 1000) {
      itemFontSize = 16;
      tamanhoBotaoLista = screenHeight * 0.10;
    } else {
      itemFontSize = 16;
      tamanhoBotaoLista = screenHeight * 0.12;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Acidentes'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/acidente.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 9),
              children: [
                // Botão "Sobre Acidentes" (não é premium)
                MaterialButton(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  onPressed: () {
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      const Acidente(),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/menu.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Sobre Acidentes'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: itemFontSize,
                        ),
                      ),
                    ),
                  ),
                ),

                // Botão "Calculadora de custo do Acidente" (exclusivo premium)
                FutureBuilder<Map<String, dynamic>>(
                  future: _subscriptionFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final isPremium = snapshot.data?['isPremium'] ?? false;

                    return MaterialButton(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 12),
                      onPressed: isPremium
                          ? () {
                              InterstitialAdManager.showInterstitialAd(
                                context,
                                const CalculadoraAcidente(),
                              );
                            }
                          : null, // Desabilita o botão
                      child: Stack(
                        children: [
                          // Imagem do botão com filtro cinza se não for premium
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: tamanhoBotaoLista,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: const ExactAssetImage(
                                    'assets/images/acidente.jpg'),
                                colorFilter: !isPremium
                                    ? const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      )
                                    : null,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Texto do botão
                          Positioned(
                            left: 12, // Alinha horizontalmente à esquerda
                            bottom: 8, // Alinha verticalmente à base
                            child: Text(
                              'Calculadora de custo do Acidente'.toUpperCase(),
                              style: TextStyle(
                                color: !isPremium ? Colors.grey : Colors.white,
                                fontFamily: 'Segoe Bold',
                                fontSize: itemFontSize,
                              ),
                            ),
                          ),
                          // Ícone de coroa se não for premium
                          if (!isPremium)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/crown.png', // Certifique-se de ter esta imagem
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
