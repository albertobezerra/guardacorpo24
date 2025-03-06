import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/nho_base.dart';

class Nho extends StatefulWidget {
  const Nho({super.key});

  @override
  State<Nho> createState() => _NhoState();
}

class _NhoState extends State<Nho> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

  final List<Map<String, String>> nho = [
    {
      "title": 'NHO 01 - avaliação da exposição ocupacional ao ruído',
      "pdf": "assets/nho/NHO01.pdf"
    },
    {
      "title":
          'NHO 02 - análise qualitativa da fração volátil (vapores orgânicos) em colas, tintas e vernizes por cromatografia gasosa / detector de ionização de chama - Em processo de revisão',
      "pdf": "assets/nho/NHO02.pdf"
    },
    {
      "title":
          'NHO 03 - análise gravimétrica de aerodispersóides sólidos coletados sobre filtros de membrana',
      "pdf": "assets/nho/NHO03.pdf"
    },
    {
      "title":
          'NHO 04 - método de coleta e análise de fibras em locais de trabalho - análise por microscopia ótica de contraste de fase ',
      "pdf": "assets/nho/NHO04.pdf"
    },
    {
      "title":
          'NHO 05 - avaliação da exposição ocupacional aos raios-x nos serviços de radiologia',
      "pdf": "assets/nho/NHO05.pdf"
    },
    {
      "title": 'NHO 06 - avaliação da exposição ocupacional ao calor',
      "pdf": "assets/nho/NHO06.pdf"
    },
    {
      "title":
          'NHO 07 - calibração de bombas de amostragem individual pelo método da bolha de sabão',
      "pdf": "assets/nho/NHO07.pdf"
    },
    {
      "title":
          'NHO 08 - coleta de material particulado sólido suspenso no ar de ambientes de trabalho',
      "pdf": "assets/nho/NHO08.pdf"
    },
    {
      "title":
          'NHO 09 - avaliação da exposição ocupacional a vibrações de corpo inteiro',
      "pdf": "assets/nho/NHO09.pdf"
    },
    {
      "title":
          'NHO 10 - avaliação da exposição ocupacional a vibração de mãos e braços',
      "pdf": "assets/nho/NHO10.pdf"
    },
    {
      "title":
          'NHO 11 - avaliação dos níveis de iluminamento em ambientes internos de trabalho',
      "pdf": "assets/nho/NHO11.pdf"
    },
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
            'Normas de Higiene Ocupacional'.toUpperCase(),
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
            image: AssetImage('assets/images/normas.jpg'),
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
                  itemCount: nho.length,
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
                            NhoBase(
                                title: nho[index]["title"]!,
                                pdfPath: nho[index][
                                    "pdf"]!), // Passa o título e o caminho do PDF
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
                                  nho[index]["title"]!.toUpperCase(),
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
            child: ConditionalBannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
