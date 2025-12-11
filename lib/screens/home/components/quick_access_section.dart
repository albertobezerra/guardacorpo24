import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports de Navegação
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/01_nrs/00_raizdasnrs.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/02_consultaCa/consulta_ca.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/03_treinamentos/00_treinamento_raiz.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/04_dds/00_dds_raiz.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Acesso Rápido",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436))),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              children: [
                _buildMiniCard(
                    context,
                    "NRs",
                    Icons.gavel,
                    Colors.blue,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const NrsRaiz()))),
                _buildMiniCard(
                    context,
                    "CA",
                    Icons.search,
                    Colors.green,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ConsultaCa()))),
                _buildMiniCard(
                    context,
                    "Treinos",
                    Icons.school,
                    Colors.orange,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TreinamentoRaiz()))),
                _buildMiniCard(
                    context,
                    "DDS",
                    Icons.chat,
                    Colors.purple,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const DdsRaiz()))),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Saúde e Segurança",
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

  Widget _buildMiniCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
