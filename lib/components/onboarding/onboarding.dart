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
      globalBackgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Fundo branco para todas as páginas
      pages: [
        PageViewModel(
          titleWidget: Container(), // Remover o título padrão
          bodyWidget: Container(), // Remover o corpo padrão
          image: Image.asset(
            'assets/images/onb1.png', // Imagem de fundo
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true, // Garante que a página ocupe toda a tela
            bodyFlex: 0, // Não usar flex para o corpo
            imageFlex: 1, // Usar flex para a imagem
            pageColor: Colors.transparent, // Cor de fundo transparente
          ),
        ),
        PageViewModel(
          titleWidget: Container(), // Remover o título padrão
          bodyWidget: Container(), // Remover o corpo padrão
          image: Image.asset(
            'assets/images/onb2.png', // Imagem de fundo
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true, // Garante que a página ocupe toda a tela
            bodyFlex: 0, // Não usar flex para o corpo
            imageFlex: 1, // Usar flex para a imagem
            pageColor: Colors.transparent, // Cor de fundo transparente
          ),
        ),
        PageViewModel(
          titleWidget: Container(), // Remover o título padrão
          bodyWidget: Container(), // Remover o corpo padrão
          image: Image.asset(
            'assets/images/onb3.png', // Imagem de fundo
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true, // Garante que a página ocupe toda a tela
            bodyFlex: 0, // Não usar flex para o corpo
            imageFlex: 1, // Usar flex para a imagem
            pageColor: Colors.transparent, // Cor de fundo transparente
          ),
        ),
        PageViewModel(
          titleWidget: Container(), // Remover o título padrão
          bodyWidget: Container(), // Remover o corpo padrão
          image: Image.asset(
            'assets/images/onb4.png', // Imagem de fundo
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true, // Garante que a página ocupe toda a tela
            bodyFlex: 0, // Não usar flex para o corpo
            imageFlex: 1, // Usar flex para a imagem
            pageColor: Colors.transparent, // Cor de fundo transparente
          ),
        ),
        PageViewModel(
          titleWidget: Container(), // Remover o título padrão
          bodyWidget: Container(), // Remover o corpo padrão
          image: Image.asset(
            'assets/images/onb5.png', // Imagem de fundo
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          decoration: const PageDecoration(
            fullScreen: true, // Garante que a página ocupe toda a tela
            bodyFlex: 0, // Não usar flex para o corpo
            imageFlex: 1, // Usar flex para a imagem
            pageColor: Colors.transparent, // Cor de fundo transparente
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
      skip: const Text("Pular",
          style: TextStyle(color: Colors.black)), // Pular em branco
      next: const Icon(Icons.arrow_forward,
          color: Colors.black), // Setas em branco
      done: const Text("Feito",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black)), // Feito em branco
      dotsDecorator: const DotsDecorator(
        color: Colors.black54, // Cor dos pontos
        activeColor: Colors.black, // Cor dos pontos ativos
        size: Size(6, 6), // Tamanho ajustado dos pontos
        activeSize: Size(10, 10), // Tamanho ajustado dos pontos ativos
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }
}
