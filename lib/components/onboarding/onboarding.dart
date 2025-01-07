import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';

// Função para estilizar botões com outline
ButtonStyle outlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.white),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ).copyWith(
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor:
          const Color(0xFF4CAF50), // Fundo verde para todas as páginas
      pages: [
        PageViewModel(
          title: "Bem-vinde ao Guarda Corpo!",
          body: "Seu aplicativo para saúde e segurança no trabalho.",
          image: _buildImage('assets/images/logo.png'),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Monitoramento em Tempo Real",
          body:
              "Receba atualizações e alertas em tempo real sobre saúde e segurança no trabalho.",
          image: _buildImage('assets/images/monitoramento.png'),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Relatórios Detalhados",
          body:
              "Acesse relatórios detalhados e históricos para monitorar o progresso.",
          image: _buildImage('assets/images/relatorios.png'),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Precisamos de algumas permissões...",
          body:
              "Para oferecer a melhor experiência, permita o acesso às notificações.",
          image: _buildImage('assets/images/permissoes.png'),
          decoration: _getPageDecoration(),
          footer: OutlinedButton(
            style: outlinedButtonStyle(), // Aplica o estilo outlined do botão
            onPressed: () {
              // Lógica para pedir permissões
            },
            child: const Text("Conceder Permissões"),
          ),
        ),
        PageViewModel(
          title: "Pronte para começar?",
          body: "Vamos lá!",
          image: _buildImage('assets/images/comecar.png'),
          decoration: _getPageDecoration(),
          footer: OutlinedButton(
            style: outlinedButtonStyle(), // Aplica o estilo outlined do botão
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
            child: const Text("Iniciar"),
          ),
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      },
      showSkipButton: true,
      skip: const Text("Pular"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Feito", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildImage(String assetName) {
    return Center(
        child: Image.asset(assetName, width: 350.0)); // Centraliza a imagem
  }

  PageDecoration _getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16.0,
        color: Colors.white,
      ),
      imageAlignment: Alignment.center, // Alinha a imagem no centro
      imagePadding: EdgeInsets.all(24.0),
      contentMargin: EdgeInsets.all(16.0),
      pageColor: Color(0xFF4CAF50), // Fundo verde
    );
  }
}
