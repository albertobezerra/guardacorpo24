import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz01topo.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz02_mbuscados.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz03_maissaude.dart';

class Raiz extends StatelessWidget {
  const Raiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => const Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Raiz01topo(),
                ),
                Flexible(
                  flex: 3,
                  child: Raiz02Mbuscados(),
                ),
                Flexible(
                  flex: 9,
                  child: Raiz03Maissaude(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
