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
    // Iniciar qualquer configuração ou carregamento necessário
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Defina os tamanhos dinamicamente com base na altura da tela
    double itemFontSize;
    double tamanhoBotaoLista;

    if (screenHeight < 800) {
      itemFontSize = 12;
      tamanhoBotaoLista = screenHeight * 0.10; // Ajuste proporcional
    } else if (screenHeight < 1000) {
      itemFontSize = 16;
      tamanhoBotaoLista = screenHeight * 0.10; // Ajuste proporcional
    } else {
      itemFontSize = 16;
      tamanhoBotaoLista = screenHeight * 0.12; // Ajuste proporcional
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
            image: AssetImage('assets/images/cid.jpg'),
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
                        image: ExactAssetImage('assets/images/cid.jpg'),
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
                MaterialButton(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  onPressed: () {
                    // Navegar para a seção de relatórios
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      const ViewReports(),
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
                        image: ExactAssetImage('assets/images/cid.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Relatórios'.toUpperCase(),
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
                    // Navegar para a seção de checklists
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/cid.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Checklists'.toUpperCase(),
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
                    // Navegar para a seção de questionários
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/cid.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Questionários'.toUpperCase(),
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
