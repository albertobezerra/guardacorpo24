import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart'; // Importação da tela de autenticação

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

Future<void> saveSharedPreferences({
  required bool isLoggedIn,
  required bool isPremium,
  required String planType,
  required bool hasShownSplash,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
  await prefs.setBool('isPremium', isPremium);
  await prefs.setString('planType', planType);
  await prefs.setBool('hasShownSplash', hasShownSplash);
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  Future<void> _startSplashScreenTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    // Define que o splash já foi mostrado
    await saveSharedPreferences(
      isLoggedIn: false, // O usuário ainda pode não estar logado
      isPremium: false,
      planType: '',
      hasShownSplash: true,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
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
