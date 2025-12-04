import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/services/history/history_service.dart';
import 'package:guarda_corpo_2024/services/favorites/favorites_service.dart';
import '01_nr_base.dart';

class NrsRaiz extends StatefulWidget {
  const NrsRaiz({super.key});

  @override
  State<NrsRaiz> createState() => _NrsRaizState();
}

class _NrsRaizState extends State<NrsRaiz> {
  // NRs com atualização recente (você atualiza manualmente quando houver mudança real)
  final Set<int> _recentlyUpdatedNrs = {
    //1,
    //6,
    38
  }; // NR 1, 6 e 35 marcadas como "NOVO"

  // Map para controlar favoritos localmente (para atualização de UI rápida)
  final Map<String, bool> _favoritesCache = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    for (var nr in nrs) {
      final isFav = await FavoritesService.isFavorite(nr['pdf']!);
      setState(() {
        _favoritesCache[nr['pdf']!] = isFav;
      });
    }
  }

  final List<Map<String, String>> nrs = [
    {
      "title":
          "NR 1 - Disposições Gerais e gerenciamento de riscos Ocupacionais.",
      "pdf": "assets/pdf_nr/nr1.pdf"
    },
    {
      "title": "NR 2 - Inspeção Prévia (REVOGADA)",
      "pdf": "assets/pdf_nr/nr2.pdf"
    },
    {"title": "NR 3 - EMBARGO E INTERDIÇÃO", "pdf": "assets/pdf_nr/nr3.pdf"},
    {
      "title":
          "NR 4 - SERVIÇOS ESPECIALIZADOS EM SEGURANÇA E EM MEDICINA DO TRABALHO",
      "pdf": "assets/pdf_nr/nr4.pdf"
    },
    {
      "title":
          "NR 5 - COMISSÃO INTERNA DE PREVENÇÃO DE ACIDENTES E DE ASSÉDIO - CIPA",
      "pdf": "assets/pdf_nr/nr5.pdf"
    },
    {
      "title": "NR 6 - EQUIPAMENTOS DE PROTEÇÃO INDIVIDUAL - EPI",
      "pdf": "assets/pdf_nr/nr6.pdf"
    },
    {
      "title": "NR 7 - PROGRAMA DE CONTROLE MÉDICO E SAÚDE OCUPACIONAL - PCMSO",
      "pdf": "assets/pdf_nr/nr7.pdf"
    },
    {"title": "NR 8 - EDIFICAÇÕES", "pdf": "assets/pdf_nr/nr8.pdf"},
    {
      "title":
          "NR 9 - AVALIAÇÃO E CONTROLE DAS EXPOSIÇÕES OCUPACIONAIS A AGENTES FÍSICOS, QUÍMICOS E BIOLÓGICOS",
      "pdf": "assets/pdf_nr/nr9.pdf"
    },
    {
      "title": "NR 10 - SEGURANÇA EM INSTALAÇÕES E SERVIÇOS EM ELETRICIDADE",
      "pdf": "assets/pdf_nr/nr10.pdf"
    },
    {
      "title":
          "NR 11 - TRANSPORTE, MOVIMENTAÇÃO, ARMAZENAGEM E MANUSEIO DE MATERIAIS",
      "pdf": "assets/pdf_nr/nr11.pdf"
    },
    {
      "title": "NR 12 - SEGURANÇA NO TRABALHO EM MÁQUINAS E EQUIPAMENTOS",
      "pdf": "assets/pdf_nr/nr12.pdf"
    },
    {
      "title":
          "NR 13 - CALDEIRAS, VASOS DE PRESSÃO, TUBULAÇÕES E TANQUES METÁLICOS DE ARMAZENAMENTO",
      "pdf": "assets/pdf_nr/nr13.pdf"
    },
    {"title": "NR 14 - FORNOS", "pdf": "assets/pdf_nr/nr14.pdf"},
    {
      "title": "NR 15 -  ATIVIDADES E OPERAÇÕES INSALUBRES",
      "pdf": "assets/pdf_nr/nr15.pdf"
    },
    {
      "title": "NR 16 - ATIVIDADES E OPERAÇÕES PERIGOSAS",
      "pdf": "assets/pdf_nr/nr16.pdf"
    },
    {"title": "NR 17 - ERGONOMIA", "pdf": "assets/pdf_nr/nr17.pdf"},
    {
      "title":
          "NR 18 - SEGURANÇA E SAÚDE NO TRABALHO NA INDÚSTRIA DA CONSTRUÇÃO",
      "pdf": "assets/pdf_nr/nr18.pdf"
    },
    {"title": "NR 19 - EXPLOSIVOS", "pdf": "assets/pdf_nr/nr19.pdf"},
    {
      "title":
          "NR 20 - SEGURANÇA E SAÚDE NO TRABALHO COM INFLAMÁVEIS E COMBUSTÍVEIS",
      "pdf": "assets/pdf_nr/nr20.pdf"
    },
    {
      "title": "NR 21 - TRABALHOS A CÉU ABERTO",
      "pdf": "assets/pdf_nr/nr21.pdf"
    },
    {
      "title": "NR 22 - SEGURANÇA E SAÚDE OCUPACIONAL NA MINERAÇÃO",
      "pdf": "assets/pdf_nr/nr22.pdf"
    },
    {
      "title": "NR 23 - PROTEÇÃO CONTRA INCÊNDIOS",
      "pdf": "assets/pdf_nr/nr23.pdf"
    },
    {
      "title":
          "NR 24 - CONDIÇÕES SANITÁRIAS E DE CONFORTO NOS LOCAIS DE TRABALHO",
      "pdf": "assets/pdf_nr/nr24.pdf"
    },
    {"title": "NR 25 - RESÍDUOS INDUSTRIAIS", "pdf": "assets/pdf_nr/nr25.pdf"},
    {
      "title": "NR 26 - SINALIZAÇÃO DE SEGURANÇA",
      "pdf": "assets/pdf_nr/nr26.pdf"
    },
    {
      "title":
          "NR 27 - REGISTRO PROFISSIONAL DO TÉCNICO DE SEGURANÇA DO TRABALHO (REVOGADA)",
      "pdf": "assets/pdf_nr/nr27.pdf"
    },
    {
      "title": "NR 28 - FISCALIZAÇÃO E PENALIDADES",
      "pdf": "assets/pdf_nr/nr28.pdf"
    },
    {
      "title":
          "NR 29 - NORMA REGULAMENTADORA DE SEGURANÇA E SAÚDE NO TRABALHO PORTUÁRIO",
      "pdf": "assets/pdf_nr/nr29.pdf"
    },
    {
      "title": "NR 30 - SEGURANÇA E SAÚDE NO TRABALHO AQUAVIÁRIO",
      "pdf": "assets/pdf_nr/nr30.pdf"
    },
    {
      "title":
          "NR 31 - SEGURANÇA E SAÚDE NO TRABALHO NA AGRICULTURA, PECUÁRIA, SILVICULTURA, EXPLORAÇÃO FLORESTAL E AQUICULTURA ",
      "pdf": "assets/pdf_nr/nr31.pdf"
    },
    {
      "title": "NR 32 - SEGURANÇA E SAÚDE NO TRABALHO EM SERVIÇOS DE SAÚDE",
      "pdf": "assets/pdf_nr/nr32.pdf"
    },
    {
      "title": "NR 33 - SEGURANÇA E SAÚDE NO TRABALHO EM ESPAÇOS CONFINADOS",
      "pdf": "assets/pdf_nr/nr33.pdf"
    },
    {
      "title":
          "NR 34 - CONDIÇÕES E MEIO DE TRABALHO NA INDÚSTRIA DA CONSTRUÇÃO, REPARAÇÃO E DESMONTE NAVAL",
      "pdf": "assets/pdf_nr/nr34.pdf"
    },
    {"title": "NR 35 - TRABALHO EM ALTURA", "pdf": "assets/pdf_nr/nr35.pdf"},
    {
      "title":
          "NR 36 - SEGURANÇA E SAÚDE NO TRABALHO EM EMPRESAS DE ABATE E PROCESSAMENTO DE CARNES E DERIVADOS",
      "pdf": "assets/pdf_nr/nr36.pdf"
    },
    {
      "title": "NR 37 - SEGURANÇA E SAÚDE EM PLATAFORMAS DE PETRÓLEO",
      "pdf": "assets/pdf_nr/nr37.pdf"
    },
    {
      "title":
          "NR 38 - SEGURANÇA E SAÚDE NO TRABALHO NAS ATIVIDADES DE LIMPEZA URBANA E MANEJO DE RESÍDUOS SÓLIDOS",
      "pdf": "assets/pdf_nr/nr38.pdf"
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

  // Extrair número da NR do título
  int? _getNrNumber(String title) {
    final match = RegExp(r'NR\s*(\d+)').firstMatch(title);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Normas Regulamentadoras'.toUpperCase(),
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
                  itemCount: nrs.length,
                  itemBuilder: (context, index) {
                    final ctaPositions = _getCtaPositions(nrs.length);
                    if (ctaPositions.contains(index)) {
                      return const RewardCTAWidget();
                    }

                    final nr = nrs[index];
                    final nrNumber = _getNrNumber(nr['title']!);
                    final isNew = nrNumber != null &&
                        _recentlyUpdatedNrs.contains(nrNumber);
                    final isFavorite = _favoritesCache[nr['pdf']!] ?? false;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              // Salva no histórico
                              await HistoryService.addToHistory(
                                type: 'nr',
                                title: nr['title']!,
                                path: nr['pdf']!,
                              );

                              // Navega para a NR
                              InterstitialAdManager.showInterstitialAd(
                                // ignore: use_build_context_synchronously
                                context,
                                NrBase(
                                  title: nr['title']!,
                                  pdfPath: nr['pdf']!,
                                ),
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
                                      nr['title']!.toUpperCase(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                        fontFamily: 'Segoe Bold',
                                      ),
                                    ),
                                  ),
                                  // Botão de favorito
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: isFavorite
                                          ? const Color(0xFFD32F2F)
                                          : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      if (isFavorite) {
                                        await FavoritesService.removeFavorite(
                                            nr['pdf']!);
                                      } else {
                                        await FavoritesService.addFavorite(
                                          type: 'nr',
                                          title: nr['title']!,
                                          path: nr['pdf']!,
                                        );
                                      }
                                      setState(() {
                                        _favoritesCache[nr['pdf']!] =
                                            !isFavorite;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Badge "NOVO"
                          if (isNew)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD32F2F),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'NOVO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Segoe Bold',
                                  ),
                                ),
                              ),
                            ),
                        ],
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
