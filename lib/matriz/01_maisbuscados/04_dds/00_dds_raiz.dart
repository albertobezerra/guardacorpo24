import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/components/customizacao/modern_list_tile.dart';
import 'package:guarda_corpo_2024/components/reward_cta_widget.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import '../../../services/admob/conf/interstitial_ad_manager.dart';
import '01_dds_base.dart';

class DdsRaiz extends StatefulWidget {
  const DdsRaiz({super.key});

  @override
  State<DdsRaiz> createState() => _DdsRaizState();
}

class _DdsRaizState extends State<DdsRaiz> {
  final Color primaryColor = const Color(0xFF006837);

  final List<Map<String, String>> dds = [
    {
      "title": "Trabalho em Andaimes",
      "content":
          "Os andaimes são muito utilizados pela construção civil. Eles servem para o uso de trabalho em altura como exemplo: construção, demolição, reforma, pintura, limpeza e manutenção.\n\nFale sobre a importação da fixação correta do mesmo para poder ser utilizado de forma correta. Se a empresa já possuir algum histórico de acidente com andaime o use como exemplo.\n\nFale também sobre a importância do uso dos equipamentos para trabalho em altura e da necessidade da atenção redobrada que deve ter com trabalho em altura.\n\nPor fim reforce a paralisação das atividades em altura em caso de presença de chuva ou situações da natureza que traga risco ao colaborador."
    },
    {
      "title": "A importância do capacete de segurança",
      "content":
          "O capacete de segurança salva muitas vidas. Usado bastante pela construção, todavia não é de uso exclusivo da construção civil.\n\nO capacete de segurança é útil para toda e qualquer atividade em que os colaboradores estejam expostos à projeção de material que venham de cima para baixo.\n\nOs capacetes de segurança são projetados para suportar grandes cargas.\n\nAssim como os demais EPI’s, o capacete de segurança sempre deve ser usado pelo colaborador, assim como é pessoal e intransferível, o mesmo deve ser substituído sempre que mostra-se fora dos padrões de fabrica.\n\nÉ bom ressaltar que sabe-se que o capacete assim como outros epi’s incomodam, mas, tem que ser usado para preservar a saúde do colaborador."
    },
    {
      "title": "Choque Elétrico",
      "content":
          "Choque elétrico que todos os colaboradores independente do tipo de local de trabalho sempre está exposto.\n\nPraticamente em todos os setores de uma empresa/estabelecimento usa energia elétrica.\n\nDeve ser levado em consideração todo aterramento correto da parte elétrica, assim como também deve ser ressaltado a importância da atenção dos colaboradores quando foram trabalhar com equipamentos energizados, ambientes com presença de água.\n\nEm caso de qualquer choque elétrico deve ser tomada providências de forma imediata, por conta que na maioria das vezes os acidentes com choque elétrico são fatais."
    },
    {
      "title": "Atestado de Saúde Ocupacional",
      "content":
          "O ASO é o atestado de saúde ocupacional, onde o médico do trabalho atesta se o colaborador está apto ou não para ser admito, demito ou mudar de função.\n\nO ASO é um atestado que depende de exames complementares. Exames complementares são exames de sangue, urina, audiometria, espirometria, entre outros.\n\nEsses exames são estabelecidos no PCMSO a depender das atividades que os colabores iram desenvolver na empresa.\n\nDeve ser levado em consideração, o quão importantes são os exames complementares assim como o ASO, pois eles que determinaram o rumo que o colaborador vai tomar dentro da empresa."
    },
    {
      "title": "Comissão Interna de Prevenção de Acidentes",
      "content":
          "A CIPA é uma comissão de grande importância e poder dentro de uma empresa. A mesma tem poder e voz, podendo atuar como um representante dos colaboradores.\n\nA CIPA visa o bem estar e prevenção de riscos para com a saúde do colaborador. Deve ser considerado a importância, poder e benefícios da mesma dentro da empresa.\n\nLembrar que o propósito dos participantes da CIPA dever ser a prevenção de riscos e acidentes de trabalho. A CIPA dá estabilidade de dois anos, mas o foco não deve ser esse.\n\nOs membros da CIPA dever ser pessoas atuantes dentro da empresa. Por ter colaborados que estão todos os dias em diversas partes da empresa, os riscos são detectados de forma mais rápida."
    },
    {
      "title": "Ordem de Serviço - O.S",
      "content":
          "A ordem de serviço é um documento exigido pela NR 1. Na ordem de serviço deve ser identificado o colaborador, o local de trabalho do mesmo e sua funcão.\n\nA partir de sua função que é determinado os riscos. Na ordem de serviço deve está de forma explicita os riscos da função do colaborador e o colaborador deve ter ciência desses riscos.\n\nA ordem de serviço deve ser elaborada para todos os colaborados, lembrando que os riscos são diferenciados a depender da função, exposição e grau de intensidade.\n\nA ordem de serviço dever alocada junto a ficha de cada colaborador da empresa."
    },
    {
      "title": "Embargo e Interdição",
      "content":
          "O embargo e interdição são tema de NRs. Essa NR vem para definir limites de segurança para a existência de uma obra ou uso de um equipamento.\n\nO que é embargado? Obras! O que é interditado? Máquinas e equipamentos.\n\nDeve ser evidenciado que qualquer alteração em máquinas, equipamentos ou edificação dever sinalizado de forma imediata para a segurança de todos."
    },
    {
      "title": "Vapores e Gases",
      "content":
          "Vapor é a fase gasosa de uma substância, que em condições normais de temperatura e pressão é sólida ou líquida.\n\nExemplos : Vapores de água, vapores de gasolina, vapores de naftalina, etc.\n\nA principal diferença entre gases e vapores está na concentração de vapores chamados de saturação, a partir do qual, qualquer aumento na concentração transformará o vapor em líquido ou sólido.\n\nNo ser humano sua atuação sobre o organismo pode ser dividida em irritantes anestésicos e asfixiantes.\n\nAs boas condições de ordem, limpeza e asseio geral, ocupam uma posição chave num sistema de proteção ocupacional. Os “vapores” se comportam de maneira diferente, tanto no que diz respeito do período de permanência no ar, quanto às possibilidades de ingresso no organismo em relação aos “gases”.\n\nA via preferencial de contaminação por gases é a via respiratória e por isto sua ação no organismo é muito rápida.\n\nDesta maneira, os vapores como os gases podem ser classificados ou divididos em irritantes, anestésicos e aspirantes.\n\nEsta classificação baseia-se no efeito mais importante, mais significativo sobre o organismo. Assim sendo as recomendações para o uso de EPI’s para gases vale para vapores.\n\nOs resíduos gasosos deverão ser eliminados dos locais de trabalho através de métodos, equipamentos ou medidas adequadas, sendo proibido o lançamento ou a liberação de quaisquer contaminantes gasosos se ultrapassarem os limites de tolerância estabelecidos pela Norma Regulamentadora."
    },
    {
      "title": "Resíduo Industrial",
      "content":
          "Conforme as normas estabelecidas pela Associação Brasileira de Normas Técnicas (ABNT), resíduos sólidos são materiais em estado sólido ou semissólido, que resultam de atividade industrial, doméstica, hospitalar, comercial, agrícola, de serviços e de varrição.\n\nResíduos perigosos são lodos provenientes de sistemas de tratamento de água, bem como determinados líquidos cujas características tornem inviável seu lançamento na rede pública de esgotos, rios e lagos ou exijam tratamento através de soluções técnicas inviáveis e/ou de custo muito elevado.\n\nOs resíduos são classificados conforme sua periculosidade, que, em função de suas propriedades físicas, químicas ou infectocontagiosas, podem apresentar riscos à saúde pública ou ao meio ambiente.\n\nAs classes de Resíduos são:\n\nPerigosos, Não-Inertes e Inertes\n\nOs resíduos perigosos são aqueles com características de inflamabilidade, Corrosividade, reatividade, toxidade ou patogenicidade.\n\nOs resíduos Não-Inertes são aqueles com características de combustão, biodegradabilidade ou solubilidade em água.\n\nOs resíduos Inertes são aqueles que não são decompostos prontamente, rochas, tijolos, vidros, certos plásticos e borrachas."
    },
    {
      "title": "Você sabe lavar as suas mãos?",
      "content":
          "Água e sabão ou álcool?\n\nA higienização das mãos é geralmente realizada pela lavação com água e sabão ou pela fricção com álcool a 70%. Ambos são excelentes, atendendo perfeitamente o objetivo de eliminar os agentes patogênicos.\n\nA lavação com água e sabão é o processo que tem por finalidade primordial remover sujeira e a flora transitória (aquela adquirida no contato com pessoas, objetos e superfícies), sendo preferida caso as mãos estejam com sujeira visível (poeira, talco, terra, etc).\n\nNo caso da eliminação exclusiva de bactérias, as soluções alcoólicas são mais potentes, mas só podem ser utilizadas caso as mãos estejam limpas, sem qualquer sujidade visível.\n\nDada à importância da higienização das mãos, é indispensável orientar desde a infância sobre os benefícios desse processo. Devemos encorajar as crianças a higienizar as mãos de forma correta, assegurando que essa prática torne-se hábito ao longo da vida.\n\n\n\nQuando devo higienizar as mãos?\n\nLavar as mãos deve fazer parte da rotina de todos nós, especialmente:\n\nAntes de comer ou manusear alimentos.\n\nApós ter utilizado as instalações sanitárias.\n\nApós assoar o nariz, tossir ou espirrar.\n\nAntes de efetuar qualquer ação que inclua o contato com mucosas corporais (por exemplo, colocar ou retirar lentes de contato).\n\nApós tocar animais ou seus dejetos.\n\nApós manusear resíduos (por exemplo, lixo doméstico).\n\nApós usar transportes públicos.\n\nAntes e após tocar doentes ou feridas (cortes, arranhões, queimaduras etc).\n\nAntes e após uma visita a um doente internado (hospital ou outra instituição).\n\nLembre-se: lavar as mãos é um detalhe que faz toda a diferença, não apenas na sua saúde, mas também na saúde de seus entes queridos e de toda a comunidade."
    },
    {
      "title": "Riscos com Baterias",
      "content":
          "As baterias comuns de automóveis parecem inofensivas. Isso pode apresentar o maior perigo, porque muitas pessoas que trabalham com elas ou próxima delas parecem desatentas em relação a seus riscos em potencial.O resultado é o crescente número de acidentes no trabalho relacionados com o mau uso ou abuso das baterias.\n\nMuitos dos acidentes podem ser evitados se respeitarmos os principais riscos das baterias:\n\nO elemento eletrolítico nas células das baterias é o ácido diluído, que pode queimar a pele e os olhos. Mesmo a borra que se forma devido o derrame de ácido é prejudicial à pele e os olhos.\n\nQuando uma bateria está carregada, o hidrogênio pode se acumular no espaço vazio próximo da tampa de cada célula e, a menos que o gás possa escapar, uma centelha pode inflamar o gás aprisionado e explodir.\n\nO controle desses riscos é bastante simples. Quando você estiver trabalhando próximo a baterias, use as ferramentas metálicas com muito cuidado. Uma centelha provocada pelo aterramento acidental da ferramenta, pode inflamar o hidrogênio da bateria.\n\nPor este mesmo motivo nunca fume ou acenda fósforos próximos às baterias. Ao abastecer a bateria com ácido, não encha com excesso ou derrame.\n\nSe houver o derrame, limpe-o imediatamente, tomando cuidado para proteger os olhos e a pele.\n\nO pó formado pelo acúmulo de massa seca, pode facilmente penetrar nos seus olhos. Portanto proteja-os com óculos de segurança.\n\nO abuso da bateria pode eventualmente causar vazamentos de ácidos e vazamentos de hidrogênio que encurtam sua vida e que possam ser perigosos para qualquer um que esteja trabalhando próximo.\n\nO recarregamento da bateria provoca o acúmulo de hidrogênio, que é altamente inflamável. Assim faça o recarregamento ao ar livre ou num lugar bem ventilado, com as tampas removidas.\n\nPrimeiro ligue os conectores tipo jacaré do carregador nos pólos e posteriormente ligue o carregador na tomada de alimentação. Qualquer fonte de centelhas durante a recarga pode causar uma explosão.\n\nFique atento especialmente em relação ao centelhamento quando se tentar jumpear uma bateria descarregada. Estas pontes (jumpers) podem provocar um arco voltaico e centelhas que podem inflamar o hidrogênio."
    },
    {
      "title": "PFF1, PFF2 ou PFF3?",
      "content":
          "O material geralmente utilizado para a confecção de uma máscara descartável é uma combinação de duas ou mais camadas de manta de polipropileno.\n\nA camada filtrante pode ser feita de manta de fibra de polipropileno à qual, posteriormente, deu-se uma carga eletrostática para melhorar a eficiência da filtragem.\n\nApós cortarem-se as peças faciais, estas recebem uma solda por ultra-som para dar-lhes forma. Em seguida, recebem uma costura ou fixação dos tirantes para então serem finalizadas e embaladas.\n\nAs máscaras descartáveis podem ou não conter válvula de exalação.\n\nA penetração máxima através do filtro da máscara descartável deve atender aos requisitos da tabela abaixo. No teste, o spray de uma solução aquosa de cloreto de sódio a 1% passa pelo objeto de teste, após o qual mede-se a penetração.\n\nA partícula oleosa tem seu teste feito com óleo de parafina:\n\nPFF1 – Geralmente indicada para proteção contra partículas não tóxicas tais como as minerais, pó de madeira, etc.\n\nPFF2 – Geralmente indicada para proteção contra partículas tóxicas químicas finas.\n\nPFF3 – Geralmente indicada para proteção contra partículas tóxicas químicas finíssimas."
    },
    {
      "title": "Protetor Auricular",
      "content":
          "A rotina de ouvir os sons do ambiente, como o barulho do tráfego no deslocamento diário para o trabalho, possivelmente passa despercebida por você e tantos outros, mas pode fazer falta para muitos.A perda auditiva é realidade para uma parcela de brasileiros. Boa parte dos acometidos por algum grau de deficiência auditiva desenvolveu o problema devido à exposição ocupacional ao ruído.\n\nO único meio de evitar danos ao ouvido do trabalhador, em atividades nas quais a eliminação total do ruído não é viável, é o controle do agente na fonte.\n\nQuando não for possível prover EPCs, a saída é buscar alternativas capazes de minimizar os efeitos das emissões até o limite permitido.\n\nO uso de protetor auditivo se apresenta como um dos métodos mais comuns e práticos para reduzir o nível de exposição ao ruído de origem ocupacional, orienta Samir Gerges, doutor em Ruído e Vibrações, professor aposentado e ex-coordenador do Laboratório de Vibroacústica Industrial, Veicular e Aeronáutica da Universidade Federal de Santa Catarina. O protetor auditivo deve ser fornecido pela empresa ao trabalhador sempre que ele desempenhar atividades em local cujo ruído extrapole 85 dB(A) ou 87 dB(A), dependendo da duração da sua jornada de trabalho.\n\nO nível de ruído permitido em decibéis varia conforme a carga horária.\n\nNo Brasil, para uma jornada de oito horas, a exposição ao ruído contínuo ou intermitente deve ser de, no máximo, 85 dB(A) e, para seis horas, o limite é de 87 dB(A).\n\nTais delimitações estão previstas no Anexo 1 da NR 15. “A partir do momento em que o colaborador está exposto acima do limite aceitável, é necessário realizar um controle do ruído no ambiente de trabalho”, pontua.\n\nVários são os tipos de protetores auditivos à venda atualmente, assim como há diversos fornecedores no mercado.\n\nSegundo Gerges, há em torno de mil marcas comerciais oferecendo soluções em proteção auditiva em nível internacional.\n\n“A oferta é grande, por isso é preciso ser exigente na hora da escolha”, ensina o especialista com mais de 40 anos de experiência na área de ruído e vibrações."
    },
  ];

