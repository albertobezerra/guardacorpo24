import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';

class Historia extends StatelessWidget {
  const Historia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'História da Segurança do Trabalho'.toUpperCase(),
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
            image: AssetImage('assets/images/historia.jpg'),
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
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'A seguir, apresentaremos alguns fatos, adaptados da obra “Introdução à Higiene Ocupacional”, publicada no ano de 2004 pela FUNDACENTRO (Fundação Jorge Duprat Figueiredo de Segurança e Medicina do Trabalho), com a inclusão de alguns eventos, pelos elaboradores deste caderno, que fazem parte da história da segurança do trabalho:\n\n',
                            ),
                            TextSpan(
                              text:
                                  'a) Anos 400 (a.C.) a 50, aproximadamente:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Identificação de envenenamento por chumbo em mineiros e metalúrgicos, por Hipócrates, em seu clássico “Ares, Águas e Lugares”.\n'
                                  'Utilização de bexigas de animais como barreira para reter poeiras e fumos durante a respiração, por Plínio, o Velho, em seu tratado “De Historia Naturalis”.\n\n',
                            ),
                            TextSpan(
                              text: 'b) Anos de 1400 a 1500\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Em 1473, houve o reconhecimento do perigo de alguns vapores metálicos e a descrição de envenenamento ocupacional por mercúrio e chumbo, por Ellenborg, com sugestões de medidas preventivas.\n\n',
                            ),
                            TextSpan(
                              text: 'c) Anos de 1500 a 1800\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'No ano de 1556, Georgius Agricola elaborou a descrição do processo de mineração, fusão e refino de metais, mencionando doenças e acidentes acontecidos, sugestões para prevenção e a inclusão do uso de ventilação para essas atividades (primeiro livro a abordar a questão de segurança denominado “De Re Metallica”).\n\n'
                                  'Em 1567, Paracelso fez as primeiras descrições sobre doenças respiratórias relativas à atividade de mineração, com maior ênfase na contaminação por Mercúrio. Considerado o Pai da Toxicologia, Paracelso é autor da famosa frase “Todas as substâncias são venenos. É a dose que diferencia o veneno dos remédios”.\n\n'
                                  'O ano de 1700 foi marcado pela publicação da obra “De Morbis Artificium Diatriba”, conhecida também como “Doença dos Artífices”, por Bernardino Ramazzini, a qual apresenta um estudo bastante caracterizado sobre doenças relacionadas ao trabalho, em torno de 50 profissões da época, inclusive com indicação de precauções nas atividades. Esse é considerado o pai da Medicina Ocupacional, além de ter introduzido a expressão, nas entrevistas médicas (anamnese), “Qual é a sua ocupação?”.'
                                  '\n\nNa Inglaterra, no ano de 1775, Percival Lott promoveu a caracterização do câncer do escroto, doença diagnosticada entre os trabalhadores que tinham como tarefa limpar chaminés, cuja causa identificada foi a fuligem e a ausência de higiene. Esse evento resultou na criação do “Ato dos Limpadores de Chaminé de 1788”.\n\n',
                            ),
                            TextSpan(
                              text: 'd) Anos de 1800 a 1920\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Em 1802, foi criada a “Lei da Saúde e Moral dos Aprendizes”, na Inglaterra, onde foi estabelecido um limite de 12 horas para a jornada diária de trabalho, proibição do trabalho noturno e uso obrigatório de ventilação do ambiente.\n\n'
                                  'Em 1830, foi publicado na Inglaterra um livro sobre doenças ocupacionais por Charles Thackrah e Percival Lott (“Os efeitos das principais atividades, ofícios e profissões, do estado civil e hábitos de vida, na saúde e longevidade, com sugestões para a remoção de muitos dos agentes que produzem doenças e encurtam a duração da vida”). A obra contribuiu para o desenvolvimento da legislação ocupacional.\n\n'
                                  'Em 1833, também na Inglaterra, foi criada a “Lei das Fábricas” que fixava em 13 anos a idade mínima para o trabalho, proibia o trabalho noturno para menores de 18 anos e exigia exames médicos das crianças trabalhadoras.\n\n'
                                  'Em 1835, Benjamin Cready publicou o livro “On the Influence of Trades, Professions, and Occupations in the United States in Production of Disease” (Influência dos Negócios, Profissões e Ocupações na Produção de Doença nos Estados Unidos).\n\n'
                                  'Em 1851, William Farr relatou a mortalidade excessiva entre os fabricantes de vasos; impacto das doenças respiratórias e dos óbitos em trabalhadores da mineração na Inglaterra.\n\n'
                                  'Em 1864, a “Lei das Fábricas” (1833) foi ampliada, exigindo processos de ventilação para reduzir danos à saúde.'
                                  '\nEm 1869, na Alemanha e em 1877, na Suíça, foram instituídas leis que responsabilizavam os empregadores por lesões ocupacionais.\n\n'
                                  'Em 1907, Frederick Winslow Taylor publica a obra “Princípios de Administração Científica”, nos Estados Unidos. Nesse trabalho, Taylor apresentou técnicas, ou mecanismos, como o estudo de tempos e movimentos, a padronização de instrumentos e ferramentas, a padronização de movimentos, conveniência de áreas de planejamento, uso de cartões de instrução, sistema de pagamento de acordo com o desempenho e cálculo de custos.\n\n'
                                  'Em 1910, nos Estados Unidos, Henry Ford utilizou os “Princípios de Produção em Massa” em linhas de montagem, diminuindo assim o tempo de duração dos processos, a quantidade de matéria-prima estocada e o aumento da capacidade de produção, através de capacitação dos trabalhadores. No ano de 1898, juntamente com investidores, fundou a Detroit Automobile Company, que foi fechada mais tarde. Em 1903, Henry Ford fundou a Ford Motor Company. Ainda no mesmo ano, houve o reconhecimento das neuroses das telefonistas como doenças profissionais.\n\n'
                                  'Em 1910, Oswaldo Cruz, “o pai das campanhas”, na construção da estrada de ferro Madeira-Mamoré, realizou estudos e trabalhos sobre as doenças infecciosas relacionadas ao trabalho, como a malária e o amarelão, que tornavam os trabalhadores incapazes e matavam milhares deles.\n\n'
                                  'Em 1911, ocorreu a primeira conferência de doenças industriais nos Estados Unidos.\n\n'
                                  'Assim como se promove a organização do National Safety Council, os primeiros grupos (agências) de higienistas são estabelecidos nos estados de Ohio e Nova York.\n\n'
                                  'Em 1912, durante o 4º Congresso Operário Brasileiro, constituiu-se a Confederação Brasileira do Trabalho (CBT), a qual teve como finalidade promover um programa de reivindicações operárias, tais como: jornada de trabalho de oito horas, semana de seis dias, construção de casas para operários, indenização para acidentes de trabalho, limitação da jornada de trabalho para mulheres e crianças (menores de quatorze anos), contratos coletivos (na época, individuais), obrigatoriedade de pagamento de seguro para os casos de doenças e velhice, estabelecimento de um salário mínimo, reforma de tributos públicos e exigência de instrução primária.'
                                  '\n\nEntre os anos de 1914 e 1919, após o término da Primeira Guerra Mundial, foi criada, pela Conferência de Paz, a Organização Internacional do Trabalho (OIT), convertida na Parte XIII do “Tratado de Versalhes”.\n\n'
                                  'Em 1914, nos Estados Unidos, o serviço de saúde pública (USPHS) organiza a divisão de higiene industrial.\n\n'
                                  'Em 1918, o presidente do Brasil Wenceslau Braz Gomes cria, através do Decreto nº 3.550, o Departamento Nacional do Trabalho, com o intuito de regulamentar a organização do trabalho.\n\n'
                                  'Em 1919, com o Decreto Legislativo nº 3.724, foi instituída a reparação em caso de doença contraída pelo exercício do trabalho. O Decreto é conhecido como a primeira lei sobre acidentes de trabalho.\n\n'
                                  'Em 1920, com a reforma “Carlos Chagas”, a higiene do trabalho incorpora-se ao âmbito da saúde pública através do Departamento Nacional de Saúde Pública (DNSP), órgão vinculado ao Ministério da Justiça e Negócios Interiores.\n\n',
                            ),
                            TextSpan(
                              text: 'e) Anos de 1921 a 1950\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Em 1922, a Universidade de Harvard cria o curso de graduação em Higiene Industrial.\n\n'
                                  'Em 1923, o presidente do Brasil Arthur Bernardes cria o Conselho Nacional do Trabalho, pelo Decreto n° 16.027.\n\n'
                                  'Em 1923, cria-se a Inspetoria de Higiene Industrial e Profissional junto ao Departamento Nacional de Saúde, no Ministério da Justiça e Negócios Interiores.\n\n'
                                  'Em 1925, Dra. Alice Hamilton, médica americana, publicou “Venenos Industriais nos Estados Unidos” e, em 1934, “Toxicologia Industrial”.\n\n'
                                  'No ano de 1930, o Ministério do Trabalho, Indústria e Comércio é criado via Decreto n° 19.433, assinado pelo presidente Getúlio Vargas. O Ministério assumia as questões de saúde ocupacional e era coordenado pelo Ministro Lindolfo Leopoldo Boeckel Collor, empossado na ocasião.\n\n'
                                  'Em 1934, com o Decreto Legislativo nº 24.637, é criada a Inspetoria de Higiene e Segurança do Trabalho, ampliando-se assim o conceito de doença profissional. Tal decreto é considerado a segunda lei de acidentes do trabalho.\n\n'
                                  'Em 1938, a Inspetoria de Higiene e Segurança do Trabalho (Decreto nº 24.637) se transforma em Serviço de Higiene do Trabalho, passando, em 1942, a denominar-se Divisão de Higiene e Segurança do Trabalho.\n\n'
                                  'Em 1938, nos Estados Unidos, foi fundada a ACGIH, na época chamada de National Conference Governmental Industrial Hygienists.\n\n'
                                  'Em 1939, também nos EUA, é fundada a AIHA (American Industrial Hygiene Association).'
                                  'A ASA (American Standard Association, atualmente ANSI) e a ACGIH publicam a primeira lista de “Concentrações Máximas Permissíveis” (MAC’s) para substâncias químicas presentes nas indústrias.\n\n'
                                  'Entre os anos de 1939 e 1945, durante a Segunda Guerra Mundial, foram desenvolvidos programas de higiene para manter a capacidade produtiva da indústria, até então com atenção voltada somente para a indústria bélica e operada por mulheres.\n\n'
                                  'Em 1943, a ACGIH publicou os “Primeiros Limites Máximos Permissíveis”, que em 1948 passaram a ser chamados de “Limites de Tolerância TLV®” (Threshold Limit Value).\n\n'
                                  'Em 1943, no Brasil, com o Decreto-lei nº 5.452, de 1º de maio, entra em vigor a “Consolidação das Leis do Trabalho” (CLT), com capítulo referente à Higiene e Segurança do Trabalho.\n\n'
                                  'Em 1944, é incluída a CIPA (Comissão Interna de Prevenção de Acidentes) na Legislação Brasileira pelo Decreto nº 7036/44, conhecido como “Lei de Acidentes de Trabalho de 1944”.\n\n'
                                  'Em 1947, é fundada a International Organization for Standardization (ISO), em português, Organização Internacional de Normatização.\n\n'
                                  'Em 1948, é criada a Organização Mundial da Saúde (OMS) com políticas voltadas também à saúde dos trabalhadores.\n\n'
                                  'Em 1949, é criada a Ergonomic Research Society.\n\n',
                            ),
                            TextSpan(
                              text: 'f) Anos de 1950 a 2000\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  'Em 1953, a Portaria nº 155 regulamenta as ações da CIPA.\n\n'
                                  'Em 1953, é publicada a Recomendação nº 97 da OIT sobre “Proteção da Saúde dos Trabalhadores”.'
                                  'Em 1956, o governo brasileiro aprova por Decreto Legislativo a Convenção nº 81 – Fiscalização do Trabalho, da OIT.\n\n'
                                  'Le Guillant publica a obra “A Neurose das Telefonistas – Síndrome Geral de Fadiga Nervosa” em 1956.\n\n'
                                  'Em 1957, em conferência da OIT, foram estabelecidos os objetivos e o âmbito de atuação da saúde ocupacional.\n\n'
                                  'Em 1959, na Conferência Internacional do Trabalho, é aprovada a Recomendação nº 112 que trata dos Serviços de Medicina do Trabalho.\n\n'
                                  'Em 1960, o Sistema Toyota de Produção (produção enxuta), conhecido como Toyotismo, é consolidado como filosofia de produção. Caracterizado por funcionar de maneira oposta ao Fordismo, tinha como princípios o mínimo de estoque e a produção do bem realizada de acordo com a demanda no tempo. A flexibilização deste modelo ficou conhecida como Just in Time.\n\n'
                                  'Em 1966, através da Lei nº 5.161, é criada no Brasil a Fundação Centro Nacional de Segurança, Higiene e Medicina do Trabalho (FUNDACENTRO), com o objetivo de realizar estudos, análises e pesquisas relativas à higiene e à medicina ocupacional. Atualmente, é denominada de Fundação Jorge Duprat Figueiredo, de Segurança e Medicina do Trabalho (alterado no ano de 1978).\n\n'
                                  'Nos Estados Unidos, em 1970, é criada a OSHA (Occupational Safety and Health Administration) como agência integrante do Departamento do Trabalho, e o NIOSH (National Institute for Occupational Safety and Health), como parte do Departamento de Saúde e Serviços Públicos. Coube à OSHA a responsabilidade do estabelecimento de padrões e ao NIOSH, realizar o desenvolvimento de pesquisas e fornecer recomendações de padrões à OSHA.\n\n'
                                  'No mesmo ano, a OSHA estabeleceu os primeiros padrões conhecidos como PEL (Permissible Exposure Limit) e o Brasil foi considerado o país onde ocorria o maior número de acidentes de trabalho no mundo.\n\n'
                                  'Em 1977, no Brasil, a Lei nº 6.514 altera o Capítulo V da CLT (Consolidação das Leis do Trabalho), agora relativo à segurança e medicina do trabalho.\n\n'
                                  'No ano de 1978, no Brasil, através da Portaria nº 3.214 de 08/06/1978, foram aprovadas as Normas Regulamentadoras (NR) do Capítulo V, Título II, da Consolidação das Leis do Trabalho, relativas à segurança e medicina do trabalho. Nesse mesmo ano, foram aprovadas outras 28 NR, as quais sofreram várias alterações ao longo dos anos.'
                                  '\n\nEm 1987, a Norma de Certificação ISO 9000 é publicada pela International Organization for Standardization, com a finalidade de estabelecer uma estrutura-modelo de gestão de qualidade baseado em normas técnicas, para empresas e organizações empresariais.\n\n'
                                  'Em 1988, é promulgada a Constituição Federal do Brasil e são criadas as Normas Regulamentadoras Rurais (NRR).\n\n'
                                  'Em 1988, a OIT publica a Convenção nº 167 – Segurança e Saúde na Construção. Essa convenção é aplicada a qualquer atividade econômica relacionada à construção, como: edificações, obras públicas, trabalhos em montagem, desmontagem e, até mesmo, operação e transporte nas obras.\n\n'
                                  'No Brasil, em 1989, o Decreto Legislativo nº 51 aprova a Convenção nº 162 – Asbesto, aplicada a todas as atividades econômicas onde ocorra a exposição dos trabalhadores ao asbesto.\n\n'
                                  'Em 1995, a OIT publica a Convenção nº 176 – Segurança e Saúde na Mineração, aplicada às minas, incluindo os locais onde estão presentes as atividades de exploração e extração de minerais. Assim também, o Brasil, através do Decreto nº 67, aprova a Convenção nº 170 – Segurança na Utilização de Produtos Químicos, da OIT publicada em 1990, com campo de aplicação a todas as indústrias, cujas atividades econômicas baseiam-se na utilização de produtos químicos.\n\n'
                                  'Em 1996, a Norma de Certificação ISO 14000 é publicada pela International Organization for Standardization, cujo objetivo é estabelecer um conjunto de diretrizes, dividida em comitês e subcomitês de criação, para sistemas de gestão ambiental direcionada a empresas e organizações.\n\n'
                                  'Nesse mesmo ano, a British Standards, órgão britânico de elaboração de normas técnicas, publica a BS 8800 – Occupational Health and Safety Management Systems, norma que apresenta requisitos para implantação de um sistema de gestão de segurança e saúde no trabalho para empresas e organizações.\n\n'
                                  'Em 1997, na Portaria SSST nº 53, foi publicada a NR 29 que trata da Segurança e Saúde no Trabalho Portuário (alterada em 1998, 2002 e 2006).'
                                  '\nEm 1999, o Governo brasileiro aprova por Decreto Legislativo a Convenção nº 182 – Piores Formas de Trabalho Infantil e a Ação Imediata para a sua Eliminação, da OIT.\n\n',
                            ),
                            TextSpan(
                              text: 'g) De 2019 até hoje\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    'Em 2019, o governo brasileiro, sob a administração do presidente Jair Bolsonaro, implementou a Medida Provisória nº 870, que extinguiu o Ministério do Trabalho, transferindo suas atribuições para o Ministério da Economia. Essa medida gerou debates sobre o impacto na fiscalização e proteção dos trabalhadores.'
                                    '\n\n2020: A pandemia de COVID-19 trouxe um foco renovado na saúde e segurança no trabalho. A Organização Internacional do Trabalho (OIT) emitiu diretrizes específicas para proteger trabalhadores durante a pandemia, incluindo o distanciamento social, o uso de equipamentos de proteção individual (EPIs) e a implementação de protocolos de higiene rigorosos.'
                                    '\n\n2021: Em resposta à pandemia, diversas empresas adotaram o teletrabalho como uma medida de proteção à saúde dos trabalhadores. A legislação trabalhista em vários países, incluindo o Brasil, passou a considerar novas regulamentações para o trabalho remoto, visando garantir a segurança e o bem-estar dos trabalhadores nesse novo formato.'
                                    '\n\n2022: A OIT continuou a promover a implementação de normas internacionais de segurança no trabalho, como a Convenção nº 155, que trata da segurança e saúde dos trabalhadores e do ambiente de trabalho. A implementação dessas normas visa reduzir acidentes de trabalho e melhorar as condições laborais globalmente.'
                                    '\n\n2023: A crescente digitalização e automação no ambiente de trabalho levaram à introdução de novas tecnologias de segurança, como sensores inteligentes e sistemas de monitoramento em tempo real, que ajudam a prevenir acidentes e garantir a segurança dos trabalhadores.'
                                    '\n\n2024: A segurança no trabalho continua a evoluir com o avanço da tecnologia. A utilização de big data e análise preditiva permite identificar riscos antes que eles ocorram, melhorando ainda mais a prevenção de acidentes. Além disso, a formação contínua e a conscientização dos trabalhadores sobre práticas seguras permanecem fundamentais para a redução de acidentes e doenças ocupacionais.'),
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
