import 'package:flutter/material.dart';

class Raiz01topo extends StatelessWidget {
  const Raiz01topo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Defina os tamanhos dinamicamente com base na altura da tela
    double logoHeight;
    double titleFontSize;
    double subtitleFontSize;
    FontWeight subtitleFontWeight;
    double alturaDoSizedBox;

    if (screenHeight < 800) {
      logoHeight = 50;
      titleFontSize = 26;
      subtitleFontSize = 12;
      subtitleFontWeight = FontWeight.bold;
      alturaDoSizedBox = 25;
    } else if (screenHeight < 1000) {
      logoHeight = 60;
      titleFontSize = 30;
      subtitleFontSize = 14;
      subtitleFontWeight = FontWeight.normal;
      alturaDoSizedBox = 50;
    } else {
      logoHeight = 80;
      titleFontSize = 40;
      subtitleFontSize = 16;
      subtitleFontWeight = FontWeight.normal;
      alturaDoSizedBox = 0;
    }

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
            SizedBox(height: alturaDoSizedBox),
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
                fontWeight: subtitleFontWeight,
                fontSize: subtitleFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
