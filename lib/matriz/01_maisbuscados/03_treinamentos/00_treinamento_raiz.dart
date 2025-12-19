import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Certifique-se de ter este pacote
import 'package:guarda_corpo_2024/components/customizacao/modern_list_tile.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import '../../../services/admob/conf/interstitial_ad_manager.dart';
import '01_treinamento_base.dart';

class TreinamentoRaiz extends StatefulWidget {
  const TreinamentoRaiz({super.key});

  @override
  State<TreinamentoRaiz> createState() => _TreinamentoRaizState();
}

class _TreinamentoRaizState extends State<TreinamentoRaiz> {
  // Cor padrão do tema
  final Color primaryColor = const Color(0xFF006837);

  final List<Map<String, String>> treinamentos = [
    {
      "title": "Uso de EPI e EPC",
      "content":
          "No treinamento de Uso de EPI e EPC aborde os seguintes subtemas:\n\n• Necessidades do uso do EPI e do EPC.\n• Diferenças entre o EPI e o EPC.\n• Uso correto destes equipamentos.\n• Manutenção e Trocas.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 6 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Condições Sanitárias",
      "content":
          "No treinamento de Condições Sanitárias aborde os seguintes subtemas:\n\n• Dimensionamento.\n• Uso correto.\n• Manuntenção.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 24 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Materiais Químicos",
      "content":
          "No treinamento de Materiais Químicos aborde os seguintes subtemas:\n\n• Profissional Capacitado para a manipulação.\n• Transporte, Movimentação, Armazenagem e Manuseio.\n• Contaminação.\n• FISPQ.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 11 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Riscos da Função",
      "content":
          "No treinamento de Riscos da Função aborde os seguintes subtemas:\n\n• Tipos de riscos.\n• Complicações.\n• Formas de controle.\n• Prevenção.\n• Ordem de Serviço.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 1 e 9 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Foco na atividade",
      "content":
          "No treinamento de Foco na atividade aborde os seguintes subtemas:\n\n• Tipos da atividade pertencentes a sua empresa.\n• Ritmo do trabalho.\n• Uso do EPI.\n• Brincadeiras no trabalho.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 1 e 9 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Insalubridade e Periculosidade",
      "content":
          "No treinamento de Insalubridade e Periculosidade aborde os seguintes subtemas:\n\n• Fundamentação sobre Insalubridade e Periculosidade. \n• Percentual de Insalubridade e Periculosidade.\n• Quais locais de trabalho se aplica Insalubridade e Periculosidade. \n• Mostre que os percetuais não são favoravéis quando se olha para a saúde.\n\nUtilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 15 e 16 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Sinalizaçao de Segurança",
      "content":
          "No treinamento de Sinalizaçao de Segurança aborde os seguintes subtemas:\n\n• A importância da sinalizaçao.\n• Tipos de Sinalização.\n• Cores na Sinalização.\n• Acidentes frequentes por não respeitar à sinalização.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 26 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Controle de Perdas",
      "content":
          "No treinamento de Controle de Perdas aborde os seguintes subtemas:\n\n• Prazos e Validades.\n• Sistema de reposição de produtos.\n• Produtos vencidos.\n• Formas de armazenamento e transporte.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 11 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Absenteísmo e Assiduidade",
      "content":
          "No treinamento de Absenteísmo e Assiduidade aborde os seguintes subtemas:\n\n• Jornada de trabalho.\n• Pausas, intervalos, horário de almoço.\n• Produtividade.\n• Falta justificada, não justificada, folga lei, penalidades.\n\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos.\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 11 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Acidente de Trabalho",
      "content":
          "No treinamento de Acidente de Trabalho aborde os seguintes subtemas:\n\n• Acidente de trabalho.\n• Acidente de trajeto.\n• Doença do trabalho.\n• Auxílio doença versus Auxílio Acidentário.\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "Exames ocupacionais e ASO",
      "content":
          "No treinamento de Exames ocupacionais e ASO aborde os seguintes subtemas:\n\n• Sua aplicação.\n• Os tipos de exames e suas características.\n• Os exames para as funções.\n• ASO.\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 7 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
    },
    {
      "title": "LER e DORT",
      "content":
          "No treinamento de LER e DORT aborde os seguintes subtemas:\n\n• A ergonomia no ambiete de trabalho.\n• Movimentos repetitivos.\n• Doenças do trabalho.\n• LER/DORT.\n\nOBS: na formulação deste treinamento leve em consideração as condições de sua empresa, os problemas mais frequentes. Utilize imagens, colaboradores querem mais imagens e menos textos. Tome a NR 17 para fundamentar sua apresentação e NBRs pertinentes ao tema.\n\nO foco do módulo de treinamento não é disponibilizar um treinamento específico, mas auxiliar o ministrante do treinamento no que deve ser levado em consideração em seu treinamento."
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
    return Scaffold(
      backgroundColor: Colors.white, // Fundo Clean
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Treinamentos'.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: treinamentos.length,
              itemBuilder: (context, index) {
                final ctaPositions = _getCtaPositions(treinamentos.length);

                // Widget de Recompensa intercalado
                if (ctaPositions.contains(index)) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const RewardCTAWidget(),
                  );
                }

                // Usando o novo Componente Padrão
                return ModernListTile(
                  title: treinamentos[index]["title"]!.toUpperCase(),
                  subtitle: "Toque para ver o conteúdo programático",
                  icon: Icons.menu_book_rounded,
                  iconColor: primaryColor,
                  onTap: () async {
                    InterstitialAdManager.showInterstitialAd(
                      context,
                      TreinamentoBase(
                        title: treinamentos[index]["title"]!,
                        content: treinamentos[index]["content"]!,
                      ),
                    );
                  },
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
