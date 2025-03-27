import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_epi/epi_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_incendio/incendio_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/view_inspecoes.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapa_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_ordem_de_servico/os_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_analise_ergonomica/aet_raiz.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/premium/premium_button.dart';
import '../../services/admob/conf/interstitial_ad_manager.dart';
import '../02_maissaude/aso.dart';
import '../02_maissaude/clt.dart';
import '../02_maissaude/cnae.dart';
import '../02_maissaude/cnpj.dart';
import '../02_maissaude/nbrs.dart';
import '../02_maissaude/nho_raiz.dart';
import '../02_maissaude/ppp.dart';
import '../02_maissaude/primeiros_soc_raiz.dart';
import '../02_maissaude/riscoamb.dart';
import '../02_maissaude/cid.dart';
import '../02_maissaude/cipa.dart';
import '../02_maissaude/datas.dart';
import '../02_maissaude/esocial.dart';
import '../02_maissaude/historia.dart';
import '../02_maissaude/sinalizacao.dart';
import '../02_maissaude/tecnico.dart';

class Raiz03Maissaude extends StatefulWidget {
  const Raiz03Maissaude({super.key});

  @override
  State<Raiz03Maissaude> createState() => _Raiz03MaissaudeState();
}

class _Raiz03MaissaudeState extends State<Raiz03Maissaude> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Defina os tamanhos dinamicamente com base na altura da tela
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
                _buildMaterialButton(
                  context,
                  'assets/images/acidente.jpg',
                  'Acidentes',
                  const AcidenteRaiz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/cid.jpg',
                  'Análise Ergonômica do Trabalho',
                  const AETModule(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/aso.jpg',
                  'A.S.O',
                  const Aso(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                PremiumButton(
                  buttonText: 'Inspeção',
                  imagePath: 'assets/images/inspecao.jpg',
                  destinationScreen: const ViewInspecoes(),
                  buttonHeight: tamanhoBotaoLista,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/cid.jpg',
                  'C.I.D',
                  const Cid(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/clt.jpg',
                  'C.L.T',
                  const Clt(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/treinamentos.jpg',
                  'Cipa',
                  const Cipa(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/cnae.jpg',
                  'Consulta de Cnae',
                  const Cnae(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/menu.jpg',
                  'Consulta de CNPJ',
                  const Cnpj(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/datas.jpg',
                  'Datas Importantes',
                  const Datas(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/esocial.jpg',
                  'E-Social',
                  const Esocial(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/historia.jpg',
                  'História da Segurança do Trabalho',
                  const Historia(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/incendio4.jpg',
                  'Incêndio',
                  const IncendioRaiz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/mapa.jpg',
                  'Mapa de Risco',
                  const MapaRaiz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/nbr.jpg',
                  'NBrs Relevantes',
                  const Nbrs(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/normas.jpg',
                  'Normas de Higiene Ocupacional',
                  const Nho(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/os.jpg',
                  'O.s',
                  const OrdemRaiz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/ppp.jpg',
                  'P.P.P',
                  const Ppp(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/cid.jpg',
                  'Primeiros Socorros',
                  const PrimeirosSocRz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/riscos.jpg',
                  'Riscos Ambientais',
                  const Riscoamb(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/sinalizacao.jpg',
                  'Sinalização de Segurança',
                  const Sinalizacao(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/tecnico.jpg',
                  'Técnico em tst',
                  const Tecnico(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
                _buildMaterialButton(
                  context,
                  'assets/images/epi.jpg',
                  'E.P.I',
                  const EpiRaiz(),
                  tamanhoBotaoLista,
                  itemFontSize,
                ),
              ],
            ),
          ),
        ],
      ),
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
    final user = FirebaseAuth.instance.currentUser;
    final subscriptionService = SubscriptionService();

    return FutureBuilder<Map<String, dynamic>>(
      future: user != null
          ? subscriptionService.getUserSubscriptionInfo(user.uid)
          : Future.value({'isPremium': false, 'planType': ''}),
      builder: (context, snapshot) {
        final isPremium = snapshot.data?['isPremium'] ?? false;
        final planType = snapshot.data?['planType'] ?? '';

        return MaterialButton(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          onPressed: () async {
            if (!isPremium && planType != 'ad_free') {
              InterstitialAdManager.showInterstitialAd(
                context,
                destinationScreen,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationScreen),
              );
            }
          },
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
      },
    );
  }
}
