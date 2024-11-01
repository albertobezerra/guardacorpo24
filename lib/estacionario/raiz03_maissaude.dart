import 'package:flutter/material.dart';
import '../maissaude/aso.dart';
import '../maissaude/clt.dart';
import '../maissaude/cnae.dart';
import '../maissaude/cnpj.dart';
import '../maissaude/epi.dart';
import '../maissaude/mapa_da_risco.dart';
import '../maissaude/nbrs.dart';
import '../maissaude/nho.dart';
import '../maissaude/os.dart';
import '../maissaude/ppp.dart';
import '../maissaude/primeiros_soc_rz.dart';
import '../maissaude/riscoamb.dart';
import '../maissaude/acidente.dart';
import '../maissaude/cid.dart';
import '../maissaude/cipa.dart';
import '../maissaude/datas.dart';
import '../maissaude/esocial.dart';
import '../maissaude/historia.dart';
import '../maissaude/incendio.dart';
import '../maissaude/sinalizacao.dart';
import '../maissaude/tecnico.dart';

class Raiz03Maissaude extends StatelessWidget {
  const Raiz03Maissaude({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
                  fontFamily: 'Segoe Bold',
                  color: Color(0xFF0C5422),
                  fontSize: 19,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapaDaRisco()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                        MaterialPageRoute(builder: (context) => const Cipa()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
                    height: 80,
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Bold',
                          fontSize: 16,
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
