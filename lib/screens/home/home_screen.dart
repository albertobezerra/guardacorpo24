import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/screens/home/components/home_header.dart';
import 'package:guarda_corpo_2024/screens/home/components/quick_access_section.dart';
import 'package:guarda_corpo_2024/screens/home/components/safety_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          HomeHeader(), // Componente 1: Header Verde
          QuickAccessSection(), // Componente 2: Cards Horizontais
          SafetyList(), // Componente 3: Lista Vertical Longa
          SliverToBoxAdapter(
              child: SizedBox(height: 50)), // Espaço extra no final
        ],
      ),
    );
  }
}
