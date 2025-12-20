import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Datas extends StatelessWidget {
  const Datas({super.key});

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
          'DATAS IMPORTANTES',
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
              child: const ImportantDatesText(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class ImportantDatesText extends StatelessWidget {
  const ImportantDatesText({super.key});

  @override
  Widget build(BuildContext context) {
    const dates = [
      {
        'date': '28/02',
        'description':
            'Dia Internacional de Prevenção às Lesões por Esforços Repetitivos (LER).'
      },
      {'date': '08/03', 'description': 'Dia Internacional da Mulher.'},
      {'date': '16/04', 'description': 'Dia Nacional da Voz.'},
      {
        'date': '28/04',
        'description':
            'Dia Mundial em Memória às Vítimas de Acidentes de Trabalho e Dia Mundial de Segurança e Saúde no Trabalho.'
      },
      {'date': '01/05', 'description': 'Dia do Trabalhador.'},
      {
        'date': '02/05',
        'description': 'Dia Nacional de Combate ao Assédio Moral.'
      },
      {'date': '13/05', 'description': 'Abolição da Escravatura.'},
      {
        'date': '18/05',
        'description':
            'Dia Nacional de Combate ao Abuso e à Exploração Sexual de Crianças e Adolescentes.'
      },
      {'date': '31/05', 'description': 'Dia Mundial sem Tabaco.'},
      {
        'date': '12/06',
        'description': 'Dia Mundial de Combate ao Trabalho Infantil.'
      },
      {'date': '25/07', 'description': 'Dia do Trabalhador Rural.'},
      {
        'date': '27/07',
        'description': 'Dia Nacional de Prevenção de Acidentes de Trabalho.'
      },
      {
        'date': '10/11',
        'description': 'Dia Nacional de Prevenção e Combate à Surdez.'
      },
      {
        'date': '27/11',
        'description': 'Dia Nacional dos Técnicos de Segurança do Trabalho.'
      },
      {'date': '09/12', 'description': 'Dia do Fonoaudiólogo.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dates
          .map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Segoe',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '${d['date']} - ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: d['description']),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
