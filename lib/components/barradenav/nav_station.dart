import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guarda_corpo_2024/screens/home/home_screen.dart';
import 'package:guarda_corpo_2024/screens/profile/profile_screen.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:provider/provider.dart';

class NavigationState extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavigationState>(context);
    final List<Widget> pages = [
      const HomeScreen(),
      const ProfileScreen(),
      const PremiumPage(),
    ];

    return Scaffold(
      extendBody: true, // Importante para o fundo passar por trás da barra
      backgroundColor: Colors.white,
      body: pages[navState.selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(24), // Margem para flutuar
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Borda totalmente redonda
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15), // Sombra destacada
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
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
            color: Colors.grey[500],
            tabs: const [
              GButton(icon: Icons.home_rounded, text: 'Início'),
              GButton(icon: Icons.person_rounded, text: 'Perfil'),
              GButton(
                  icon: Icons.workspace_premium_rounded,
                  text: 'Premium',
                  backgroundColor: Colors.amber), // Destaque Amarelo ou Rosa
            ],
            selectedIndex: navState.selectedIndex,
            onTabChange: (index) {
              navState.setIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
