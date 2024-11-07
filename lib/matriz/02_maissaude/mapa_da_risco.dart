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
                      'O Mapa de Risco é uma maneira eficiente de proteger seus funcionários, mostrando claramente os riscos que o ambiente de trabalho pode apresentar.\n\n'
                      'Para conseguir essa visualização, é preciso estudar a empresa de forma efetiva para, assim, chegar a um diagnóstico sobre os perigos de cada setor.\n\n'
                      'O Mapa de Risco foi criado na década de 60, pelos italianos, e chegou em terras brasileiras apenas no fim dos anos 70.\n\n'
                      'Com o aumento da produção industrial e do índice de acidentes, logo em seguida, o método começou a ser utilizado nas fábricas e ambientes industriais e, em 1992, ele se tornou obrigatório.\n\n'
                      'Desde então, o Mapa de Risco é exigido em todos os países em que a CIPA (Comissão Interna de Prevenção de Acidentes) está presente, e sua ausência pode acarretar em multas de alto valor.\n\n'
                      '### Como fazer um Mapa de Risco?\n\n'
                      'Cada empresa precisa de um Mapa de Risco adequado para seu segmento, mas alguns itens são comuns a todas, como:\n\n'
                      '- Reunir informações suficientes para o estabelecimento de um diagnóstico da situação de segurança e saúde no trabalho do estabelecimento.\n'
                      '- Possibilitar a troca e divulgação de informações entre os trabalhadores e estimular sua participação nas atividades de prevenção.\n'
                      '- Conhecer o processo de trabalho no local analisado:\n'
                      '  - Os trabalhadores: número, sexo, idade, treinamentos profissionais e de segurança e saúde.\n'
                      '  - Jornada de trabalho.\n'
                      '  - Os instrumentos e materiais de trabalho.\n'
                      '  - As atividades exercidas.\n'
                      '  - O ambiente.\n\n'
                      '- Identificar os riscos existentes no local analisado.\n\n'
                      '- Identificar as medidas preventivas existentes e sua eficácia, entre elas:\n'
                      '  - Medidas de proteção coletiva, de organização do trabalho, de proteção individual e de higiene e conforto.\n\n'
                      '- Descobrir as queixas mais comuns entre os funcionários expostos aos mesmos riscos, doenças profissionais já diagnosticadas e causas mais frequentes de ausência no trabalho.\n\n'
                      '- Ter conhecimento dos levantamentos ambientais já realizados no local.\n\n'
                      '- O número de trabalhadores expostos ao risco.\n\n'
                      '- Especificar os agentes, por exemplo: químicos, ergonômicos, biológicos ou de acidentes.\n\n'
                      '- Após a aprovação da CIPA, o Mapa de Risco deve ser exposto claramente em todos os setores analisados, de maneira que os funcionários possam facilmente ver.\n\n'
                      '### Grupos de Risco\n\n'
                      'Para facilitar a visualização do mapa, os riscos são divididos em cinco grupos, representados por diferentes cores:\n\n'
                      '- **Grupo 1 - Riscos Físicos (Verde):** Vibração, radiação ionizante e não ionizante, frio, calor, pressões anormais e umidade.\n'
                      '- **Grupo 2 - Riscos Químicos (Vermelho):** Poeiras, fumos, neblinas, gases, vapores, substâncias compostas ou produtos químicos em geral.\n'
                      '- **Grupo 3 - Riscos Biológicos (Marrom):** Vírus, bactérias, fungos, parasitas e bacilos.\n'
                      '- **Grupo 4 - Riscos Ergonômicos (Amarelo):** Esforço físico intenso, levantamento e transporte manual de peso, controle rígido de produtividade, imposição de ritmos excessivos, trabalho em turno noturno, jornadas de trabalho prolongadas, monotonia e repetitividade e outras situações provocadoras de estresses psíquico e físico.\n'
                      '- **Grupo 5 - Riscos de Acidentes (Azul):** Arranjo físico inadequado, máquinas e equipamentos sem proteção, iluminação inadequada, probabilidade de incêndios ou explosões, animais peçonhentos, armazenamento inadequado e outras situações que possam acabar em acidentes.\n\n'
                      '### Quantificação dos Riscos\n\n'
                      'Com os riscos qualificados, o próximo passo é fazer a quantificação dos mesmos. A quantificação dos riscos é feita com equipamentos específicos para as classes de risco.\n\n'
                      'Na maioria das vezes, os mapas de riscos são elaborados com base na planta baixa da empresa; no entanto, a maioria dos colaboradores não compreende.\n\n'
                      'Para uma melhor compreensão, pode ser usada uma foto do local de trabalho. O Mapa de Risco reduz significativamente as doenças e os acidentes porque conscientiza todos os envolvidos dos perigos apresentados.',
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
