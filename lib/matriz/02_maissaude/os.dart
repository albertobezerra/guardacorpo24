import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Os extends StatelessWidget {
  const Os({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Ordem de Serviço'.toUpperCase(),
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
            image: AssetImage('assets/images/menu.jpg'),
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
                                  'A Ordem de Serviço é um documento importante que, quando assinado pelo colaborador, confirma que ele tem ciência dos riscos associados à sua atividade, bem como das responsabilidades tanto do empregado quanto do empregador.\n\n',
                            ),
                            TextSpan(
                              text: 'Obrigações do Empregador\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'De acordo com a NR 1 (Norma Regulamentadora 1), no item 1.7, letra "B", é obrigação do empregador elaborar Ordens de Serviço para informar os colaboradores sobre os riscos presentes no ambiente de trabalho. Ao assinar esse documento, o funcionário reconhece que recebeu todas as informações sobre os possíveis riscos de sua função, bem como suas responsabilidades e as do empregador.\n\n',
                            ),
                            TextSpan(
                              text: 'Responsabilidades do Empregado\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'No item 1.8, letra "A", a NR 1 também estabelece que é dever do empregado cumprir as normas de Segurança do Trabalho, assim como as Ordens de Serviço emitidas pelo empregador. O descumprimento dessas normas pode sujeitar o colaborador a medidas disciplinares.\n\n',
                            ),
                            TextSpan(
                              text: 'Importância da Ordem de Serviço\n\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'A Ordem de Serviço é essencial para a proteção e conscientização dos trabalhadores em relação aos riscos do ambiente de trabalho. Além de proteger a integridade física dos colaboradores, ela estabelece um compromisso mútuo entre empregador e empregado para a segurança e saúde no ambiente laboral.\n\n',
                            ),
                            TextSpan(
                              text:
                                  'Com a assinatura da Ordem de Serviço, o colaborador declara estar ciente dos riscos e das medidas de segurança exigidas para o desempenho seguro de suas funções. Isso assegura que, em caso de acidentes, tanto empregador quanto empregado saibam exatamente suas responsabilidades, contribuindo para um ambiente de trabalho mais seguro e responsável.',
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
