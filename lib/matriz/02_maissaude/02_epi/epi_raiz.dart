import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_epi/epi.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_epi/epi_rela.dart';
import 'package:guarda_corpo_2024/services/admob/conf/interstitial_ad_manager.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class EpiRaiz extends StatelessWidget {
  const EpiRaiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'E.P.I',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _checkUserStatus(),
        builder: (context, snapshot) {
          final isPremium = snapshot.data?['isPremium'] ?? false;
          final planType = snapshot.data?['planType'] ?? '';

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildLargeTile(
                context,
                label: 'Sobre E.P.Is',
                icon: Icons.health_and_safety_outlined,
                isPremium: false,
                onTap: () {
                  // Conteúdo com anúncio
                  InterstitialAdManager.showInterstitialAd(
                    context,
                    const Epi(),
                  );
                },
              ),
              _buildLargeTile(
                context,
                label: 'Relatório Técnico de E.P.I',
                icon: Icons.picture_as_pdf_outlined,
                isPremium: true,
                onTap: () {
                  if (isPremium) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EpiRela()),
                    );
                  } else {
                    _showPremiumDialog(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLargeTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    final Color color = AppTheme.primaryColor;

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
            "Este recurso é exclusivo para assinantes Premium. Deseja desbloquear agora?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PremiumPage()),
                );
              },
              child: const Text(
                "Assinar Agora",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'isPremium': false, 'planType': ''};
    }
    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);
    return {
      'isPremium': subscriptionInfo['isPremium'] ?? false,
      'planType': subscriptionInfo['planType'] ?? '',
    };
  }
}
