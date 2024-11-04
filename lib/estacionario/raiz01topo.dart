import 'package:flutter/material.dart';

class Raiz01topo extends StatelessWidget {
  const Raiz01topo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Defina os tamanhos dinamicamente com base na altura da tela
    double logoHeight = screenHeight < 1200 ? 60 : 80;
    double titleFontSize = screenHeight < 1200 ? 30 : 40;
    double subtitleFontSize = screenHeight < 1200 ? 14 : 16;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menu.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image(
              height: logoHeight,
              width: MediaQuery.of(context).size.width,
              image: const AssetImage('assets/images/logo.png'),
            ),
            Text(
              'Guarda Corpo',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Segoe Black',
                fontSize: titleFontSize,
              ),
            ),
            Text(
              'Um app sobre saúde e segurança do trabalho',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Segoe Light',
                fontWeight: FontWeight.bold, // Tornar o texto em negrito
                fontSize: subtitleFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
