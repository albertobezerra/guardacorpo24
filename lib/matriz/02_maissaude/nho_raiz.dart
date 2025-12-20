import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget.dart';
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

  List<int> _getCtaPositions(int totalItems) {
    if (totalItems <= 10) {
      return [];
    } else if (totalItems <= 20) {
      return [totalItems ~/ 2];
    } else if (totalItems <= 50) {
      return [
        (totalItems * 0.3).round(),
        (totalItems * 0.7).round(),
      ];
    } else {
      return [
        (totalItems * 0.25).round(),
        (totalItems * 0.5).round(),
        (totalItems * 0.75).round(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);

    final ctaPositions = _getCtaPositions(nho.length);

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
          'NORMAS DE HIGIENE OCUPACIONAL',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: nho.length,
                itemBuilder: (context, index) {
                  if (ctaPositions.contains(index)) {
                    return const RewardCTAWidget();
                  }

                  final item = nho[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          InterstitialAdManager.showInterstitialAd(
                            context,
                            NhoBase(
                              title: item["title"]!,
                              pdfPath: item["pdf"]!,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.library_books,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item["title"]!.toUpperCase(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
