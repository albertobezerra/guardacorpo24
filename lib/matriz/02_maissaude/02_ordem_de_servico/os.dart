import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Os extends StatelessWidget {
  const Os({super.key});

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
          'ORDEM DE SERVIÇO',
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
              child: const _OsContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _OsContent extends StatelessWidget {
  const _OsContent();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'A Ordem de Serviço (OS) é um documento formal que registra as orientações de segurança relativas a uma atividade, '
          'deixando claro para o trabalhador quais são os riscos envolvidos e quais medidas de prevenção devem ser adotadas.\n',
        ),
        _title('Obrigações do empregador'),
        _body(
          'A NR 1 estabelece que o empregador deve elaborar Ordens de Serviço para informar os empregados sobre riscos '
          'ocupacionais e medidas de proteção. Ao assinar a OS, o trabalhador declara ter recebido essas informações e '
          'estar ciente das condições em que sua atividade será realizada.\n',
        ),
        _title('Responsabilidades do empregado'),
        _body(
          'Também é obrigação do empregado cumprir as normas de segurança e as Ordens de Serviço estabelecidas pela empresa. '
          'O descumprimento pode acarretar medidas disciplinares e aumenta o risco de acidentes.\n',
        ),
        _title('Importância da Ordem de Serviço'),
        _body(
          'A OS é essencial para registrar a comunicação entre empregador e empregado sobre segurança. '
          'Ela contribui para:\n'
          '• Fortalecer a cultura de prevenção.\n'
          '• Deixar claras as responsabilidades de cada parte.\n'
          '• Reduzir a subnotificação de riscos e incidentes.\n'
          '• Servir como evidência documental em auditorias e investigações de acidentes.\n',
        ),
        _body(
          'Quando bem elaborada e explicada, a Ordem de Serviço reforça o compromisso da empresa com a saúde e a segurança '
          'dos trabalhadores, auxiliando no cumprimento das normas legais e na proteção da vida.',
        ),
      ],
    );
  }
}
