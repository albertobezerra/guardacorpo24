import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapa_da_risco.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapaexemplo.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';

class MapaRaiz extends StatelessWidget {
  const MapaRaiz({super.key});

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
            'Mapa de Risco'.toUpperCase(),
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
            image: AssetImage('assets/images/mapa.jpg'),
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
                      const MapaDaRisco(),
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
                        image: ExactAssetImage('assets/images/mapa01.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Sobre Mapa de Risco'.toUpperCase(),
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
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  onPressed: () {
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      const Mapaexemplo(),
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
                        image: ExactAssetImage('assets/images/mapa02.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Mapa de risco'.toUpperCase(),
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
    );
  }
}
