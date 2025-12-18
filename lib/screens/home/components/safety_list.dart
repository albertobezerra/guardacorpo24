import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../services/provider/userProvider.dart';
import '../../../services/admob/conf/interstitial_ad_manager.dart';
import '../../../components/reward_cta_widget.dart';

// Imports "Mais Buscados" (ADICIONADOS AQUI)
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/01_nrs/00_raizdasnrs.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/02_consultaCa/consulta_ca.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/03_treinamentos/00_treinamento_raiz.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/04_dds/00_dds_raiz.dart';

// Imports Originais
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_acidente/acidente_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_epi/epi_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_incendio/incendio_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/view_inspecoes.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapa_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_ordem_de_servico/os_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_analise_ergonomica/aet_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/cnpj2.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/pgr.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/aso.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/clt.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/cnae.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/nbrs.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/nho_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/ppp.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/primeiros_soc_raiz.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/riscoamb.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/cipa.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/datas.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/esocial.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/historia.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/sinalizacao.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/tecnico.dart';

class SafetyList extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onItemTap;
  final VoidCallback? onSearchClear;

  const SafetyList({
    super.key,
    this.searchQuery = "",
    this.onItemTap,
    this.onSearchClear,
  });

  String _normalizeText(String str) {
    String normalized = str.toLowerCase();
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < withDia.length; i++) {
      normalized = normalized.replaceAll(withDia[i], withoutDia[i]);
    }
    normalized =
        normalized.replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
    return normalized;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Lista "Mais Buscados" (Invisíveis na lista principal, mas visíveis na busca)
    final List<Map<String, dynamic>> quickAccessItems = [
      {
        'icon': Icons.gavel,
        'label': 'NRs - Normas Regulamentadoras',
        'screen': const NrsRaiz()
      },
      {
        'icon': Icons.search,
        'label': 'Consulta CA - EPIs',
        'screen': const ConsultaCa()
      },
      {
        'icon': Icons.school,
        'label': 'Treinamentos',
        'screen': const TreinamentoRaiz()
      },
      {
        'icon': Icons.chat_bubble_outline,
        'label': 'DDS - Diálogos de Segurança',
        'screen': const DdsRaiz()
      },
    ];

    // Lista Original
    final List<Map<String, dynamic>> originalItems = [
      {
        'icon': Icons.healing_outlined,
        'label': 'Acidentes',
        'screen': const AcidenteRaiz()
      },
      {
        'icon': Icons.accessibility_new,
        'label': 'Ergonomia (AET)',
        'screen': const AETModule()
      },
      {
        'icon': Icons.health_and_safety_outlined,
        'label': 'A.S.O',
        'screen': const Aso()
      },
      {'icon': Icons.gavel, 'label': 'C.L.T', 'screen': const Clt()},
      {'icon': Icons.groups_outlined, 'label': 'Cipa', 'screen': const Cipa()},
      {'icon': Icons.search, 'label': 'Consulta CNAE', 'screen': const Cnae()},
      {
        'icon': Icons.business,
        'label': 'Consulta CNPJ',
        'screen': const Cnpj2()
      },
      {
        'icon': Icons.calendar_month,
        'label': 'Datas Importantes',
        'screen': const Datas()
      },
      {'icon': Icons.masks, 'label': 'E.P.I', 'screen': const EpiRaiz()},
      {'icon': Icons.computer, 'label': 'E-Social', 'screen': const Esocial()},
      {
        'icon': Icons.history_edu,
        'label': 'História SST',
        'screen': const Historia()
      },
      {
        'icon': Icons.local_fire_department,
        'label': 'Incêndio',
        'screen': const IncendioRaiz()
      },
      {
        'icon': Icons.checklist_rtl,
        'label': 'Inspeção',
        'screen': const ViewInspecoes(),
        'isPremium': true
      },
      {
        'icon': Icons.map_outlined,
        'label': 'Mapa de Risco',
        'screen': const MapaRaiz()
      },
      {'icon': Icons.menu_book, 'label': 'NBRs', 'screen': const Nbrs()},
      {
        'icon': Icons.science_outlined,
        'label': 'Higiene Ocupacional',
        'screen': const Nho()
      },
      {
        'icon': Icons.description_outlined,
        'label': 'Ordem de Serviço',
        'screen': const OrdemRaiz()
      },
      {'icon': Icons.folder_shared, 'label': 'P.P.P', 'screen': const Ppp()},
      {
        'icon': Icons.assignment_outlined,
        'label': 'PGR / GRO',
        'screen': const Pgr()
      },
      {
        'icon': Icons.medical_services_outlined,
        'label': 'Primeiros Socorros',
        'screen': const PrimeirosSocRz()
      },
      {
        'icon': Icons.warning_amber,
        'label': 'Riscos Ambientais',
        'screen': const Riscoamb()
      },
      {
        'icon': Icons.traffic,
        'label': 'Sinalização',
        'screen': const Sinalizacao()
      },
      {
        'icon': Icons.engineering,
        'label': 'Técnico TST',
        'screen': const Tecnico()
      },
    ];

    // Lógica para Exibir:
    // Se estiver buscando: junta tudo (Quick + Original) e filtra
    // Se não estiver buscando: mostra só a lista Original (pois Quick já aparece no carrossel)

    List<Map<String, dynamic>> itemsToShow;

    if (searchQuery.isNotEmpty) {
      // BUSCA ATIVA: Junta tudo para procurar em todos
      final allItemsCombined = [...quickAccessItems, ...originalItems];
      itemsToShow = allItemsCombined.where((item) {
        final String label = _normalizeText(item['label'].toString());
        final String query = _normalizeText(searchQuery);
        return label.contains(query);
      }).toList();
    } else {
      // SEM BUSCA: Mostra só a lista original (o carrossel cuida dos outros)
      itemsToShow = originalItems;
    }

    final ctaPositions =
        searchQuery.isEmpty ? _getCtaPositions(itemsToShow.length) : [];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= itemsToShow.length) return null;

            final item = itemsToShow[index];
            final bool showCta = ctaPositions.contains(index);

            return Column(
              children: [
                if (showCta)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: RewardCTAWidget(),
                  ),
                _buildLargeListTile(
                  context,
                  label: item['label'],
                  icon: item['icon'],
                  color: AppTheme.primaryColor,
                  isPremium: item['isPremium'] == true,
                  onTap: () async {
                    onItemTap?.call(); // Fecha teclado

                    if (item['isPremium'] == true) {
                      if (userProvider.canAccessPremiumScreen()) {
                        // Usuário TEM acesso, entra na tela
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => item['screen']));
                      } else {
                        // Usuário NÃO tem acesso -> Mostrar Dialog ou ir para Premium
                        _showPremiumDialog(context);
                      }
                    } else {
                      // Item Grátis (com anúncio)
                      InterstitialAdManager.showInterstitialAd(
                          context, item['screen']);
                    }

                    onSearchClear?.call();
                  },
                ),
              ],
            );
          },
          childCount: itemsToShow.length,
        ),
      ),
    );
  }

  Widget _buildLargeListTile(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      bool isPremium = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline_rounded,
                        color: Colors.amber, size: 20),
                  )
                else
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> _getCtaPositions(int totalItems) {
    if (totalItems <= 10) {
      return [];
    } else if (totalItems <= 20)
      // ignore: curly_braces_in_flow_control_structures
      return [totalItems ~/ 2];
    else if (totalItems <= 50)
      // ignore: curly_braces_in_flow_control_structures
      return [(totalItems * 0.3).round(), (totalItems * 0.7).round()];
    else
      // ignore: curly_braces_in_flow_control_structures
      return [
        (totalItems * 0.25).round(),
        (totalItems * 0.5).round(),
        (totalItems * 0.75).round()
      ];
  }

  // Função para mostrar o Dialog de Premium
  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.amber),
              SizedBox(width: 10),
              Text("Conteúdo Exclusivo"),
            ],
          ),
          content: const Text(
            "Este recurso é exclusivo para assinantes Premium. Deseja desbloquear tudo agora?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Fechar
              child:
                  const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o dialog
                // Navega para a tela de venda (PremiumPage)
                // Certifique-se de importar sua PremiumPage no topo se não estiver
                // import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';

                // Se você usa navegação por índice na BottomBar (Recomendado):
                // Provider.of<NavigationState>(context, listen: false).setIndex(2);

                // OU Navegação direta (Mais simples):
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const PremiumPage()) // Certifique-se que PremiumPage existe
                    );
              },
              child: const Text("Assinar Agora",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
