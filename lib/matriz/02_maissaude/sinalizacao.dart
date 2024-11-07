import 'package:flutter/material.dart';

import '../../admob/banner_ad_widget.dart';

class Sinalizacao extends StatelessWidget {
  const Sinalizacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Sinalização de Segurança'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/treinamentos.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: const EdgeInsets.all(30),
                alignment: AlignmentDirectional.topStart,
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A sinalização de segurança é essencial para orientar e proteger os colaboradores no ambiente de trabalho. Abaixo estão as principais categorias de sinalização e suas especificações:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sinalização de Perigo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Esta categoria adverte sobre situações, objetos ou ações que possam causar dano ou lesão pessoal, além de afetar as instalações.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\nCaracterísticas dos sinais de perigo:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Forma triangular;\n'
                        '• Pictograma negro sobre fundo amarelo, com margem negra;\n'
                        '• A cor amarela deve cobrir pelo menos 50% da superfície da placa.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\nSinalização de Proibição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Os sinais desta categoria têm como objetivo impedir comportamentos que possam colocar em risco a segurança de indivíduos.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\nCaracterísticas dos sinais de proibição:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Forma redonda;\n'
                        '• Pictograma negro sobre fundo branco, com margem e faixa vermelhas;\n'
                        '• A faixa diagonal vermelha deve estar a 45º, descendo da esquerda para a direita sobre o pictograma.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sinalização de Salvamento ou Emergência',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Estes sinais indicam, em caso de perigo, as saídas de emergência, o caminho para o posto de socorro ou o local onde estão disponíveis dispositivos de salvamento.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\nCaracterísticas dos sinais de salvamento ou emergência:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Forma retangular ou quadrada;\n'
                        '• Pictograma branco sobre fundo verde;\n'
                        '• A cor verde deve cobrir pelo menos 50% da superfície da placa.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sinalização de Material de Combate a Incêndio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Os sinais desta categoria indicam a localização de equipamentos de combate a incêndio, para utilização em caso de emergência.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\nCaracterísticas dos sinais de combate a incêndio:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '• Forma retangular ou quadrada;\n'
                        '• Pictograma branco sobre fundo vermelho;\n'
                        '• A cor vermelha deve cobrir pelo menos 50% da superfície da placa.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
