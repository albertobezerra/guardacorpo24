import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Nbrs extends StatelessWidget {
  const Nbrs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'NBRs relevantes'.toUpperCase(),
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
            image: AssetImage('assets/images/nbr.jpg'),
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
                      ImportantDatesText(),
                    ],
                  ),
                ),
              ),
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
    const List<Map<String, String>> dates = [
      {
        "date": "NBR 9050",
        "description":
            "Acessibilidade a edificações, mobiliário, espaços e equipamentos urbanos."
      },
      {
        "date": "NBR 18801",
        "description": "Sistemas de Gestão de Segurança e Saúde no Trabalho."
      },
      {
        "date": "NBR 6493",
        "description": "Emprego de Cores para identificação de tubulações"
      },
      {"date": "NBR 7195", "description": "Cores para Sinalização."},
      {
        "date": "NBR 13434",
        "description":
            "Sinalização de Seguraça conta Incêndio e Pânico - Simbolos e suas formas, dimensões e cores."
      },
      {
        "date": "NBR 13966",
        "description": "Ergonomia - Móveis para escritórios - Mesas."
      },
    ];

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        children: dates
            .map((dateMap) => TextSpan(
                  children: [
                    TextSpan(
                      text: '${dateMap["date"]} - ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '${dateMap["description"]}\n\n'),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
