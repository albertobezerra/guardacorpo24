import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class RewardStoreScreen extends StatelessWidget {
  const RewardStoreScreen({super.key});

  final Color primaryColor = const Color(0xFF006837);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    bool canActivateAdFree() {
      return userProvider.rewardPoints >= 100 &&
          !(userProvider.hasRewardActive &&
              userProvider.planType == 'ad_free_reward') &&
          !userProvider.hasActivePremiumReward;
    }

    bool canActivatePremium() {
      return userProvider.rewardPoints >= 400 &&
          !(userProvider.hasRewardActive &&
              userProvider.planType == 'reward_full_access');
    }

    String formatDate(DateTime? date) {
      if (date == null) return 'N/A';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'LOJA DE PONTOS',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Saldo Atual",
                          style: GoogleFonts.poppins(
                              color: Colors.grey[600], fontSize: 12)),
                      Text("${userProvider.rewardPoints} Pts",
                          style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.stars_rounded, color: Colors.amber, size: 40),
                ],
              ),
            ),

            if (userProvider.hasRewardActive) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text("Recompensa Ativa",
                        style: GoogleFonts.poppins(
                            color: primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(userProvider.planDisplayName,
                        style: GoogleFonts.poppins(fontSize: 16)),
                    Text(
                      'Válida até: ${formatDate(userProvider.rewardExpiryDate)}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
            Text("Trocar Pontos",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            _buildOfferCard(
              context,
              title: "7 Dias Sem Anúncios",
              cost: 100,
              icon: Icons.block_flipped,
              canBuy: canActivateAdFree(),
              onTap: () => _confirmAndActivate(
                context: context,
                userProvider: userProvider,
                title: '7 dias sem anúncios',
                cost: 100,
                type: 'ad_free_reward',
                days: 7,
              ),
            ),

            const SizedBox(height: 12),

            _buildOfferCard(
              context,
              title: "14 Dias Premium",
              cost: 400,
              icon: Icons.diamond_outlined,
              canBuy: canActivatePremium(),
              onTap: () => _confirmAndActivate(
                context: context,
                userProvider: userProvider,
                title: '14 dias premium',
                cost: 400,
                type: 'reward_full_access',
                days: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context,
      {required String title,
      required int cost,
      required IconData icon,
      required bool canBuy,
      required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: canBuy ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: canBuy
                        ? primaryColor.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: canBuy ? primaryColor : Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: canBuy ? Colors.black87 : Colors.grey)),
                      Text("$cost Pontos",
                          style: GoogleFonts.poppins(
                              color: canBuy ? primaryColor : Colors.grey,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmAndActivate({
    required BuildContext context,
    required UserProvider userProvider,
    required String title,
    required int cost,
    required String type,
    required int days,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirmar Troca',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Deseja trocar $cost pontos por:\n$title?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await userProvider.activateReward(
                  cost: cost, type: type, days: days);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ativado: $title'),
                  backgroundColor: primaryColor,
                ),
              );
            },
            child: Text('Confirmar',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
