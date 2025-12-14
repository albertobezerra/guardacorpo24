import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

// Imports de Navegação
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/01_nrs/00_raizdasnrs.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/02_consultaCa/consulta_ca.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/03_treinamentos/00_treinamento_raiz.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/04_dds/00_dds_raiz.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cleanColor = AppTheme.primaryColor;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // MUDANÇA 1: Texto "Mais Buscados"
            child: Text("Mais Buscados",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436))),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView(
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              children: [
                _buildCleanMiniCard(
                    context,
                    "NRs",
                    Icons.gavel,
                    cleanColor,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NrsRaiz()))),

                _buildCleanMiniCard(
                    context,
                    "CA",
                    Icons.search,
                    cleanColor,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ConsultaCa()))),

                // MUDANÇA 2: Texto "Treinamentos" (pode quebrar linha se for muito grande, fonte ajustada)
                _buildCleanMiniCard(
                    context,
                    "Treinamentos",
                    Icons.school,
                    cleanColor,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TreinamentoRaiz()))),

                _buildCleanMiniCard(
                    context,
                    "DDS",
                    Icons.chat_bubble_outline,
                    cleanColor,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const DdsRaiz()))),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            // MUDANÇA 3: Texto mais adequado
            child: Text("Recursos de Segurança",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436))),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCleanMiniCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12, bottom: 5),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            // Ajuste de fonte para caber "Treinamentos"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12, // Reduzi levemente para caber palavras maiores
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