  List<int> _getCtaPositions(int totalItems) {
    if (totalItems <= 10) {
      return [];
    } else if (totalItems <= 20) {
      return [totalItems ~/ 2];
    } else if (totalItems <= 50) {
      return [
        (totalItems * 0.3).round(),
        (totalItems * 0.7).round(),
      ];
    } else {
      return [
        (totalItems * 0.25).round(),
        (totalItems * 0.5).round(),
        (totalItems * 0.75).round(),
      ];
    }
  }

  int _dataIndexFromDisplayIndex(int displayIndex, List<int> ctaPositions) {
    int dataIndex = displayIndex;
    for (final ctaIndex in ctaPositions) {
      if (ctaIndex < displayIndex) {
        dataIndex--;
      } else {
        break;
      }
    }
    return dataIndex;
  }

  @override
  Widget build(BuildContext context) {
    final ctaPositions = _getCtaPositions(dds.length);
    final int displayItemCount = dds.length + ctaPositions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'DDS'.toUpperCase(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: displayItemCount,
              itemBuilder: (context, displayIndex) {
                // 1. Se for CTA, renderiza e sai
                if (ctaPositions.contains(displayIndex)) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: RewardCTAWidget(),
                  );
                }

                // 2. Mapear índice de exibição -> índice real
                final int dataIndex =
                    _dataIndexFromDisplayIndex(displayIndex, ctaPositions);

                return ModernListTile(
                  title: dds[dataIndex]["title"]!.toUpperCase(),
                  subtitle: "Diálogo Diário de Segurança",
                  icon: Icons.verified_user_outlined,
                  iconColor: primaryColor,
                  onTap: () async {
                    if (!context.mounted) return;

                    InterstitialAdManager.showInterstitialAd(
                      context,
                      DdsBase(
                        title: dds[dataIndex]["title"]!,
                        content: dds[dataIndex]["content"]!,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
