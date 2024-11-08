import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Aso extends StatelessWidget {
  const Aso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'ASO - Atestado de Saúde Ocupacional'.toUpperCase(),
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
            image: AssetImage('assets/images/aso.jpg'),
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
                                  'O ASO - Atestado de Saúde Ocupacional é um documento solicitado pela empresa onde o médico do trabalho atesta a condição de apto ou não apto ao colaborador para uma determinada função.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Apenas médico do trabalho assina este documento. O mesmo é implementado em todas as categorias de exames do trabalho (admissional, demissional, etc.) e dialoga com exames complementares como: sumário de urina, audiometria, eletrocardiograma entre outros a depender da função.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'É válido salientar que os exames complementares são definidos pelo SESMT e especificado no PCMSO. A NR8 especifica as informações que o ASO deve conter:\n\n',
                            ),
                            TextSpan(
                              text: 'a) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'nome completo do trabalhador, o número de registro de sua identidade e sua função;\n\n',
                            ),
                            TextSpan(
                              text: 'b) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'os riscos ocupacionais específicos existentes, ou a ausência deles, na atividade do empregado, conforme instruções técnicas expedidas pela Secretaria de Segurança e Saúde no Trabalho-SSST;\n\n',
                            ),
                            TextSpan(
                              text: 'c) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'indicação dos procedimentos médicos a que foi submetido o trabalhador, incluindo os exames complementares e a data em que foram realizados;\n\n',
                            ),
                            TextSpan(
                              text: 'd) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'o nome do médico coordenador, quando houver, com respectivo CRM;\n\n',
                            ),
                            TextSpan(
                              text: 'e) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'definição de apto ou inapto para a função específica que o trabalhador vai exercer, exerce ou exerceu;\n\n',
                            ),
                            TextSpan(
                              text: 'f) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'nome do médico encarregado do exame e endereço ou forma de contato;\n\n',
                            ),
                            TextSpan(
                              text: 'g) ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'data e assinatura do médico encarregado do exame e carimbo contendo seu número de inscrição no Conselho Regional de Medicina.',
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
