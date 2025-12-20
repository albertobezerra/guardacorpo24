import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Aso extends StatelessWidget {
  const Aso({super.key});

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
          'ASO - ATESTADO DE SAÚDE OCUPACIONAL',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: primary,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const _AsoContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _AsoContent extends StatelessWidget {
  const _AsoContent();

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
          'O Atestado de Saúde Ocupacional (ASO) é o documento em que o médico do trabalho registra a aptidão ou inaptidão '
          'do empregado para exercer determinada função, com base nos exames clínicos e complementares previstos no PCMSO.\n',
        ),
        _body(
          'Somente médico do trabalho ou serviço especializado pode emitir o ASO. Ele é utilizado em todos os tipos de exame ocupacional '
          '(admissional, periódico, mudança de função, retorno ao trabalho e demissional).\n',
        ),
        _title('Relação com o PCMSO e exames'),
        _body(
          'Os exames complementares realizados (como audiometria, raio‑X, exames laboratoriais, entre outros) são definidos no PCMSO, '
          'de acordo com os riscos mapeados no PGR. O ASO consolida essas informações na forma de um laudo de aptidão.\n',
        ),
        _title('Informações obrigatórias no ASO'),
        _body('A NR 7 estabelece que o ASO deve conter, no mínimo:'),
        const SizedBox(height: 8),
        _bullet(
            'Identificação do trabalhador: nome completo, documento de identidade e função exercida.'),
        _bullet(
            'Descrição dos riscos ocupacionais específicos existentes na atividade (ou a indicação de ausência de riscos).'),
        _bullet(
            'Indicação dos procedimentos médicos realizados, incluindo exames complementares e as respectivas datas.'),
        _bullet(
            'Nome do médico responsável pelo PCMSO, quando houver, com número de registro no CRM.'),
        _bullet(
            'Conclusão de apto ou inapto para a função específica que o trabalhador exerce ou exercerá.'),
        _bullet(
            'Nome, forma de contato e número de inscrição no CRM do médico que realizou o exame.'),
        _bullet('Data, assinatura e carimbo do médico encarregado do exame.'),
        const SizedBox(height: 12),
        _title('Importância do ASO'),
        _body(
          'O ASO é fundamental para comprovar que o trabalhador foi avaliado quanto à sua saúde em relação aos riscos ocupacionais. '
          'Ele protege tanto o empregado quanto o empregador, registrando de forma formal as condições de aptidão para o trabalho e '
          'auxiliando na prevenção de doenças relacionadas à atividade exercida.',
        ),
      ],
    );
  }
}
