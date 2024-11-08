import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Acidente extends StatelessWidget {
  const Acidente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Acidente de Trabalho'.toUpperCase(),
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
            image: AssetImage('assets/images/acidente.jpg'),
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
                                  'Conforme dispõe o art. 19 da Lei nº 8.213/91, "acidente de trabalho é o que ocorre pelo exercício do trabalho a serviço da empresa ou pelo exercício do trabalho dos segurados referidos no inciso VII do art. 11 desta lei, provocando lesão corporal ou perturbação funcional que cause a morte ou a perda ou redução, permanente ou temporária, da capacidade para o trabalho". \n\n',
                            ),
                            TextSpan(
                              text:
                                  'Ao lado da conceituação acima, de acidente de trabalho típico, por expressa determinação legal, as doenças profissionais e/ou ocupacionais equiparam-se a acidentes de trabalho.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '\n\nOs incisos do art. 20 da Lei nº 8.213/91 as conceitua:\n\n- doença profissional, assim entendida a produzida ou desencadeada pelo exercício do trabalho peculiar a determinada atividade e constante da respectiva relação elaborada pelo Ministério do Trabalho e da Previdência Social;\n\n- doença do trabalho, assim entendida a adquirida ou desencadeada em função de condições especiais em que o trabalho é realizado e com ele se relacione diretamente, constante da relação mencionada no inciso I.\n\nComo se revela inviável listar todas as hipóteses dessas doenças, o § 2º do mencionado artigo da Lei nº 8.213/91 estabelece que, "em caso excepcional, constatando-se que a doença não incluída na relação prevista nos incisos I e II deste artigo resultou das condições especiais em que o trabalho é executado e com ele se relaciona diretamente, a Previdência Social deve considerá-la acidente do trabalho".',
                            ),
                            TextSpan(
                              text:
                                  '\n\nO art. 21 da Lei nº 8.213/91 equipara ainda a acidente de trabalho:\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'I - o acidente ligado ao trabalho que, embora não tenha sido a causa única, haja contribuído diretamente para a morte do segurado, para redução ou perda da sua capacidade para o trabalho, ou produzido lesão que exija atenção médica para a sua recuperação;\n\n',
                            ),
                            TextSpan(
                              text:
                                  'II - o acidente sofrido pelo segurado no local e no horário do trabalho, em consequência de:\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    'a) ato de agressão, sabotagem ou terrorismo praticado por terceiro ou companheiro de trabalho;\n'),
                            TextSpan(
                                text:
                                    'b) ofensa física intencional, inclusive de terceiro, por motivo de disputa relacionada ao trabalho;\n'),
                            TextSpan(
                                text:
                                    'c) ato de imprudência, de negligência ou de imperícia de terceiro ou de companheiro de trabalho;\n'),
                            TextSpan(
                                text:
                                    'd) ato de pessoa privada do uso da razão;\n'),
                            TextSpan(
                                text:
                                    'e) desabamento, inundação, incêndio e outros casos fortuitos ou decorrentes de força maior;\n\n'),
                            TextSpan(
                              text:
                                  'III - a doença proveniente de contaminação acidental do empregado no exercício de sua atividade;\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'IV - o acidente sofrido pelo segurado ainda que fora do local e horário de trabalho:\n',
                            ),
                            TextSpan(
                              text:
                                  'a) na execução de ordem ou na realização de serviço sob a autoridade da empresa;\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'b) na prestação espontânea de qualquer serviço à empresa para lhe evitar prejuízo ou proporcionar proveito;\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  '§ 1º Nos períodos destinados a refeição ou descanso, ou por ocasião da satisfação de outras necessidades fisiológicas, no local do trabalho ou durante este, o empregado é considerado no exercício do trabalho.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Esses acidentes não causam repercussões apenas de ordem jurídica. Nos acidentes menos graves, em que o empregado tenha que se ausentar por período inferior a quinze dias, o empregador deixa de contar com a mão de obra temporariamente afastada em decorrência do acidente e tem que arcar com os custos econômicos da relação de empregado.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'O acidente repercutirá ao empregador também no cálculo do Fator Acidentário de Prevenção - FAP da empresa, nos termos do art. 10 da Lei nº 10.666/2003.\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Os acidentes de trabalho geram custos também para o Estado. Incumbe ao Instituto Nacional do Seguro Social – INSS administrar a prestação de benefícios, tais como auxílio-doença acidentário, auxílio-acidente, habilitação e reabilitação profissional e pessoal, aposentadoria por invalidez e pensão por morte.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Estima-se que a Previdência Social gastou, só em 2010, cerca de 17 bilhões de reais com esses benefícios.\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Condições e situações do ambiente\n\nOs atos e condições inseguras podem estar presentes em todos os locais, e não dizem respeito necessariamente ao ambiente de trabalho. Este tipo de situação pode ser imperceptível ou até mesmo estar inserido no cotidiano de forma que pareçam inofensivos e parte integrante do ambiente, embora ofereçam riscos ao bem-estar e à saúde.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Embora pareçam sinônimos, porém, atos inseguros e condições inseguras não significam a mesma coisa — por mais que até possam ser complementares. Para evitar que haja consequências graves às pessoas e ao local, é importante entender as diferenças entre esses termos e a melhor maneira de fazer uma prevenção adequada a eles.\n\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'O que são atos e condições inseguras?\n\nUm acidente não acontece por acaso, sendo causado por algum fator que não está correto — seja uma falha humana por parte do empregado, desrespeito às regras de segurança indicadas ou por uma condição insegura no ambiente.\n\nMesmo os acidentes mais simples e sem consequências graves devem ser vistos como oportunidades de prevenção.\n\n',
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
