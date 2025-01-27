import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_01_conteudo/aet_conteudo.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/view_reports.dart';

class AETModule extends StatefulWidget {
  const AETModule({super.key});

  @override
  State<AETModule> createState() => _AETModuleState();
}

class _AETModuleState extends State<AETModule> {
  @override
  void initState() {
    super.initState();
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
            'Análise Ergonômica do Trabalho (AET)'.toUpperCase(),
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
            image: AssetImage('assets/images/aet.jpg'),
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
                MaterialButton(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  onPressed: () {
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      const AetConteudo(),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/aet2.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Sobre a AET'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: itemFontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildPremiumButton(
                  context,
                  label: 'Relatórios',
                  onPressed: () {
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      const ViewReports(),
                    );
                  },
                  fontSize: itemFontSize,
                  height: tamanhoBotaoLista,
                  image: 'assets/images/relatorios.jpg',
                  crownIcon: 'assets/images/crown.png',
                ),
                _buildDisabledPremiumButton(
                  context,
                  label: 'Checklists (Em breve)',
                  fontSize: itemFontSize,
                  height: tamanhoBotaoLista,
                  image: 'assets/images/checklist.jpg',
                  crownIcon: 'assets/images/crown.png',
                ),
                _buildDisabledPremiumButton(
                  context,
                  label: 'Questionários (Em breve)',
                  fontSize: itemFontSize,
                  height: tamanhoBotaoLista,
                  image: 'assets/images/questionarios.jpg',
                  crownIcon: 'assets/images/crown.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumButton(BuildContext context,
      {required String label,
      required VoidCallback onPressed,
      required double fontSize,
      required double height,
      required String image,
      required String crownIcon}) {
    return MaterialButton(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      onPressed: onPressed,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
              image: DecorationImage(
                image: ExactAssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: AlignmentDirectional.bottomStart,
              margin: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Segoe Bold',
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                crownIcon,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledPremiumButton(BuildContext context,
      {required String label,
      required double fontSize,
      required double height,
      required String image,
      required String crownIcon}) {
    return MaterialButton(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      onPressed: null, // Botão desabilitado
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(18),
              ),
              image: DecorationImage(
                image: ExactAssetImage(image),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
              ),
            ),
            child: Container(
              alignment: AlignmentDirectional.bottomStart,
              margin: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontFamily: 'Segoe Bold',
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                crownIcon,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
