import 'package:flutter/material.dart';
import '../../../admob/banner_ad_widget.dart';
import '../../../admob/interstitial_ad_manager.dart';
import '01_dds_base.dart';

class DdsRaiz extends StatefulWidget {
  const DdsRaiz({super.key});

  @override
  State<DdsRaiz> createState() => _DdsRaizState();
}

class _DdsRaizState extends State<DdsRaiz> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

  final List<Map<String, String>> dds = [
    {
      "title": "DDS 1 - Segurança no Trabalho",
      "content": "Conteúdo do DDS 1 sobre Segurança no Trabalho."
    },
    {
      "title": "DDS 2 - Prevenção de Acidentes",
      "content": "Conteúdo do DDS 2 sobre Prevenção de Acidentes."
    },
    {
      "title": "DDS 3 - Uso de Equipamentos de Proteção Individual",
      "content":
          "Conteúdo do DDS 3 sobre Uso de Equipamentos de Proteção Individual."
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
            'DDS'.toUpperCase(),
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
            image: AssetImage('assets/images/dds.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                margin: const EdgeInsets.all(24),
                child: ListView.builder(
                  itemCount: dds.length,
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
                            DdsBase(
                                title: dds[index]["title"]!,
                                content: dds[index][
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
                                  dds[index]["title"]!.toUpperCase(),
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
          const BannerAdWidget(), // Mantém o BannerAdWidget fixo na parte inferior
        ],
      ),
    );
  }
}
