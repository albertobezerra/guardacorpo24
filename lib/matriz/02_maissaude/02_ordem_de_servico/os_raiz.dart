// lib/matriz/02_maissaude/02_ordem_de_servico/ordem_raiz.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_ordem_de_servico/os.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_ordem_de_servico/os_exemplo.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';

class OrdemRaiz extends StatelessWidget {
  const OrdemRaiz({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);
    final userProvider = Provider.of<UserProvider>(context);
    final canAccessPremium = userProvider.canAccessPremiumScreen();

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
          'ORDEM DE SERVIÇO',
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
            label: 'Sobre a Ordem de Serviço',
            icon: Icons.description_outlined,
            isPremium: false,
            onTap: () {
              InterstitialAdManager.showInterstitialAd(
                context,
                const Os(),
              );
            },
          ),
          _buildCard(
            context,
            label: 'Modelo de Ordem de Serviço',
            icon: Icons.picture_as_pdf_outlined,
            isPremium: true,
            onTap: () {
              if (canAccessPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrdemExemplo(),
                  ),
                );
              } else {
                _showPremiumDialog(context);
              }
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
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    const primary = Color(0xFF006837);

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
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                  )
                else
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

  void _showPremiumDialog(BuildContext context) {
    const primary = Color(0xFF006837);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber),
            SizedBox(width: 10),
            Text('Conteúdo Exclusivo'),
          ],
        ),
        content: const Text(
          'Este recurso é exclusivo para assinantes Premium. Deseja desbloquear agora?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumPage()),
              );
            },
            child: const Text(
              'Assinar Agora',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
