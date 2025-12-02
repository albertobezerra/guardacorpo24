import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget_principal.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_epi/epi_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_incendio/incendio_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/view_inspecoes.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapa_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_ordem_de_servico/os_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_analise_ergonomica/aet_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/cnpj2.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/pgr.dart';
import 'package:guarda_corpo_2024/services/premium/premium_button.dart';
import '../../services/admob/conf/interstitial_ad_manager.dart';
import '../02_maissaude/aso.dart';
import '../02_maissaude/clt.dart';
import '../02_maissaude/cnae.dart';
import '../02_maissaude/nbrs.dart';
import '../02_maissaude/nho_raiz.dart';
import '../02_maissaude/ppp.dart';
import '../02_maissaude/primeiros_soc_raiz.dart';
import '../02_maissaude/riscoamb.dart';
//import '../02_maissaude/cid.dart';
import '../02_maissaude/cipa.dart';
import '../02_maissaude/datas.dart';
import '../02_maissaude/esocial.dart';
import '../02_maissaude/historia.dart';
import '../02_maissaude/sinalizacao.dart';
import '../02_maissaude/tecnico.dart';
import 'package:provider/provider.dart';
import '../../services/provider/userProvider.dart';

class Raiz03Maissaude extends StatelessWidget {
  const Raiz03Maissaude({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Função para decidir em quais índices entram CTAs
    List<int> getCtaPositions(int totalItems) {
      if (totalItems <= 10) {
        return [];
      } else if (totalItems <= 20) {
        return [totalItems ~/ 2];
      } else if (totalItems <= 50) {
        return [
          (totalItems * 0.3).round(),
          (totalItems * 0.7).round(),
        ];
      } else {
        return [
          (totalItems * 0.25).round(),
          (totalItems * 0.5).round(),
          (totalItems * 0.75).round(),
        ];
      }
    }

    double headerFontSize;
    double itemFontSize;
    double tamanhoBotaoLista;

    if (screenHeight < 800) {
      headerFontSize = 14;
      itemFontSize = 12;
      tamanhoBotaoLista = 60;
    } else if (screenHeight < 1000) {
      headerFontSize = 16;
      itemFontSize = 16;
      tamanhoBotaoLista = 80;
    } else {
      headerFontSize = 19;
      itemFontSize = 16;
      tamanhoBotaoLista = 80;
    }

    // Lista de itens do menu (exceto Inspeção, que é PremiumButton)
    final List<Map<String, dynamic>> itens = [
      {
        'image': 'assets/images/acidente.jpg',
        'label': 'Acidentes',
        'screen': const AcidenteRaiz(),
      },
      {
        'image': 'assets/images/cid.jpg',
        'label': 'Análise Ergonômica do Trabalho',
        'screen': const AETModule(),
      },
      {
        'image': 'assets/images/aso.jpg',
        'label': 'A.S.O',
        'screen': const Aso(),
      },
      {
        'image': 'assets/images/clt.jpg',
        'label': 'C.L.T',
        'screen': const Clt(),
      },
      {
        'image': 'assets/images/treinamentos.jpg',
        'label': 'Cipa',
        'screen': const Cipa(),
      },
      {
        'image': 'assets/images/cnae.jpg',
        'label': 'Consulta de Cnae',
        'screen': const Cnae(),
      },
      {
        'image': 'assets/images/menu.jpg',
        'label': 'Consulta de CNPJ',
        'screen': const Cnpj2(),
      },
      {
        'image': 'assets/images/datas.jpg',
        'label': 'Datas Importantes',
        'screen': const Datas(),
      },
      {
        'image': 'assets/images/esocial.jpg',
        'label': 'E-Social',
        'screen': const Esocial(),
      },
      {
        'image': 'assets/images/historia.jpg',
        'label': 'História da Segurança do Trabalho',
        'screen': const Historia(),
      },
      {
        'image': 'assets/images/incendio4.jpg',
        'label': 'Incêndio',
        'screen': const IncendioRaiz(),
      },
      // Inspeção vem depois como PremiumButton
      {
        'image': 'assets/images/mapa.jpg',
        'label': 'Mapa de Risco',
        'screen': const MapaRaiz(),
      },
      {
        'image': 'assets/images/nbr.jpg',
        'label': 'NBrs Relevantes',
        'screen': const Nbrs(),
      },
      {
        'image': 'assets/images/normas.jpg',
        'label': 'Normas de Higiene Ocupacional',
        'screen': const Nho(),
      },
      {
        'image': 'assets/images/os.jpg',
        'label': 'O.s',
        'screen': const OrdemRaiz(),
      },
      {
        'image': 'assets/images/ppp.jpg',
        'label': 'P.P.P',
        'screen': const Ppp(),
      },
      {
        'image': 'assets/images/treinamentos.jpg',
        'label': 'PPRA x PGR',
        'screen': const Pgr(),
      },
      {
        'image': 'assets/images/cid.jpg',
        'label': 'Primeiros Socorros',
        'screen': const PrimeirosSocRz(),
      },
      {
        'image': 'assets/images/riscos.jpg',
        'label': 'Riscos Ambientais',
        'screen': const Riscoamb(),
      },
      {
        'image': 'assets/images/sinalizacao.jpg',
        'label': 'Sinalização de Segurança',
        'screen': const Sinalizacao(),
      },
      {
        'image': 'assets/images/tecnico.jpg',
        'label': 'Técnico em tst',
        'screen': const Tecnico(),
      },
      {
        'image': 'assets/images/epi.jpg',
        'label': 'E.P.I',
        'screen': const EpiRaiz(),
      },
    ];

    final ctaPositions = getCtaPositions(itens.length);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        debugPrint(
            'Raiz03Maissaude - hasActiveSubscription: ${userProvider.hasActiveSubscription()}, hasPremiumPlan: ${userProvider.hasPremiumPlan()}');

        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: RichText(
                  text: TextSpan(
                    text: 'Mais saúde e segurança'.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Segoe Bold',
                      color: const Color(0xFF0C5422),
                      fontSize: headerFontSize,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 7,
                child: ListView(
                  padding: const EdgeInsets.only(top: 9),
                  children: [
                    // Gera dinamicamente: CTA + botões
                    for (int i = 0; i < itens.length; i++) ...[
                      if (ctaPositions.contains(i))
                        const RewardCTAWidgetPrincipal(),
                      _buildMaterialButton(
                        context,
                        itens[i]['image'] as String,
                        itens[i]['label'] as String,
                        itens[i]['screen'] as Widget,
                        tamanhoBotaoLista,
                        itemFontSize,
                      ),
                    ],

                    // Mantém o PremiumButton de Inspeção
                    PremiumButton(
                      buttonText: 'Inspeção',
                      imagePath: 'assets/images/inspecao.jpg',
                      destinationScreen: const ViewInspecoes(),
                      buttonHeight: tamanhoBotaoLista,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMaterialButton(
    BuildContext context,
    String imagePath,
    String label,
    Widget destinationScreen,
    double height,
    double fontSize,
  ) {
    return MaterialButton(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      onPressed: () =>
          InterstitialAdManager.showInterstitialAd(context, destinationScreen),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: ExactAssetImage(imagePath),
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
    );
  }
}
