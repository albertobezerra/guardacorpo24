import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/raizes/raiz01topo.dart';
import 'package:guarda_corpo_2024/matriz/raizes/raiz02_mbuscados.dart';
import 'package:guarda_corpo_2024/matriz/raizes/raiz03_maissaude.dart';
import 'package:guarda_corpo_2024/matriz/raizes/raiz04_emergencia.dart';

class Raiz extends StatelessWidget {
  const Raiz({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
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
            flex: 7,
            child: Raiz03Maissaude(),
          ),
          Flexible(
            flex: 2,
            child: Raiz04Emergencia(),
          ),
        ],
      ),
    );
  }
}
