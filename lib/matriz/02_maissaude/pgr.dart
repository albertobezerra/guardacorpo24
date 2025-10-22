import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Pgr extends StatelessWidget {
  const Pgr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'PPRA vs PGR',
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
                            text: 'Entendendo a Transição\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'O Programa de Gerenciamento de Riscos (PGR) substituiu o Programa de Prevenção de Riscos Ambientais (PPRA) a partir de 3 de janeiro de 2022. Esta mudança marca uma evolução na gestão de Saúde e Segurança do Trabalho (SST) no Brasil, com foco em uma abordagem mais sistêmica e completa.\n\n',
                          ),
                          TextSpan(
                            text: 'Diferenças Chave: PPRA x PGR\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tabela de Comparação
                    _buildComparisonTable(),

                    const SizedBox(height: 20),

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
                                'Atualização Recente: Riscos Psicossociais\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'A partir de **maio de 2025**, todas as empresas devem incluir a análise e controle de riscos psicossociais em seu PGR. Embora o Ministério do Trabalho tenha adiado a fiscalização para **maio de 2026** para dar tempo de adaptação, a inclusão desses riscos (como assédio, burnout e estresse) já é obrigatória.\n\n',
                          ),
                          TextSpan(
                            text: 'Componentes de um PGR Robusto\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lista numerada
                    _buildNumberedList([
                      '**Inventário de Riscos:** Detalhamento completo dos perigos e riscos ocupacionais.',
                      '**Plano de Ação:** Estratégia para eliminar, minimizar ou controlar os riscos identificados.',
                      '**Integração:** Articulação com outros programas de SST (PCMSO, CIPA, etc.).',
                      '**Avaliação Contínua:** Revisões periódicas para assegurar a eficácia das medidas.',
                    ]),
                  ],
                ),
              ),
            ),
          ),

          // Banner de anúncio
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  // Tabela de comparação
  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color.fromARGB(255, 230, 230, 230)),
          children: [
            _TableHeader('Característica'),
            _TableHeader('PPRA (extinto)'),
            _TableHeader('PGR (atual)'),
          ],
        ),
        _buildTableRow(
            'Escopo',
            'Riscos ambientais (físicos, químicos, biológicos)',
            'Todos os riscos ocupacionais (ambientais, ergonômicos, acidentes, psicossociais)'),
        _buildTableRow('Metodologia', 'Identificação e antecipação estática',
            'Avaliação contínua de probabilidade e severidade'),
        _buildTableRow('Documentação', 'Documento único (anual)',
            'Inventário de Riscos e Plano de Ação (bienal ou trienal)'),
        _buildTableRow('Intega', 'Não exigida',
            'Integrado com outros programas de SST (PCMSO, AET)'),
        _buildTableRow(
            'Gestão', 'Burocrática', 'Sistêmica, focada em melhoria contínua'),
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

// Widgets auxiliares para tabela
class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          fontFamily: 'Segoe Bold',
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.0,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Segoe',
        ),
      ),
    );
  }
}

// Lista numerada
Widget _buildNumberedList(List<String> items) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ',
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Segoe Bold',
              ),
            ),
            Expanded(
              child: Text(
                items[index],
                style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Segoe',
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
