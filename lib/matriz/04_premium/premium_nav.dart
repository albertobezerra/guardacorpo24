import 'package:flutter/material.dart';

class PremiumNavBarPage extends StatelessWidget {
  const PremiumNavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conteúdo Premium')),
      body: const Center(child: Text('Bem-vindo ao conteúdo premium!')),
    );
  }
}
