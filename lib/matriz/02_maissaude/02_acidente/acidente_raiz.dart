import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente_calculadora.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/services/premium/premium_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class AcidenteRaiz extends StatelessWidget {
  const AcidenteRaiz({super.key});

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
            onPressed: () {
              Navigator.of(context).pop();
            },
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
                FutureBuilder<Map<String, dynamic>>(
                  future: _checkUserStatus(),
                  builder: (context, snapshot) {
                    final isPremium = snapshot.data?['isPremium'] ?? false;
                    final planType = snapshot.data?['planType'] ?? '';

                    return MaterialButton(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 12),
                      onPressed: () async {
                        if (!isPremium && planType != 'ad_free') {
                          InterstitialAdManager.showInterstitialAd(
                            context,
                            const Acidente(),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Acidente()),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: tamanhoBotaoLista,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
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
                    );
                  },
                ),
                // Botão "Calculadora de custo do Acidente" (exclusivo premium)
                PremiumButton(
                  buttonText: 'Calculadora de custo do Acidente',
                  imagePath: 'assets/images/acidente.jpg', // Caminho da imagem
                  destinationScreen:
                      const CalculadoraAcidente(), // Tela premium
                  buttonHeight: tamanhoBotaoLista,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'isPremium': false, 'planType': ''};
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);
    return {
      'isPremium': subscriptionInfo['isPremium'] ?? false,
      'planType': subscriptionInfo['planType'] ?? '',
    };
  }
}
