import 'package:flutter/material.dart';
import '../../admob/interstitial_ad_manager.dart';
import '../02_maissaude/aso.dart';
import '../02_maissaude/clt.dart';
import '../02_maissaude/cnae.dart';
import '../02_maissaude/cnpj.dart';
import '../02_maissaude/epi.dart';
import '../02_maissaude/mapa_da_risco.dart';
import '../02_maissaude/nbrs.dart';
import '../02_maissaude/nho.dart';
import '../02_maissaude/os.dart';
import '../02_maissaude/ppp.dart';
import '../02_maissaude/primeiros_soc_rz.dart';
import '../02_maissaude/riscoamb.dart';
import '../02_maissaude/acidente.dart';
import '../02_maissaude/cid.dart';
import '../02_maissaude/cipa.dart';
import '../02_maissaude/datas.dart';
import '../02_maissaude/esocial.dart';
import '../02_maissaude/historia.dart';
import '../02_maissaude/incendio.dart';
import '../02_maissaude/sinalizacao.dart';
import '../02_maissaude/tecnico.dart';

class Raiz03Maissaude extends StatefulWidget {
  const Raiz03Maissaude({super.key});

  @override
  State<Raiz03Maissaude> createState() => _Raiz03MaissaudeState();
}

class _Raiz03MaissaudeState extends State<Raiz03Maissaude> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

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
                // _listadebtnssecundarios(),
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
                        image: ExactAssetImage('assets/images/mapa.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Mapa de Risco'.toUpperCase(),
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
                      const Cipa(),
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
                        image:
                            ExactAssetImage('assets/images/treinamentos.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Cipa'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrimeirosSocRz()));
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
                        'Primeiros Socorros'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Sinalizacao()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/sinalizacao.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Sinalização de Segurança'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Datas()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/datas.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Datas Importantes'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Tecnico()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/tecnico.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Técnico em tst'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Historia()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/historia.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'História da Segurança do Trabalho'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Nbrs()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/nbr.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'NBrs Relevantes'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Nho()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/normas.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'nho'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Epi()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/epi.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Tipos de EPi'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Os()));
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
                        'O.s'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Ppp()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/ppp.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'P.P.P'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Incendio()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/incendio.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Incêndio'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Acidente()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/acidente.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Acidentes de Trabalho'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Riscoamb()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/riscos.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Riscos Ambientais'.toUpperCase(),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Esocial()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/esocial.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'E-Social'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Clt()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/clt.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'C.L.T'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Cid()));
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
                        'C.I.D'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Aso()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/aso.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'A.S.O'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Cnae()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: tamanhoBotaoLista,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/cnae.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: AlignmentDirectional.bottomStart,
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Text(
                        'Consulta de Cnae'.toUpperCase(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Cnpj()));
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
                        'Consulta de CNPJ'.toUpperCase(),
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
