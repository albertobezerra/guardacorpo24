import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/components/customizacao/modern_list_tile.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/services/history/history_service.dart';
import 'package:guarda_corpo_2024/services/favorites/favorites_service.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import '01_nr_base.dart';

class NrsRaiz extends StatefulWidget {
  const NrsRaiz({super.key});

  @override
  State<NrsRaiz> createState() => _NrsRaizState();
}

class _NrsRaizState extends State<NrsRaiz> {
  final Set<int> _recentlyUpdatedNrs = {38};
  final Map<String, bool> _favoritesCache = {};
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredNrs = [];

  final List<Map<String, String>> nrs = [
    {
      "title":
          "NR 1 - DISPOSIÇÕES GERAIS E GERENCIAMENTO DE RISCOS OCUPACIONAIS",
      "pdf": "assets/pdf_nr/nr1.pdf"
    },
    {
      "title": "NR 2 - INSPEÇÃO PRÉVIA (REVOGADA)",
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
      "title": "NR 15 - ATIVIDADES E OPERAÇÕES INSALUBRES",
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

  @override
  void initState() {
    super.initState();
    _filteredNrs = nrs;
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    for (var nr in nrs) {
      final isFav = await FavoritesService.isFavorite(nr['pdf']!);
      if (!mounted) return;
      setState(() {
        _favoritesCache[nr['pdf']!] = isFav;
      });
    }
  }

  void _filterNrs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNrs = nrs;
      } else {
        _filteredNrs = nrs.where((nr) {
          return nr['title']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  List<int> _getCtaPositions(int totalItems) {
    if (totalItems <= 10) return [];
    if (totalItems <= 20) return [totalItems ~/ 2];
    if (totalItems <= 50) {
      return [(totalItems * 0.3).round(), (totalItems * 0.7).round()];
    }
    return [
      (totalItems * 0.25).round(),
      (totalItems * 0.5).round(),
      (totalItems * 0.75).round(),
    ];
  }

  int? _getNrNumber(String title) {
    final match = RegExp(r'NR\s*(\d+)').firstMatch(title);
    if (match != null) return int.tryParse(match.group(1)!);
    return null;
  }

  int _dataIndexFromDisplayIndex(int displayIndex, List<int> ctaPositions) {
    int dataIndex = displayIndex;
    for (final ctaIndex in ctaPositions) {
      if (ctaIndex < displayIndex) {
        dataIndex--;
      } else {
        break;
      }
    }
    return dataIndex;
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.isNotEmpty;

    // Importante: CTA baseado na lista original (nrs) para manter as posições fixas
    final List<int> ctaPositions =
        isSearching ? <int>[] : _getCtaPositions(nrs.length);

    final int displayItemCount =
        isSearching ? _filteredNrs.length : nrs.length + ctaPositions.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Normas Regulamentadoras",
          style: GoogleFonts.poppins(
            color: const Color(0xFF2D3436),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF2D3436), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNrs,
              decoration: InputDecoration(
                hintText: "Buscar NR (ex: 35, CIPA...)",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.primaryColor),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: displayItemCount,
              itemBuilder: (context, displayIndex) {
                // 1) Se for CTA, renderiza e sai
                if (!isSearching && ctaPositions.contains(displayIndex)) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: RewardCTAWidget(),
                  );
                }

                // 2) Caso contrário, mapear índice de exibição -> índice real
                final int dataIndex = isSearching
                    ? displayIndex
                    : _dataIndexFromDisplayIndex(displayIndex, ctaPositions);

                final nr =
                    isSearching ? _filteredNrs[dataIndex] : nrs[dataIndex];

                final nrNumber = _getNrNumber(nr['title']!);
                final isNew =
                    nrNumber != null && _recentlyUpdatedNrs.contains(nrNumber);
                final isFavorite = _favoritesCache[nr['pdf']!] ?? false;

                String cleanTitle = nr['title']!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ModernListTile(
                        badgeText: nrNumber != null ? "NR $nrNumber" : "NR",
                        icon: Icons.article,
                        title: cleanTitle,
                        subtitle: "Toque para ler o documento completo",
                        onTap: () async {
                          await HistoryService.addToHistory(
                            type: 'nr',
                            title: nr['title']!,
                            path: nr['pdf']!,
                          );

                          if (!context.mounted) return; // <- resolve o lint
                          //TODO: Verificar se é melhor usar Navigator.push aqui

                          InterstitialAdManager.showInterstitialAd(
                            context,
                            NrBase(title: nr['title']!, pdfPath: nr['pdf']!),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite
                                ? const Color(0xFFD32F2F)
                                : Colors.grey,
                          ),
                          onPressed: () async {
                            if (isFavorite) {
                              await FavoritesService.removeFavorite(nr['pdf']!);
                            } else {
                              await FavoritesService.addFavorite(
                                type: 'nr',
                                title: nr['title']!,
                                path: nr['pdf']!,
                              );
                            }
                            if (!mounted) return; // <- importante após awaits

                            setState(() {
                              _favoritesCache[nr['pdf']!] = !isFavorite;
                            });
                          },
                        ),
                      ),
                      if (isNew)
                        Positioned(
                          right: -5,
                          top: -5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD32F2F),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: const Text(
                              'NOVO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
