import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Bem-vinde sou o Guarda Corpo!",
          body: "Seu aplicativo sobre Saúde e Segurança do Trabalho.",
          image: Image.asset('assets/images/logo.png', height: 175.0),
        ),
        PageViewModel(
          title: "Monitoramento em Tempo Real",
          body:
              "Receba atualizações e alertas em tempo real sobre sua saúde e segurança no trabalho.",
          image: const Icon(Icons.notifications_active,
              size: 100.0, color: Colors.green),
        ),
        PageViewModel(
          title: "Relatórios Detalhados",
          body:
              "Acesse relatórios detalhados e históricos para monitorar seu progresso.",
          image: const Icon(Icons.assessment, size: 100.0, color: Colors.blue),
        ),
        PageViewModel(
          title: "Precisamos de algumas permissões...",
          body:
              "Para oferecer a melhor experiência, permita o acesso às notificações.",
          image: const Icon(Icons.lock, size: 100.0, color: Colors.red),
        ),
        PageViewModel(
          title: "Pronto para começar?",
          body: "Vamos lá!",
          footer: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
            child: const Text("Iniciar"),
          ),
          image:
              const Icon(Icons.arrow_forward, size: 100.0, color: Colors.green),
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
}
