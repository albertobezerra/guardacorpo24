import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/mapaexemplo.dart';

import '../../admob/banner_ad_widget.dart';
import '../../admob/interstitial_ad_manager.dart';

class MapaDaRisco extends StatelessWidget {
  const MapaDaRisco({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: const EdgeInsets.all(30),
                alignment: AlignmentDirectional.topStart,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'O Mapa de Risco é uma maneira eficiente de proteger seus funcionários, mostrando claramente os riscos que o ambiente de trabalho pode apresentar.\n\nPara conseguir essa visualização, é preciso estudar a empresa de forma efetiva para, assim, chegar a um diagnóstico sobre os perigos de cada de setor.\n\nO Mapa de Risco foi criado na década de 60, pelos italianos, e chegou em terras brasileiras apenas no fim dos anos 70.\n\nCom o aumento da produção industrial e do índice de acidentes, logo em seguida, o método começou a ser utilizado nas fábricas e ambientes de industriais e, em 1992, ele se tornou obrigatório.\n\nDesde então, o Mapa de Risco é exigido em todos os países em que a CIPA (Comissão Interna de Prevenção de Acidentes) está presente e sua ausência pode acarretar em multas de alto de valor.\n\nComo fazer um Mapa de Risco?\n\nCada empresa precisa de um Mapa de Risco adequado para seu segmento, mas alguns itens são comuns a todas, como esses:\n\nREUNIR INFORMAÇÕES SUFICIENTES PARA O ESTABELECIMENTO DE UM DIAGNÓSTICO DA SITUAÇÃO DE SEGURANÇA E SAÚDE NO TRABALHO DO ESTABELECIMENTO.\n\nPOSSIBILITAR A TROCA E DIVULGAÇÃO DE INFORMAÇÕES ENTRE OS TRABALHADORES E ESTIMULAR SUA PARTICIPAÇÃO NAS ATIVIDADES DE PREVENÇÃO.\n\nCONHECER O PROCESSO DE TRABALHO NO LOCAL ANALISADO:\n\nOs trabalhadores: número, sexo, idade, treinamentos profissionais e de segurança e saúde.\nJornada de trabalho.\nOs instrumentos e materiais de trabalho.\nAs atividades exercidas.\nO ambiente.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '\nIDENTIFICAR OS RISCOS EXISTENTES NO LOCAL ANALISADO.\n\nIDENTIFICAR AS MEDIDAS PREVENTIVAS EXISTENTES E SUA EFICÁCIA, ENTRE ELAS:\n\nMedidas de proteção coletiva, de organização do trabalho, de proteção individual e de higiene e conforto.\n\n\nDESCOBRIR AS QUEIXAS MAIS COMUNS ENTRE OS FUNCIONÁRIOS EXPOSTOS AOS MESMOS RISCOS, DOENÇAS PROFISSIONAIS JÁ DIAGNOSTICADAS E CAUSAS MAIS FREQUENTES DE AUSÊNCIA NO TRABALHO.\n\nTER CONHECIMENTO DOS LEVANTAMENTOS AMBIENTAIS JÁ REALIZADOS NO LOCAL.\n\nO NÚMERO DE TRABALHADORES EXPOSTOS AO RISCO.\n\nESPECIFICAR OS AGENTES, POR EXEMPLO: QUÍMICOS, ERGONÔMICOS, BIOLÓGICOS OU DE ACIDENTES.\n\nAPÓS APROVAÇÃO DA CIPA, O MAPA DE RISCO DEVE SER EXPOSTO CLARAMENTE EM TODOS OS SETORES ANALISADOS, DE MANEIRA QUE OS FUNCIONÁRIOS POSSAM FACILMENTE VER.\n\n\nPara facilitar a visualização do mapa, os riscos são divididos em cinco grupos, representados por diferentes cores:\n\nGRUPO 1 - RISCOS FÍSICOS (Verde):\n\nVibração, Radiação ionizante e não ionizante, frio, calor, pressões anormais e umidade.\n\nGRUPO 2 - RISCOS QUÍMICOS (Vermelho):\n\nPoeiras, fumos, neblinas, gases, vapores, substancias compostas ou produtos químicos em geral.\n\nGRUPO 3 - RISCOS BIOLÓGICOS (Marron):\n\nVírus, bactérias, fungos, parasitas e bacilos.\n\nGRUPO 4 - RISCOS ERGONÔMICOS (Amarelo):\n\nEsforço físico intenso, levantamento e transporte manual de peso, controle rígido de produtividade, imposição de ritmos excessivos, trabalho em turno noturno, jornadas de trabalho prolongadas, monotonia e repetitividade e outras situações provocadoras de estresses psíquico e físico.\n\nGRUPO 5 - RISCOS DE ACIDENTES (Azul):\n\nArranjo físico inadequado, máquinas e equipamentos sem proteção, iluminação inadequada, probabilidade de incêndios ou explosões, animais peçonhentos, armazenamento inadequado e outras situações que possam acabar em acidentes.\n\nCom os risco qualificados, o próximo passo é fazer a quantificação dos mesmos.\n\nA quantificação dos riscos são feitos com equipamentos específicos para as classes de risco.\n\nNa grande maioria as vezes os mapas de riscos são elaborados com base na plata baixa da empresa, toda via a grande maioria dos colaborades não compreendem.\n\nPara uma melhor compreensão pode ser usada uma foto do local de trabalho.\n\nO Mapa de Risco reduz significantemente as doenças e os acidentes porque conscientiza todos os envolvidos dos perigos apresentados.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextButton(
                            onPressed: () {
                              InterstitialAdManager.showInterstitialAd(
                                  context, const Mapaexemplo());
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xff0C5422),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(10)),
                            child: const Text('Exemplo'),
                          )),
                    )
                  ],
                )),
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
