import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Riscoamb extends StatelessWidget {
  const Riscoamb({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'RISCOS AMBIENTAIS',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const _RiscoContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _RiscoContent extends StatelessWidget {
  const _RiscoContent();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Os agentes ou riscos ambientais são elementos ou substâncias presentes nos ambientes de trabalho que, acima dos limites de tolerância, '
      'podem causar danos à saúde dos trabalhadores.\n\n'
      'Esses riscos são a base de programas como o PGR e o PCMSO, pois orientam as medidas de prevenção e controle.\n\n'
      'Riscos físicos: diversas formas de energia, como ruído, vibrações, pressões anormais, temperaturas extremas, radiações ionizantes e não ionizantes, '
      'infra-som e ultra-som.\n\n'
      'Riscos químicos: substâncias, compostos ou produtos que possam penetrar no organismo pela via respiratória (poeiras, fumos, névoas, neblinas, gases ou vapores) '
      'ou por contato com a pele e ingestão.\n\n'
      'Riscos biológicos: micro-organismos capazes de causar doenças, como bactérias, fungos, bacilos, parasitas, protozoários e vírus.\n\n'
      'Riscos de acidentes: arranjo físico inadequado, máquinas e equipamentos sem proteção, ferramentas defeituosas, iluminação inadequada, eletricidade, '
      'probabilidade de incêndio ou explosão, armazenamento inadequado, presença de animais peçonhentos e outras situações que favorecem acidentes.\n\n'
      'Riscos ergonômicos: esforço físico intenso, levantamento e transporte manual de cargas, posturas inadequadas, ritmos excessivos, trabalho em turnos e noturno, '
      'jornadas prolongadas, monotonia, repetitividade e demais fatores que geram estresse físico e/ou psíquico.\n\n'
      'No PGR e nos mapas de risco, esses grupos costumam ser representados por cores: físicos (verde), químicos (vermelho), biológicos (marrom), '
      'acidentes (azul) e ergonômicos (amarelo).',
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
    );
  }
}
