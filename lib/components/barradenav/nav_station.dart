// lib/components/barradenav/nav_station.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guarda_corpo_2024/screens/home/home_screen.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:guarda_corpo_2024/screens/profile/profile_screen.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_ads_screen.dart'; // Import da tela de recompensas
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';

// MANTENDO SEU NAVIGATION STATE
class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  // Lista de Páginas
  final List<Widget> _pages = [
    const HomeScreen(), // Index 0: Home/Raiz
    const ProfileScreen(), // Index 1: Perfil
    const PremiumPage(), // Index 2: Premium
  ];

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);

    // Verificação de segurança para o índice
    final int safeIndex =
        navState.selectedIndex >= _pages.length ? 0 : navState.selectedIndex;

    return Scaffold(
      backgroundColor:
          Colors.white, // Garante fundo branco para transições limpas

      // CORPO DO APP
      body: IndexedStack(
        index: safeIndex,
        children: _pages,
      ),

      // NOVA BARRA DE NAVEGAÇÃO
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppTheme.primaryColor,
              color: Colors.grey[600],
              tabs: [
                const GButton(
                  icon: Icons.home_rounded,
                  text: 'Início',
                ),
                const GButton(
                  icon: Icons.person_rounded,
                  text: 'Perfil',
                ),
                GButton(
                  icon: Icons.star_rounded,
                  text: 'Premium',
                  // Cor especial para o botão Premium quando ativo
                  backgroundColor: navState.selectedIndex == 2
                      ? const Color(0xFFD81B60) // Rosa Premium
                      : AppTheme.primaryColor,
                ),
                // Botão de Recompensas (Ação Direta)
                GButton(
                  icon: Icons.card_giftcard,
                  text: 'Prêmios',
                  onPressed: () {
                    // Navega direto sem mudar o index da BottomBar
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RewardAdsScreen()));
                  },
                ),
              ],
              selectedIndex: safeIndex,
              onTabChange: (index) {
                // Se for o índice 3 (Prêmios), não mudamos o estado aqui pois o onPressed já tratou
                if (index != 3) {
                  Provider.of<NavigationState>(context, listen: false)
                      .setIndex(index);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
