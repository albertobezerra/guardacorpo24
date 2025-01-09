import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart'; // Importação da tela de autenticação

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  Future<void> _startSplashScreenTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    await _setSplashShown();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  Future<void> _setSplashShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownSplash', true);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double textoPrincipalResponsivo;
    FontWeight fonteNegrito;

    if (screenHeight < 800) {
      textoPrincipalResponsivo = 20;
      fonteNegrito = FontWeight.normal;
    } else if (screenHeight < 1000) {
      textoPrincipalResponsivo = 30;
      fonteNegrito = FontWeight.bold;
    } else {
      textoPrincipalResponsivo = 37;
      fonteNegrito = FontWeight.normal;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/index.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: .9),
                Colors.black.withValues(alpha: .8),
                Colors.black.withValues(alpha: .2),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    'Saúde e Segurança\ndo Trabalho na\npalma da mão.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textoPrincipalResponsivo,
                      fontFamily: 'Segoe Black',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Tudo a um clique de distância!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 13,
                      fontWeight: fonteNegrito,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
