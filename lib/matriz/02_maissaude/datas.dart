import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Datas extends StatelessWidget {
  const Datas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Datas importantes'.toUpperCase(),
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
            image: AssetImage('assets/images/datas.jpg'),
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
          const BannerAdWidget(),
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
        "date": "28/02",
        "description":
            "Dia Internacional de Prevenção às Lesões por Esforço Repetitivos (LER)"
      },
      {"date": "08/03", "description": "Dia Internacional da Mulher"},
      {"date": "16/04", "description": "Dia Nacional da Voz"},
      {
        "date": "28/04",
        "description":
            "Dia Mundial em Memória às Vítimas de Acidentes de Trabalho e Dia Mundial de Segurança e Saúde no Trabalho"
      },
      {"date": "01/05", "description": "Dia do Trabalhador"},
      {
        "date": "02/05",
        "description": "Dia Nacional de Combate ao Assédio Moral"
      },
      {"date": "13/05", "description": "Abolição da Escravatura"},
      {
        "date": "18/05",
        "description":
            "Dia Nacional ao Abuso e à Exploração Sexual de Crianças e Adolescentes"
      },
      {"date": "31/05", "description": "Dia Mundial sem Tabaco"},
      {
        "date": "12/06",
        "description": "Dia Mundial de Combate ao Trabalho Infantil"
      },
      {"date": "25/07", "description": "Dia do Trabalhador Rural"},
      {
        "date": "27/07",
        "description": "Dia Nacional de Prevenção de Acidentes de Trabalho"
      },
      {
        "date": "10/11",
        "description": "Dia Nacional de Prevenção e Combate à Surdez"
      },
      {
        "date": "27/11",
        "description": "Dia Nacional dos Técnicos de Segurança do Trabalho"
      },
      {"date": "09/12", "description": "Dia do Fonoaudiólogo"},
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
