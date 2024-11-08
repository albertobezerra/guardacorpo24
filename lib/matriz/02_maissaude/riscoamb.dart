import 'package:flutter/material.dart';

import '../../admob/banner_ad_widget.dart';

class Riscoamb extends StatelessWidget {
  const Riscoamb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Riscos Ambientais'.toUpperCase(),
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
            image: AssetImage('assets/images/riscos.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: const EdgeInsets.all(30),
                alignment: AlignmentDirectional.topStart,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Os agentes ambientais ou riscos ambientais são elementos ou substâncias presentes em diversos ambientes, que, acima dos limites de tolerância, podem ocasionar danos à saúde das pessoas.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Os agentes ambientais ou riscos ambientais são bastante debatidos e estudados na área de segurança e saúde do trabalho, principalmente na elaboração e implementação dos programas, como: Programa de Controle Médico de Saúde Ocupacional – PCMSO, Programa de Gerenciamento de Riscos – PGR, entre outros.\n\n',
                            ),
                            TextSpan(
                              text: 'Os riscos são:\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Riscos Físicos - ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'São diversas formas de energia a que possam estar expostos os trabalhadores, tais como: ruído, vibrações, pressões anormais, temperaturas extremas, radiações ionizantes, radiações não ionizantes, bem como o infra-som e o ultra-som.\n\n',
                            ),
                            TextSpan(
                              text: 'Riscos Químicos - ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'São as substâncias, compostos ou produtos que possam penetrar no organismo pela via respiratória, nas formas de poeiras, fumos, névoas, neblinas, gases ou vapores, ou que, pela natureza da atividade de exposição, possam ter contato ou ser absorvidos pelo organismo através da pele ou por ingestão;\n\n',
                            ),
                            TextSpan(
                              text: 'Riscos Biológicos - ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'São riscos oferecidos por diversos tipos de micro-organismos que possam infectar o indivíduo por vias respiratórias, contato com a pele ou ingestão. São as bactérias, fungos, bacilos, parasitas, protozoários, vírus, entre outros;\n\n',
                            ),
                            TextSpan(
                              text: 'Riscos de Acidentes - ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Arranjo físico inadequado, Máquinas e equipamentos sem proteção, Ferramentas inadequadas ou defeituosas, Iluminação inadequada, Eletricidade, Probabilidade de incêndio ou explosão, Armazenamento inadequado, Animais peçonhentos, Outras situações de risco que poderão contribuir para a ocorrência de acidentes;\n\n',
                            ),
                            TextSpan(
                              text: 'Riscos Ergonômicos - ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Esforço físico intenso, Levantamento e transporte manual de peso, Exigência de postura inadequada, Controle rígido de produtividade, Imposição de ritmos excessivos, Trabalho em turno e noturno, Jornadas de trabalho prolongadas, Monotonia e repetitividade, Outras situações causadoras de stress físico e/ou psíquico.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'No PGR esses riscos ambientais ganham cores: riscos físicos (verde), químicos (vermelho), biológico (marrom), acidente (azul) e ergonômico (amarelo)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
