import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Pgr extends StatelessWidget {
  const Pgr({super.key});

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
          'PPRA VS PGR',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PgrIntro(),
                  const SizedBox(height: 12),
                  _buildComparisonTable(),
                  const SizedBox(height: 20),
                  const _PgrPsychosocial(),
                  const SizedBox(height: 8),
                  _buildNumberedList([
                    'Inventário de Riscos: Detalhamento dos perigos e riscos ocupacionais.',
                    'Plano de Ação: Estratégias para eliminar, minimizar ou controlar riscos.',
                    'Integração: Articulação com PCMSO, CIPA e demais programas de SST.',
                    'Avaliação contínua: Revisões periódicas para manter a eficácia das medidas.',
                  ]),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFECECEC)),
          children: [
            _TableHeader('Característica'),
            _TableHeader('PPRA (extinto)'),
            _TableHeader('PGR (atual)'),
          ],
        ),
        _buildTableRow(
          'Escopo',
          'Riscos ambientais (físicos, químicos, biológicos).',
          'Todos os riscos ocupacionais (ambientais, ergonômicos, acidentes, psicossociais).',
        ),
        _buildTableRow(
          'Metodologia',
          'Identificação e antecipação mais estática.',
          'Avaliação contínua com foco em probabilidade e severidade.',
        ),
        _buildTableRow(
          'Documentação',
          'Documento único, geralmente anual.',
          'Inventário de Riscos e Plano de Ação, com revisões periódicas.',
        ),
        _buildTableRow(
          'Integração',
          'Pouca integração formal com outros programas.',
          'Integrado com demais instrumentos de SST (PCMSO, AET, etc.).',
        ),
        _buildTableRow(
          'Gestão',
          'Mais burocrática e reativa.',
          'Sistêmica, orientada à melhoria contínua.',
        ),
      ],
    );
  }

  TableRow _buildTableRow(String characteristic, String ppra, String pgr) {
    return TableRow(
      children: [
        _TableCell(characteristic, isHeader: true),
        _TableCell(ppra),
        _TableCell(pgr),
      ],
    );
  }
}

class _PgrIntro extends StatelessWidget {
  const _PgrIntro();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'O Programa de Gerenciamento de Riscos (PGR) substituiu o Programa de Prevenção de Riscos Ambientais (PPRA) em 2022, '
      'representando uma mudança de foco: sai uma visão restrita a riscos ambientais e entra uma abordagem integrada de '
      'todos os riscos ocupacionais.\n',
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 14, height: 1.6),
    );
  }
}

class _PgrPsychosocial extends StatelessWidget {
  const _PgrPsychosocial();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Atualização recente: as empresas precisam incluir riscos psicossociais (como assédio, burnout e estresse) no PGR, '
      'com prazo definido em norma para revisão do programa a partir de 2025, e fiscalização plena prevista para 2026, '
      'segundo orientações do Ministério do Trabalho e de publicações especializadas. [web:139][web:142]\n',
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 14, height: 1.6),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;
  const _TableCell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

Widget _buildNumberedList(List<String> items) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Text(
                items[index],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    },
  );
}
