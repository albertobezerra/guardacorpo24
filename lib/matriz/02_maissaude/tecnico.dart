import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Tecnico extends StatelessWidget {
  const Tecnico({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Técnico em Segurança do Trabalho'.toUpperCase(),
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
            image: AssetImage('assets/images/tecnico.jpg'),
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
                            fontFamily: 'Segoe',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'O profissional de Segurança do Trabalho atua conforme sua formação, seja médico, enfermeiro, engenheiro ou técnico.\n\n'
                                  'De modo geral, o técnico de segurança e o engenheiro atuam no desenvolvimento dos programas de prevenção de acidentes, CIPA, uso correto dos EPI\'s, na elaboração de planos de prevenção a riscos ambientais, inspeções de segurança, laudos técnicos e organização de palestras e treinamentos.\n\n'
                                  'O médico e o enfermeiro do trabalho se dedicam à prevenção de doenças, realizando consultas, tratamentos e os exames ocupacionais.\n\n'
                                  'O Ministério do Trabalho e Emprego (MTE) descreve a ocupação do Técnico em Segurança do Trabalho: Participam da elaboração e implementam políticas de saúde e segurança do trabalho, realizam diagnóstico da situação de SST da instituição, identificam variáveis de controle de doenças, acidentes, qualidade de vida e meio ambiente.\n\n'
                                  'Desenvolvem ações educativas na área de saúde e segurança do trabalho; integram processos de negociação. Participam da adoção de tecnologias e processos de trabalho; investigam, analisam acidentes de trabalho e recomendam medidas de prevenção e controle.\n\n',
                            ),
                            TextSpan(
                              text: 'Novas Tecnologias e Desafios\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Com a evolução tecnológica, o campo de Segurança do Trabalho também se adapta a novos desafios. A introdução de tecnologias como a Internet das Coisas (IoT) e a Inteligência Artificial (IA) tem permitido monitorar condições de trabalho em tempo real, identificar potenciais riscos e agir preventivamente.\n\n',
                            ),
                            TextSpan(
                              text: 'Importância da Cultura de Segurança\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Além das medidas técnicas, a criação de uma cultura de segurança no ambiente de trabalho é fundamental. Isso envolve conscientização contínua, engajamento dos funcionários e lideranças comprometidas. Workshops, campanhas de conscientização e programas de incentivo ajudam a manter a segurança como uma prioridade diária.\n\n',
                            ),
                            TextSpan(
                              text: 'Exemplos Práticos\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '- Engenharia de Segurança: Desenvolvimento de sistemas de ventilação em minas para evitar a exposição a gases tóxicos.\n'
                                  '- Medicina do Trabalho: Implementação de programas de vacinação contra doenças ocupacionais.\n'
                                  '- Ergonomia: Projeto de estações de trabalho que reduzam o esforço físico e previnam lesões por movimentos repetitivos.\n\n'
                                  'O campo de Segurança do Trabalho está em constante evolução, exigindo dos profissionais uma atualização constante e um compromisso contínuo com a saúde e o bem-estar dos trabalhadores.',
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
