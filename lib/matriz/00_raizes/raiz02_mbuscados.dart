import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/02_consultaCa/consulta_ca.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/04_dds/00_dds_raiz.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/03_treinamentos/00_treinamento_raiz.dart';
import '../../services/admob/conf/interstitial_ad_manager.dart';
import '../01_maisbuscados/01_nrs/00_raizdasnrs.dart';
import 'package:provider/provider.dart';
import '../../services/provider/userProvider.dart';

class Raiz02Mbuscados extends StatefulWidget {
  const Raiz02Mbuscados({super.key});

  @override
  State<Raiz02Mbuscados> createState() => _Raiz02MbuscadosState();
}

class _Raiz02MbuscadosState extends State<Raiz02Mbuscados> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        debugPrint(
            'Raiz02Mbuscados - hasActiveSubscription: ${userProvider.hasActiveSubscription()}');

        double screenHeight = MediaQuery.of(context).size.height;
        double headerFontSize;
        double itemFontSize;
        double imagemBotao;

        if (screenHeight < 800) {
          headerFontSize = 14;
          itemFontSize = 12;
          imagemBotao = 250;
        } else if (screenHeight < 1000) {
          headerFontSize = 16;
          itemFontSize = 16;
          imagemBotao = 280;
        } else {
          headerFontSize = 19;
          itemFontSize = 16;
          imagemBotao = 320;
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Mais Buscados'.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Segoe Bold',
                      color: const Color(0xFF0C5422),
                      fontSize: headerFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            MaterialButton(
                              padding:
                                  const EdgeInsets.only(left: 0, right: 12),
                              onPressed: () =>
                                  InterstitialAdManager.showInterstitialAd(
                                      context, const NrsRaiz()),
                              child: Container(
                                width: imagemBotao,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'assets/images/normas.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  alignment: AlignmentDirectional.bottomStart,
                                  margin: const EdgeInsets.only(
                                      left: 12, bottom: 8),
                                  child: Text(
                                    'Normas Regulamentadoras'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Segoe Bold',
                                      fontSize: itemFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              padding: const EdgeInsets.only(left: 0, right: 8),
                              onPressed: () =>
                                  InterstitialAdManager.showInterstitialAd(
                                      context, const ConsultaCa()),
                              child: Container(
                                width: imagemBotao,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'assets/images/epi.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  alignment: AlignmentDirectional.bottomStart,
                                  margin: const EdgeInsets.only(
                                      left: 12, bottom: 8),
                                  child: Text(
                                    'Consulta de c.a'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Segoe Bold',
                                      fontSize: itemFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              padding: const EdgeInsets.only(left: 0, right: 8),
                              onPressed: () =>
                                  InterstitialAdManager.showInterstitialAd(
                                      context, const TreinamentoRaiz()),
                              child: Container(
                                width: imagemBotao,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'assets/images/treinamentos.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  alignment: AlignmentDirectional.bottomStart,
                                  margin: const EdgeInsets.only(
                                      left: 12, bottom: 8),
                                  child: Text(
                                    'Treinamentos'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Segoe Bold',
                                      fontSize: itemFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              onPressed: () =>
                                  InterstitialAdManager.showInterstitialAd(
                                      context, const DdsRaiz()),
                              child: Container(
                                width: imagemBotao,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                  image: DecorationImage(
                                    image: ExactAssetImage(
                                        'assets/images/dds.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  alignment: AlignmentDirectional.bottomStart,
                                  margin: const EdgeInsets.only(
                                      left: 12, bottom: 8),
                                  child: Text(
                                    'temas de d.d.s'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Segoe Bold',
                                      fontSize: itemFontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
