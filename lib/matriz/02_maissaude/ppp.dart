import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Ppp extends StatelessWidget {
  const Ppp({super.key});

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
          'PERFIL PROFISSIOGRÁFICO PREVIDENCIÁRIO',
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
              child: const _PppContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _PppContent extends StatelessWidget {
  const _PppContent();

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
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
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 14, height: 1.6)),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
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
          'O Perfil Profissiográfico Previdenciário (PPP) é um documento que consolida o histórico laboral do trabalhador, '
          'incluindo dados administrativos, registros ambientais e resultados de monitoramento biológico ao longo do vínculo com a empresa.\n',
        ),
        _title('Finalidade do PPP'),
        _bullet(
            'Comprovar, junto ao INSS, as condições de trabalho para concessão de benefícios como aposentadoria especial.'),
        _bullet(
            'Disponibilizar ao trabalhador um histórico formal das exposições ocupacionais.'),
        _bullet(
            'Servir de prova técnica para empresas em eventuais ações judiciais.'),
        _bullet(
            'Subsidiar políticas públicas e ações de vigilância em saúde do trabalhador.'),
        _title('Histórico e base legal'),
        _body(
          'O PPP substituiu antigos formulários (SB-40, DSS-8030, DIRBEN 8030 etc.) para registro de exposição a agentes nocivos. '
          'Foi instituído pelo art. 58 da Lei 8.213/91 e regulamentado por sucessivas instruções normativas do INSS.\n',
        ),
        _title('Quem deve emitir'),
        _bullet('Empresa empregadora, para empregados.'),
        _bullet(
            'Cooperativa de trabalho ou produção, para cooperados filiados.'),
        _bullet('OGMO, para trabalhadores portuários avulsos (TPA).'),
        _bullet('Sindicato de categoria, para demais trabalhadores avulsos.'),
        _title('Atualização e entrega'),
        _body(
          'O PPP deve ser atualizado sempre que houver alteração nas condições de trabalho ou, no mínimo, uma vez ao ano, '
          'e obrigatoriamente entregue ao trabalhador na rescisão do contrato, especialmente se houve exposição a agentes nocivos.\n',
        ),
        _body(
          'A não emissão ou o preenchimento incorreto podem gerar autuações e multas previstas no Decreto 3.048/99 e normas correlatas.\n',
        ),
        _title('Principais fontes de dados'),
        _bullet('PGR e programas anteriores (como PPRA e PCMAT).'),
        _bullet('PCMSO e exames médicos ocupacionais.'),
        _bullet('LTCAT e outros laudos ambientais.'),
        _bullet('Registros de acidentes (CAT) e afastamentos.'),
      ],
    );
  }
}
