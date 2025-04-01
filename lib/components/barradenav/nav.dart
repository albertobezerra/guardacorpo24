import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz_mestra.dart';
import 'package:guarda_corpo_2024/matriz/03_sua_area/03_00_suaconta.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  NavBarPageState createState() => NavBarPageState();
}

class NavBarPageState extends State<NavBarPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _pages = [
    const Raiz(),
    const SuaConta(),
    const PremiumPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.hasActiveSubscription()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Você já é premium!')),
          );
        }
        return;
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        floatingActionButton: SpeedDial(
          icon: null,
          backgroundColor: Colors.white,
          foregroundColor: const Color.fromARGB(255, 0, 77, 41),
          activeIcon: Icons.close,
          spacing: 12,
          children: [
            SpeedDialChild(
              labelWidget: _buildLabelWidget(Icons.home_rounded, 'Home',
                  const Color.fromARGB(255, 0, 104, 55)),
              backgroundColor: const Color.fromARGB(255, 0, 104, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onTap: () => _onItemTapped(0),
            ),
            SpeedDialChild(
              labelWidget: _buildLabelWidget(Icons.person, 'Sua Conta',
                  const Color.fromARGB(255, 0, 104, 55)),
              backgroundColor: const Color.fromARGB(255, 0, 104, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onTap: () => _onItemTapped(1),
            ),
            SpeedDialChild(
              labelWidget: _buildLabelWidget(Icons.star_rounded, 'Premium',
                  const Color.fromARGB(255, 216, 27, 96)),
              backgroundColor: const Color.fromARGB(255, 216, 27, 96),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onTap: () => _onItemTapped(2),
            ),
          ],
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.elasticIn,
            )),
            child: const Icon(Icons.menu),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWidget(IconData icon, String label, Color backgroundColor) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 26,
            ),
            const SizedBox(width: 8.0),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Segoe',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
