import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../../../services/provider/userProvider.dart';
import '../../../services/admob/conf/interstitial_ad_manager.dart';
import '../../../components/reward_cta_widget.dart';

// Imports de Destino
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
  const SafetyList({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Lista de Itens
    final List<Map<String, dynamic>> itens = [
      {
        'icon': Icons.healing_outlined,
        'label': 'Acidentes',
        'screen': const AcidenteRaiz(),
        'color': Colors.red
      },
      {
        'icon': Icons.accessibility_new,
        'label': 'Ergonomia (AET)',
        'screen': const AETModule(),
        'color': Colors.blue
      },
      {
        'icon': Icons.health_and_safety_outlined,
        'label': 'A.S.O',
        'screen': const Aso(),
        'color': Colors.teal
      },
      {
        'icon': Icons.gavel,
        'label': 'C.L.T',
        'screen': const Clt(),
        'color': Colors.brown
      },
      {
        'icon': Icons.groups_outlined,
        'label': 'Cipa',
        'screen': const Cipa(),
        'color': Colors.indigo
      },
      {
        'icon': Icons.search,
        'label': 'Consulta CNAE',
        'screen': const Cnae(),
        'color': Colors.blueGrey
      },
      {
        'icon': Icons.business,
        'label': 'Consulta CNPJ',
        'screen': const Cnpj2(),
        'color': Colors.blueGrey
      },
      {
        'icon': Icons.calendar_month,
        'label': 'Datas Importantes',
        'screen': const Datas(),
        'color': Colors.orange
      },
      {
        'icon': Icons.masks,
        'label': 'E.P.I',
        'screen': const EpiRaiz(),
        'color': Colors.deepOrange
      },
      {
        'icon': Icons.computer,
        'label': 'E-Social',
        'screen': const Esocial(),
        'color': Colors.purple
      },
      {
        'icon': Icons.history_edu,
        'label': 'História SST',
        'screen': const Historia(),
        'color': Colors.amber
      },
      {
        'icon': Icons.local_fire_department,
        'label': 'Incêndio',
        'screen': const IncendioRaiz(),
        'color': Colors.redAccent
      },
      {
        'icon': Icons.checklist_rtl,
        'label': 'Inspeção',
        'screen': const ViewInspecoes(),
        'isPremium': true,
        'color': Colors.green
      },
      {
        'icon': Icons.map_outlined,
        'label': 'Mapa de Risco',
        'screen': const MapaRaiz(),
        'color': Colors.lime
      },
      {
        'icon': Icons.menu_book,
        'label': 'NBRs',
        'screen': const Nbrs(),
        'color': Colors.grey
      },
      {
        'icon': Icons.science_outlined,
        'label': 'Higiene Ocupacional',
        'screen': const Nho(),
        'color': Colors.cyan
      },
      {
        'icon': Icons.description_outlined,
        'label': 'Ordem de Serviço',
        'screen': const OrdemRaiz(),
        'color': Colors.blueAccent
      },
      {
        'icon': Icons.folder_shared,
        'label': 'P.P.P',
        'screen': const Ppp(),
        'color': Colors.indigoAccent
      },
      {
        'icon': Icons.assignment_outlined,
        'label': 'PGR / GRO',
        'screen': const Pgr(),
        'color': Colors.deepPurple
      },
      {
        'icon': Icons.medical_services_outlined,
        'label': 'Primeiros Socorros',
        'screen': const PrimeirosSocRz(),
        'color': Colors.pink
      },
      {
        'icon': Icons.warning_amber,
        'label': 'Riscos Ambientais',
        'screen': const Riscoamb(),
        'color': Colors.orangeAccent
      },
      {
        'icon': Icons.traffic,
        'label': 'Sinalização',
        'screen': const Sinalizacao(),
        'color': Colors.yellow[800]
      },
      {
        'icon': Icons.engineering,
        'label': 'Técnico TST',
        'screen': const Tecnico(),
        'color': Colors.brown
      },
    ];

    final ctaPositions = _getCtaPositions(itens.length);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= itens.length) return null;

            final item = itens[index];
            final bool showCta = ctaPositions.contains(index);

            return Column(
              children: [
                if (showCta)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: RewardCTAWidget(),
                  ),
                _buildListTile(context,
                    label: item['label'],
                    icon: item['icon'],
                    color: item['color'] ?? AppTheme.primaryColor,
                    isPremium: item['isPremium'] == true, onTap: () {
                  if (item['isPremium'] == true) {
                    if (userProvider.canAccessPremiumScreen()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => item['screen']));
                    } else {
                      Navigator.pushNamed(context, '/premium');
                    }
                  } else {
                    InterstitialAdManager.showInterstitialAd(
                        context, item['screen']);
                  }
                }),
              ],
            );
          },
          childCount: itens.length,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      bool isPremium = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: isPremium
            ? const Icon(Icons.lock, color: Colors.amber, size: 20)
            : Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
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
}
