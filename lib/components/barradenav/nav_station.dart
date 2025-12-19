import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

// Imports das Telas
import 'package:guarda_corpo_2024/screens/home/home_screen.dart';
import 'package:guarda_corpo_2024/screens/profile/profile_screen.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import '../../services/provider/navigation_provider.dart';

class NavStation extends StatelessWidget {
  const NavStation({super.key});

  // Lista de Telas
  static const List<Widget> _screens = [
    HomeScreen(),
    PremiumPage(), // Aba do meio
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationState>(context);

    return Scaffold(
      // O IndexedStack mantém o estado das telas
      body: IndexedStack(
        index: nav.currentIndex,
        children: _screens,
      ),

      // Barra Flutuante
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              // CORRIGIDO: withValues em vez de withOpacity
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context,
              index: 0,
              icon: Icons.home_rounded,
              label: "Início",
              isSelected: nav.currentIndex == 0,
              onTap: () => nav.setIndex(0),
            ),
            _buildNavItem(
              context,
              index: 1,
              icon: Icons.workspace_premium_rounded,
              label: "Premium",
              isSelected: nav.currentIndex == 1,
              onTap: () => nav.setIndex(1),
            ),
            _buildNavItem(
              context,
              index: 2,
              icon: Icons.person_rounded,
              label: "Perfil",
              isSelected: nav.currentIndex == 2,
              onTap: () => nav.setIndex(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required int index,
      required IconData icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding:
            EdgeInsets.symmetric(horizontal: isSelected ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          // CORRIGIDO: withValues em vez de withOpacity
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[400],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
