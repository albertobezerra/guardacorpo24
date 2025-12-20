import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Sinalizacao extends StatelessWidget {
  const Sinalizacao({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);

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
          'SINALIZAÇÃO DE SEGURANÇA',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const _SinalizacaoContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _SinalizacaoContent extends StatelessWidget {
  const _SinalizacaoContent();

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _body(String text) => Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontSize: 14, height: 1.6),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'A sinalização de segurança orienta e protege trabalhadores, indicando perigos, proibições, rotas de fuga e equipamentos de emergência.\n',
        ),
        _title('Sinalização de perigo'),
        _body(
          'Adverte sobre situações, objetos ou ações que possam causar danos às pessoas ou às instalações.\n\n'
          'Características:\n'
          '• Forma triangular.\n'
          '• Pictograma preto sobre fundo amarelo, com borda preta.\n'
          '• A cor amarela deve ocupar pelo menos 50% da área da placa.\n',
        ),
        _title('Sinalização de proibição'),
        _body(
          'Visa impedir comportamentos que possam gerar riscos à segurança.\n\n'
          'Características:\n'
          '• Forma circular.\n'
          '• Pictograma preto sobre fundo branco, com borda e faixa vermelhas.\n'
          '• Faixa diagonal vermelha a 45°, descendo da esquerda para a direita.\n',
        ),
        _title('Sinalização de salvamento / emergência'),
        _body(
          'Indica saídas de emergência, rotas de fuga, locais de primeiros socorros e dispositivos de resgate.\n\n'
          'Características:\n'
          '• Forma retangular ou quadrada.\n'
          '• Pictograma branco sobre fundo verde.\n'
          '• O verde deve ocupar pelo menos 50% da área da placa.\n',
        ),
        _title('Sinalização de combate a incêndio'),
        _body(
          'Mostra a localização de equipamentos de combate a incêndio, como extintores, hidrantes e alarmes.\n\n'
          'Características:\n'
          '• Forma retangular ou quadrada.\n'
          '• Pictograma branco sobre fundo vermelho.\n'
          '• O vermelho deve ocupar pelo menos 50% da área da placa.\n',
        ),
      ],
    );
  }
}
