import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Incendio extends StatelessWidget {
  const Incendio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Incêndio'.toUpperCase(),
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
            image: AssetImage('assets/images/incendio2.jpg'),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Um incêndio é uma ocorrência de fogo não controlado, que pode ser extremamente perigosa para os seres vivos e as estruturas. A exposição a um incêndio pode causar a morte, geralmente pela inalação dos gases, ou pelo desmaio causado por eles, ou ainda pelas queimaduras graves.\n\n',
                            ),
                            TextSpan(
                              text: 'Formas de Propagação do Fogo\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Os incêndios em edifícios podem começar através de falhas na instalação elétrica, na cozinha, com velas de cera, ou pontas de cigarro. O fogo pode propagar-se rapidamente para outras estruturas, especialmente se elas não estiverem de acordo com as normas de segurança; por isso, muitos municípios contam com os serviços do corpo de bombeiros para extinguir possíveis incêndios rapidamente.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Os incêndios se propagam de quatro formas:\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '• Por Irradiação, onde ocorre o transporte de energia de forma omnidirecional através do ar, suportada por infravermelhos e ondas eletromagnéticas;\n\n',
                            ),
                            TextSpan(
                              text:
                                  '• Por Convecção, onde a energia é transportada pela movimentação do ar aquecido pela combustão;\n\n',
                            ),
                            TextSpan(
                              text:
                                  '• Por Condução, onde a energia é transportada através de um corpo bom condutor de calor;\n\n',
                            ),
                            TextSpan(
                              text:
                                  '• Por Projeção de partículas inflamadas, que pode ocorrer na presença de explosões e fagulhas transportadas pelo vento.\n\n',
                            ),
                            TextSpan(
                              text: 'Incêndios Florestais\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Os incêndios florestais podem ser feitos de forma controlada ou acidental, mas ainda assim causam um impacto ecológico e econômico em grandes áreas.\n\n',
                            ),
                            TextSpan(
                              text: 'Métodos de Extinção\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '• Arrefecimento ou limitação do calor: A água é o meio mais utilizado para arrefecer o sistema. A temperatura do combustível deve ser inferior à temperatura de combustão ou queima.\n\n',
                            ),
                            TextSpan(
                              text:
                                  '• Abafamento ou asfixia: Este método consiste no isolamento do combustível do comburente ou na redução substancial desse no ambiente do sistema.\n\n',
                            ),
                            TextSpan(
                              text:
                                  '• Carência ou limitação do combustível: Separação do combustível da fonte de energia ou do ambiente do incêndio para evitar danos maiores.\n\n',
                            ),
                            TextSpan(
                              text: 'Classes de Incêndios\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Classe A\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Incêndios em materiais sólidos combustíveis, como papel, tecido, algodão, borracha e madeira. O extintor mais adequado é a água.\n\n',
                            ),
                            TextSpan(
                              text: 'Classe B\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Incêndios em líquidos inflamáveis, como óleo, gasolina, querosene, graxas e tintas. Os extintores adequados incluem pó químico seco, CO2 e espuma mecânica.\n\n',
                            ),
                            TextSpan(
                              text: 'Classe C\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Incêndios em equipamentos elétricos energizados, como máquinas elétricas e computadores. Extintores de pó químico seco e CO2 são recomendados.\n\n',
                            ),
                            TextSpan(
                              text: 'Classe D\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Incêndios causados por metais pirofóricos como potássio, magnésio e sódio. Devem ser combatidos com extintores especiais para metais.\n\n',
                            ),
                            TextSpan(
                              text: 'Classe K\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Incêndios em cozinhas comerciais e industriais, envolvendo produtos como óleo e gordura. Extintores de classe K são utilizados nesse caso.\n\n',
                            ),
                          ],
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
