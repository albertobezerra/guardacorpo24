import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Epi extends StatelessWidget {
  const Epi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Tipos de E.P.I.'.toUpperCase(),
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
            image: AssetImage('assets/images/os.jpg'),
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
                                  'Os equipamentos de proteção individual são responsáveis por proteger os trabalhadores e garantir segurança contra riscos capazes de ameaçar sua saúde e integridade física. São especialmente utilizados em funções de risco, em linhas de produção onde os ruídos sejam altos ou em alturas elevadas, acima de 2,00m do nível inferior.\n\n',
                            ),
                            TextSpan(
                              text: 'Tipos de EPI:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Os tipos de equipamentos de proteção individual utilizados podem variar dependendo da atividade a ser realizada, dos riscos que ela possa trazer à segurança e à saúde do trabalhador e da parte do corpo que se pretende proteger.\n\n',
                            ),
                            TextSpan(
                              text: 'Definição de EPI:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'O equipamento de proteção individual, também conhecido como EPI, é todo dispositivo ou produto de uso individual destinado à proteção contra riscos capazes de ameaçar a segurança e a saúde do trabalhador.\n\n',
                            ),
                            TextSpan(
                              text: 'EPCs vs. EPIs:\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Os equipamentos de proteção coletiva (EPC) são dispositivos utilizados no ambiente de trabalho para proteger os trabalhadores dos riscos inerentes aos processos. Exemplos incluem enclausuramento acústico de fontes de ruído, ventilação dos locais de trabalho, proteção de partes móveis de máquinas e equipamentos, e sinalização de segurança. Em trabalhos em alturas elevadas, no entanto, os EPCs não são suficientes, sendo necessário o uso de EPIs.\n\n',
                            ),
                            TextSpan(
                              text: 'Divisão dos EPIs:\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '• Proteção da cabeça:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Capacete.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção auditiva:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Abafadores de ruído ou protetores auriculares e tampões.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção respiratória:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Máscaras e aparelhos filtrantes específicos para cada tipo de contaminante do ar, como gases e aerossóis.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção ocular e facial:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Óculos, viseiras e máscaras.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção de mãos e braços:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Luvas em diversos materiais e tamanhos, conforme os riscos: mecânicos, químicos, biológicos, térmicos ou elétricos.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção de pés e pernas:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Sapatos, coturnos, botas e tênis apropriados para riscos mecânicos, químicos, elétricos e de queda.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção contra quedas:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Cinto de segurança, sistema antiqueda, arnês, cinturão e mosquetão.\n\n',
                            ),
                            TextSpan(
                              text: '• Proteção de tronco:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: 'Avental.\n',
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
