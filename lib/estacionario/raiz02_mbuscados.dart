import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/maisbuscados/consultaCa/consulta_ca.dart';
import 'package:guarda_corpo_2024/maisbuscados/dds/dds_raiz.dart';
import 'package:guarda_corpo_2024/maisbuscados/nrs/nrs_raiz.dart';
import 'package:guarda_corpo_2024/maisbuscados/treinamentos/treinamento_raiz.dart';

class Raiz02Mbuscados extends StatelessWidget {
  const Raiz02Mbuscados({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
              text: 'Mais Buscados'.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Segoe Bold',
                color: Color(0xFF0C5422),
                fontSize: 19,
              ),
            )),
            const SizedBox(height: 9),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        MaterialButton(
                          padding: const EdgeInsets.only(left: 0, right: 8),
                          onPressed: () async {
                            // if (!interstitialAd.isAvailable)
                            //   await interstitialAd.load();
                            // if (interstitialAd.isAvailable) {
                            //   await interstitialAd.show();
                            // }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NrsRaiz()));
                          },
                          child: Container(
                            width: 320,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image:
                                    ExactAssetImage('assets/images/normas.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: AlignmentDirectional.bottomStart,
                              margin:
                                  const EdgeInsets.only(left: 12, bottom: 8),
                              child: Text(
                                'Normas Regulamentadoras'.toUpperCase(),
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
                          padding: const EdgeInsets.only(left: 0, right: 8),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ConsultaCa()));
                          },
                          child: Container(
                            width: 320,
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
                              margin:
                                  const EdgeInsets.only(left: 12, bottom: 8),
                              child: Text(
                                'Consulta de c.a'.toUpperCase(),
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
                          padding: const EdgeInsets.only(left: 0, right: 8),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TreinamentoRaiz()));
                          },
                          child: Container(
                            width: 320,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: ExactAssetImage(
                                    'assets/images/treinamentos.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: AlignmentDirectional.bottomStart,
                              margin:
                                  const EdgeInsets.only(left: 12, bottom: 8),
                              child: Text(
                                'Treinamentos'.toUpperCase(),
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
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DdsRaiz()));
                          },
                          child: Container(
                            width: 320,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              image: DecorationImage(
                                image: ExactAssetImage('assets/images/dds.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              alignment: AlignmentDirectional.bottomStart,
                              margin:
                                  const EdgeInsets.only(left: 12, bottom: 8),
                              child: Text(
                                'temas de d.d.s'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Segoe Bold',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
