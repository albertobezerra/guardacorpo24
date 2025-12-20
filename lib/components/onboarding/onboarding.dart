import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final Color primaryColor = const Color(0xFF006837);

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
    await prefs.setBool('hasShownSplash', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  PageViewModel _buildPage({
    required String imagePath,
    required String title,
    required String body,
  }) {
    return PageViewModel(
      titleWidget: const SizedBox.shrink(),
      bodyWidget: const SizedBox.shrink(),
      image: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Imagem de Fundo Limpa
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
          ),

          // 2. Texto com Sombra Forte para Contraste
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 120),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28, // Aumentei um pouco para impacto
                      fontWeight: FontWeight
                          .w800, // Extra Bold para ajudar no contraste
                      color: Colors.white,
                      height: 1.1,
                      shadows: [
                        // Sombra 1: Contorno suave
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                        // Sombra 2: Difusão para legibilidade
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Fundo semitransparente opcional APENAS atrás do texto descritivo
                  // (Caso a sombra não seja suficiente para o texto fino)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                          alpha: 0.25), // Fundo suave apenas no texto pequeno
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        fullScreen: true,
        bodyFlex: 0,
        imageFlex: 1,
        pageColor: Colors.transparent,
        imagePadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        pages: [
          _buildPage(
            imagePath: 'assets/images/onboardingA.png',
            title: "Bem-vinde ao\nGuarda Corpo!",
            body: "Seu aplicativo para saúde\ne segurança no trabalho.",
          ),
          _buildPage(
            imagePath: 'assets/images/onboardingB.png',
            title: "Documentos\noffline",
            body:
                "Tudo na palma da sua mão sem preocupações com acesso à internet.",
          ),
          _buildPage(
            imagePath: 'assets/images/onboardingC.png',
            title: "Consultas\nexternas no app",
            body:
                "Consultas de CID, CA, CNPJ, CNAE.\nDe forma rápida e integrada.",
          ),
          _buildPage(
            imagePath: 'assets/images/onboardingD.png',
            title: "Módulos diversos\ne atualizados",
            body:
                "Treinamentos, Mapa de Risco,\nDiálogos Diários de Segurança.",
          ),
          _buildPage(
            imagePath: 'assets/images/onboardingE.png',
            title: "Vamos lá?",
            body: "Tudo pronto para começar sua jornada de segurança.",
          ),
        ],
        onDone: completeOnboarding,
        onSkip: completeOnboarding,
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        skip: Text(
          "Pular",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
          ),
        ),
        next: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(Icons.arrow_forward, color: primaryColor, size: 24),
        ),
        done: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Text(
            "Começar",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 16,
            ),
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: Colors.white.withValues(alpha: 0.4),
          activeColor: Colors.white,
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
