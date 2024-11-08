import 'package:flutter/material.dart';

import '../../admob/banner_ad_widget.dart';

class Ppp extends StatelessWidget {
  const Ppp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Perfil Profissiográfico Previdenciário'.toUpperCase(),
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
            image: AssetImage('assets/images/ppp.jpg'),
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
                        'O Perfil Profissiográfico Previdenciário (PPP) é um documento que reúne informações sobre o histórico laboral do trabalhador, incluindo dados administrativos, registros ambientais e resultados de monitoramento biológico ao longo de seu período de atividade em determinada empresa.\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Finalidade do PPP\n',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Promover condições para habilitação de benefícios previdenciários, como a aposentadoria especial.\n\n'
                        '• Oferecer ao trabalhador meios de prova produzidos pelo empregador, para a Previdência Social, órgãos públicos e sindicatos, assegurando direitos trabalhistas.\n\n'
                        '• Fornecer à empresa meios de prova para evitar ações judiciais indevidas.\n\n'
                        '• Possibilitar o uso de informações fidedignas como fonte primária para políticas de saúde coletiva e vigilância epidemiológica.\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Histórico e Base Legal\n',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'O PPP substituiu antigos formulários (SB 40, DISES BE 5235, DSS 8030, DIRBEN 8030), obrigatórios para trabalhadores expostos a agentes nocivos. Instituído pelo § 4º do art. 58 da Lei 8.213/91, sua exigência legal foi estabelecida a partir da Instrução Normativa IN INSS 118/2005.\n\n'
                        'Desde 1º de janeiro de 2004, as empresas são obrigadas a elaborar o PPP de forma individualizada para empregados, avulsos e cooperados, conforme o Anexo XV. A Instrução Normativa INSS 77/2015, atualizada pela INSS 85/2016, define as instruções e o modelo do formulário do PPP.\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Responsáveis pela Emissão do PPP\n',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Empresa empregadora, para empregados;\n\n'
                        '• Cooperativa de trabalho ou produção, para cooperados filiados;\n\n'
                        '• Órgão Gestor de Mão de Obra (OGMO), para Trabalhadores Portuários Avulsos (TPA);\n\n'
                        '• Sindicato de Categoria, para trabalhadores avulsos não portuários.\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Atualização e Entrega do PPP\n',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'O PPP deve ser atualizado e entregue ao trabalhador ao término do contrato, especialmente se houve exposição a agentes nocivos. A omissão pode resultar em multa, conforme o art. 283 do Decreto 3.048/99 e Portaria MPS/MF 15/2018 (com valor mínimo de R\$ 2.331,32).\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Fontes de Dados para Emissão do PPP\n',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'a) Programa de Prevenção de Riscos Ambientais - PPRA\n\n'
                        'b) Programa de Gerenciamento de Riscos - PGR\n\n'
                        'c) Programa de Condições e Meio Ambiente de Trabalho na Indústria da Construção - PCMAT\n\n'
                        'd) Programa de Controle Médico de Saúde Ocupacional - PCMSO\n\n'
                        'e) Laudo Técnico de Condições Ambientais do Trabalho - LTCAT\n\n'
                        'f) Comunicação de Acidente do Trabalho - CAT\n\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'A atualização do PPP deve ocorrer sempre que houver mudanças nas informações contidas ou, no mínimo, anualmente, caso os dados permaneçam inalterados. No site do INSS, encontra-se o formulário oficial do PPP, com instruções detalhadas para preenchimento de cada campo.',
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
