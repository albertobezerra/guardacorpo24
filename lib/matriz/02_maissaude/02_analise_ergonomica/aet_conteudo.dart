import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class AetConteudo extends StatelessWidget {
  const AetConteudo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Sobre a Análise Ergonômica do Trabalho'.toUpperCase(),
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
            image: AssetImage('assets/images/cid.jpg'),
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
                                  'A ergonomia é a ciência que estuda a interação entre os trabalhadores e seus ambientes de trabalho, visando otimizar o bem-estar e o desempenho. A Análise Ergonômica do Trabalho (AET) é uma ferramenta essencial para identificar, avaliar e corrigir problemas ergonômicos, prevenindo lesões e promovendo a saúde no local de trabalho.\n\n',
                            ),
                            TextSpan(
                              text: 'Para que Serve a AET?\n\n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'A AET ajuda a:\n\n'
                                  '• Identificar Riscos Ergonômicos: Avaliar o ambiente de trabalho para detectar posturas inadequadas, movimentos repetitivos, e outros fatores que possam causar desconforto ou lesões.\n'
                                  '• Melhorar a Postura e a Conforto: Proporcionar recomendações práticas para ajustes no local de trabalho, como a altura da mesa, posição do monitor, e uso de cadeiras ergonômicas.\n'
                                  '• Aumentar a Produtividade: Um ambiente de trabalho ergonomicamente adequado reduz a fadiga e aumenta a eficiência dos trabalhadores.\n'
                                  '• Reduzir Absenteísmo: Prevenir problemas de saúde relacionados ao trabalho diminui o número de faltas e melhora a satisfação dos funcionários.\n'
                                  '• Cumprir Regulamentações: Aderir às normas e regulamentações de segurança e saúde no trabalho, evitando penalidades e promovendo um ambiente de trabalho seguro.\n\n',
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
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
