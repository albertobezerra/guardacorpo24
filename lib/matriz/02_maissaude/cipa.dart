import 'package:flutter/material.dart';

import '../../admob/banner_ad_widget.dart';

class Cipa extends StatelessWidget {
  const Cipa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'CIPA',
            style: TextStyle(
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
            image: AssetImage('assets/images/treinamentos.jpg'),
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
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A CIPA (Comissão Interna de Prevenção de Acidentes) é composta por colaboradores que visam promover a saúde e a segurança no trabalho, prevenindo acidentes e doenças ocupacionais. A comissão é formada por representantes dos empregados e do empregador.\n\n'
                        'O principal objetivo da CIPA é observar e relatar condições de risco no ambiente de trabalho, além de solicitar medidas para reduzir, eliminar ou neutralizar esses riscos.\n\n'
                        'O mandato dos membros da CIPA dura um ano, com possibilidade de reeleição por mais um ano. O número de membros é determinado pelo dimensionamento previsto na NR 5, considerando o número de empregados e o CNAE da empresa.\n\n'
                        'O treinamento dos membros da CIPA pode ser ministrado por técnicos em segurança do trabalho, engenheiros de segurança, membros do SESMT, profissionais de entidades sindicais, ou outros com conhecimento nos temas listados na NR 5, item 5.32.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Atribuições da CIPA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Auxiliar na investigação de acidentes de trabalho;\n'
                        '• Sugerir medidas de prevenção e neutralização de riscos;\n'
                        '• Divulgar e zelar pela observância das normas de segurança;\n'
                        '• Incentivar a conscientização sobre a segurança no trabalho;\n'
                        '• Realizar inspeções periódicas e relatar riscos ao SESMT;\n'
                        '• Promover anualmente a Semana Interna de Prevenção de Acidentes (SIPAT);\n'
                        '• Participar de campanhas de prevenção à AIDS;\n'
                        '• Participar das reuniões mensais e extraordinárias;\n'
                        '• Registrar reuniões e compartilhar as atas com os membros;\n'
                        '• Discutir CATs emitidas e sugerir melhorias no ambiente de trabalho;\n'
                        '• Investigar acidentes e acompanhar medidas corretivas;\n'
                        '• Solicitar paralisação de atividades em caso de risco grave;\n'
                        '• Colaborar na implementação de programas de saúde no trabalho (PPRA, PCMSO);\n'
                        '• Elaborar o Mapa de Riscos da empresa junto ao SESMT.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Funções na CIPA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Presidente: Representante do empregador, indicado por ele.\n'
                        '• Vice-Presidente: Representante dos empregados, eleito.\n'
                        '• Secretário e Vice-Secretário: Escolhidos em comum acordo entre representantes eleitos e indicados.\n'
                        '• Membros da CIPA: Representantes eleitos pelos empregados e indicados pelo empregador.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
