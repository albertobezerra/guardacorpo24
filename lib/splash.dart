import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double textoPrincipalResponsivo;
    FontWeight fonteNegrito;
    EdgeInsets paddingBotaoComecar;

    if (screenHeight < 800) {
      textoPrincipalResponsivo = 20;
      fonteNegrito = FontWeight.normal;
      paddingBotaoComecar = EdgeInsets.zero;
    } else if (screenHeight < 1000) {
      textoPrincipalResponsivo = 30;
      fonteNegrito = FontWeight.bold;
      paddingBotaoComecar = const EdgeInsets.all(10);
    } else {
      textoPrincipalResponsivo = 37;
      fonteNegrito = FontWeight.normal;
      paddingBotaoComecar = const EdgeInsets.all(20);
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/index.jpg'),
          fit: BoxFit.cover,
        )),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
            Colors.black.withValues(alpha: .9),
            Colors.black.withValues(alpha: .8),
            Colors.black.withValues(alpha: .2),
          ])),
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
                        fontFamily: 'Segoe Black'),
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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            const AuthPage(), // Direcione para AuthPage
                      ));
                    },
                    child: Padding(
                      padding: paddingBotaoComecar,
                      child: Text(
                        "Começar".toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF0C5422),
                          fontFamily: 'Segoe Black',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
