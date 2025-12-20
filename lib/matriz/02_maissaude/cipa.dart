import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Cipa extends StatelessWidget {
  const Cipa({super.key});

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
          'CIPA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
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
              child: const _CipaContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _CipaContent extends StatelessWidget {
  const _CipaContent();

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _body(String text) => Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ',
                style:
                    TextStyle(fontSize: 16, height: 1.4, color: Colors.black)),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'A Comissão Interna de Prevenção de Acidentes (CIPA) é formada por representantes dos empregados e do empregador, '
          'com o objetivo de promover a saúde e a segurança no trabalho, prevenindo acidentes e doenças ocupacionais.\n',
        ),
        _body(
          'Entre suas atribuições está observar e relatar condições de risco, propor melhorias, acompanhar medidas de prevenção '
          'e contribuir para a criação de uma cultura de segurança no ambiente de trabalho.\n',
        ),
        _title('Principais atribuições da CIPA'),
        _bullet(
            'Auxiliar na investigação e análise de acidentes e incidentes.'),
        _bullet(
            'Sugerir medidas para redução, eliminação ou neutralização de riscos.'),
        _bullet('Divulgar e zelar pelo cumprimento das normas de segurança.'),
        _bullet('Realizar inspeções periódicas nos locais de trabalho.'),
        _bullet(
            'Promover e organizar a SIPAT – Semana Interna de Prevenção de Acidentes.'),
        _bullet('Acompanhar a implementação de programas como PGR e PCMSO.'),
        _bullet('Colaborar na elaboração e atualização do Mapa de Riscos.'),
        _title('Composição da CIPA'),
        _body(
          'A composição da CIPA é definida pela NR 5, considerando o CNAE e o número de empregados. '
          'Os membros são representantes do empregador (indicados) e dos empregados (eleitos).\n',
        ),
        _bullet('Presidente: indicado pelo empregador.'),
        _bullet(
            'Vice‑presidente: eleito entre os representantes dos empregados.'),
        _bullet('Secretário e vice‑secretário: escolhidos em comum acordo.'),
      ],
    );
  }
}
