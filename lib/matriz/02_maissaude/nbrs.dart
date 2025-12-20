import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Nbrs extends StatelessWidget {
  const Nbrs({super.key});

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
          'NBRS RELEVANTES',
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
              child: const _NbrsContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _NbrsContent extends StatelessWidget {
  const _NbrsContent();

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> items = [
      {
        'code': 'NBR 9050',
        'desc':
            'Acessibilidade a edificações, mobiliário, espaços e equipamentos urbanos.'
      },
      {
        'code': 'NBR 18801',
        'desc': 'Sistemas de gestão de segurança e saúde no trabalho.'
      },
      {
        'code': 'NBR 6493',
        'desc': 'Emprego de cores para identificação de tubulações.'
      },
      {'code': 'NBR 7195', 'desc': 'Cores para sinalização de segurança.'},
      {
        'code': 'NBR 13434',
        'desc':
            'Sinalização de segurança contra incêndio e pânico – símbolos, formas, dimensões e cores.'
      },
      {
        'code': 'NBR 13966',
        'desc': 'Ergonomia – móveis para escritórios – mesas.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '${e['code']} - ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: e['desc']),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
