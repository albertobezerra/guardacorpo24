import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapa_da_risco.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_mapaderisco/mapaexemplo.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';

class MapaRaiz extends StatelessWidget {
  const MapaRaiz({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF006837);

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
          'MAPA DE RISCO',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildCard(
            context,
            label: 'Sobre Mapa de Risco',
            icon: Icons.info_outline,
            onTap: () {
              InterstitialAdManager.showInterstitialAd(
                context,
                const MapaDaRisco(),
              );
            },
          ),
          _buildCard(
            context,
            label: 'Exemplo de Mapa de Risco',
            icon: Icons.picture_as_pdf_outlined,
            onTap: () {
              InterstitialAdManager.showInterstitialAd(
                context,
                const Mapaexemplo(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    const Color primary = Color(0xFF006837);

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
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: primary, size: 28),
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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
