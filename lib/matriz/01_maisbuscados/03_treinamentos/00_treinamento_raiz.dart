import 'package:flutter/material.dart';
import '../../../admob/banner_ad_widget.dart';
import '../../../admob/interstitial_ad_manager.dart';
import '01_treinamento_base.dart';

class TreinamentoRaiz extends StatefulWidget {
  const TreinamentoRaiz({super.key});

  @override
  State<TreinamentoRaiz> createState() => _TreinamentoRaizState();
}

class _TreinamentoRaizState extends State<TreinamentoRaiz> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

  final List<Map<String, String>> treinamentos = [
    {
      "title": "Treinamento 1 - Segurança no Trabalho",
      "content": "Conteúdo do Treinamento 1 sobre Segurança no Trabalho."
    },
    {
      "title": "Treinamento 2 - Prevenção de Acidentes",
      "content": "Conteúdo do Treinamento 2 sobre Prevenção de Acidentes."
    },
    {
      "title": "Treinamento 3 - Uso de Equipamentos de Proteção Individual",
      "content":
          "Conteúdo do Treinamento 3 sobre Uso de Equipamentos de Proteção Individual."
    },
    // Adicione mais itens conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Treinamentos'.toUpperCase(),
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
            image: AssetImage('assets/images/treinamentos.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 12,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                margin: const EdgeInsets.all(24),
                child: ListView.builder(
                  itemCount: treinamentos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () async {
                          InterstitialAdManager.showInterstitialAd(
                            context,
                            TreinamentoBase(
                                title: treinamentos[index]["title"]!,
                                content: treinamentos[index][
                                    "content"]!), // Passa o título e o conteúdo
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              const Icon(Icons.library_books),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  treinamentos[index]["title"]!.toUpperCase(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: 'Segoe Bold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: BannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
