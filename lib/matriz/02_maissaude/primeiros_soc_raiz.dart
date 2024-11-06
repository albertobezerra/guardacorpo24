import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/primeiros_soc_base.dart';

import '../../admob/banner_ad_widget.dart';
import '../../admob/interstitial_ad_manager.dart';

class PrimeirosSocRz extends StatefulWidget {
  const PrimeirosSocRz({super.key});

  @override
  State<PrimeirosSocRz> createState() => _PrimeirosSocRzState();
}

class _PrimeirosSocRzState extends State<PrimeirosSocRz> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.loadInterstitialAd();
  }

  final List<Map<String, String>> socorros = [
    {
      "title": "Corte e Escoriações",
      "content":
          "São nos primeiros socorros que podemos salvar a vida de qualquer pessoa. A NR 7 diz que todo estabelecimento deverá estar equipado com material necessário à prestação dos primeiros socorros, considerando-se as características da atividade desenvolvida. O material deve ser guardado em local adequado e aos cuidados de pessoa treinada para esse fim.\n\nContudo, a pessoa que vai prestar os primeiros socorros deve ser devidamente treinada para tal. No treinamento os responsáveis pelo kit precisam aprender a manusear os equipamentos, fazer curativos e prestar atendimento.\n\nDEVE CONTER NO KIT DE PRIMEIROS SOCORROS?\n\n• Caixa para acondicionamento do kit.\n\n• Pinça: Para poder retirar algum objeto encravado na pele (somente se for indispensável). O ideal é esperar atendimento médico para retirar qualquer item que penetre no organismo.\n\n• Tesoura: Para o caso de ter soltar uma pessoa presa pela roupa em algum equipamento, cortar roupas para fazer imobilizações, cortar pedaços de roupas contaminadas, cortar tiras para imobilizações.\n\n• Luvas cirúrgicas: Para evitar contato com secreções corpóreas da vítima.\n\n• Máscara facial: Para proteção do socorrista contra contato com fluidos corpóreos da vítima que de alguma forma possam se locomovem pelo do ar.\n\n• Óculos de proteção: Para proteção do socorrista contra contato com fluidos corpóreos da vítima lançadas através do ar.\n\n• Compressa quente: Dilata os vasos sanguíneos e aumentam a circulação, podem ser usadas para diminuir inchaços e facilitam a penetração de remédios por via cutânea.\n\n• Compressa fria: Usadas para reduzir a dor, inchaços, edemas, câimbras, reduz fadiga muscular.\n\n• Gaze: Servem para fazer compressas, para fazer limpeza no ferimento. Pode também ser colocado diretamente sobre o ferimento fazendo parte do curativo.\n\n• Esparadrapo: Adesivo flexível que serve para fixar o curativo. Quando fazemos curativos em articulações saber usar a o esparadrapo faz toda diferença para determinar se o curativo será fixado com sucesso ou não.\n\n• Atadura de crepe: Serve para enfaixar a área lesionada e também para imobilizar.\n\n• Soro fisiológico ou solução iodada: Serve para lavar a área lesionada.\n\n• Cotonete: Nesse caso seria usado para limpeza de ferimentos onde a água não tenha conseguido penetrar com eficiência.\n\n• Antisséptico: Serve para inibir a procriação de micro-organismos que poderiam se proliferar na superfície da pele.\n\n• Saco plástico vedante: Para correto acondicionamento do lixo gerado no atendimento."
    },
    {
      "title": "Esmagamentos",
      "content":
          "Pode resultar em ferimentos abertos ou fechados. O dano tecidual é extenso (músculos, tendões, ossos). Os esmagamentos de tórax e abdome causam graves distúrbios circulatórios e respiratórios, sendo muitas vezes incompatíveis com a vida.\n\n No caso de extremidade presa a maquinaria industrial, desligar a energia da máquina, e em seguida fazer a lenta reversão manual das engrenagens e retirada do membro. Caso não seja possível liberar a extremidade a máquina deverá ser desmontada e transportada juntamente com a vítima ao hospital.",
    },
    {
      "title": "Amputação",
      "content":
          "É a separação de um membro ou estrutura do restante do corpo. Pode ser causada por diversos tipos de acidentes. Entre os mais comuns estão os com objetos cortantes (serra elétrica), os acidentes de trânsito (principalmente de moto), a violência, o choque e o esmagamento.\n\nNesse tipo de emergência, a rapidez na busca pelo atendimento é um fator determinante para conter qualquer tipo de infecção e também para o sucesso da reimplantação do membro.\n\nSe for preciso limpar o local da amputação, faça isso com um pano bem limpo e não use nenhuma outra substância. Faça a compressão do local com força, com um pano limpo para conter o sangue. Não se esqueça de recolher a parte amputada. Se a distância até o hospital não for longa, enrole-a com um pano limpo e coloque-a dentro de uma sacola plástica limpa. Se o socorro for demorar mais de 6 horas, enrole a parte amputada em um pano limpo, coloque-a em um pacote plástico bem fechado e, em seguida, ponha o pacote dentro de outra sacola com gelo.\n\nNão coloque a parte amputada diretamente no gelo, é necessário apenas refrigerá-la. As amputações podem ocasionar hemorragia e infecção, e levar ao estado de choque e à morte. Por essa razão é preciso procurar o socorro rápido para evitar a falta de vascularização no local, o que pode ocasionar gangrena. O sucesso do reimplante vai depender principalmente do tipo de corte e do tempo decorrido do acidente até o recebimento do socorro apropriado.",
    },
    {
      "title": "Corte e Escoriações",
      "content":
          "Os cortes são ferimentos que acontecem com frequência em casa. Existem diversas formas de se machucar, seja com uma faca na cozinha, escorregando no chão molhado, pisando em um caco de vidro ou esbarrando em objetos pontudos. É importante saber cuidar do ferimento para que ele não infeccione.\n\nPrimeiros socorros em cortes superficiais\n\nA primeira coisa a ser feita é ter certeza de que a ferida não é grave.\n\nEm seguida deve-se lavar as mãos com água e sabão.\n\nLave a ferida com muito cuidado com água e sabão. Certifique-se de que o local ficou bem limpo e livre de partículas que poderiam causar infecção.\n\nAplique um anti-séptico e seque o local em volta da ferida.\n\nDe acordo com a lesão, coloque uma gaze ou pano limpo para cobrir o ferimento. Não use algodão, pois as fibras do material podem colar na ferida, provocando novamente sangramento ao retirar o curativo.\n\nMantenha o corte limpo e seco para facilitar a cicatrização.\n\nPrimeiros socorros em cortes profundos\n\nÉ preciso manter a calma e controlar a hemorragia imediatamente.\n\nPressione uma gaze ou pano limpo sobre o corte. Se ele não for tão profundo, o sangramento deve parar em alguns minutos. Em seguida lave a ferida com água e sabão.\n\nCaso a água não seja suficiente para remover a sujidade do corte, use uma gaze para retirar as partículas que ficaram coladas dentro do machucado.\n\nSe houver um pedaço de cristal ou outro objeto cravado no corte não tente retirá-lo, pode provocar uma hemorragia maior.\n\nEm casos de sangramento intenso, uma boa dica é elevar o membro para reduzir o fluxo de sangue.\n\nCom a compressa de gaze contendo o sangramento, o médico deverá ser consultado imediatamente para avaliar o corte e realizar uma sutura.\n\nApós a sutura, os curativos devem ser realizados para que a cicatrização seja eficaz.\n\nEscoriações: Lesões superficiais da pele ou mucosas, que apresentam sangramento leve e costumam ser extremamente dolorosas. Não representam risco ao paciente quando isoladas.\n\nLesões corto-contusas: Lesões produzidas por objetos cortantes. Podem causar sangramento de variados graus e danos a tendões, músculos, nervos e vasos sanguíneos.\n\nLacerações: Grandes lesões corto-contusas, geralmente com lesões de músculos, tendões, nervos e sangramento que pode ser moderado a intenso. Grandes traumas como ex: acidentes automobilísticos.\n\nO socorrista deve controlar o sangramento por compressão direta e aplicação de curativo e bandagens. Imobilize extremidades com ferimentos profundos.\n\nEm pacientes com PA normal efetue a limpeza das lesões de forma rápida. No trauma grave este procedimento é omitido para reduzir o tempo de chegada ao hospital.",
    },
    {
      "title": "Engasgamentos",
      "content":
          "Denominamos engasgo quando ocorre o bloqueio da traqueia ( órgão responsável em enviar e retirar o ar dos pulmões) por um objeto estranho, por vômito ou até mesmo sangue.\n\nFisiologicamente, a traqueia é frequentemente protegida pela epiglote; esta nada mais serve como uma porta que abre e fecha, conforme a necessidade de ar. Assim, quando ocorre a passagem de ar, a epiglote permanece aberta, porém quando ocorre a alimentação, a epiglote é fechada, impedindo que qualquer alimento ou corpo estranho, alcance a traqueia e, posteriormente, os pulmões.Dessa forma, quando a epiglote falha em sua função, os alimentos, líquidos ou qualquer tipo de objeto estranho, ultrapassa a epiglote, alcançando a traqueia, ocasionando o bloqueio do ar. \n\nPor isso que, em alguns casos, o engasgo pode levar à morte por asfixia e, às vezes, pode até deixar a pessoa parcialmente ou totalmente inconsciente. É necessário saber que dependendo da gravidade do engasgo, este é uma situação de emergência médica, sendo necessário chamar o serviço de atendimento especializado em emergência o mais rápido possível; pode ser uma questão de vida ou morte!\n\nEm caso de engasgo por corpos estranhos como: moedas, pequenos brinquedos, pedra ou qualquer outro objeto pequeno, a manobra que se realiza é a conhecida mundialmente como Manobra de Heimlich. Esta manobra tem como objetivo realizar uma pressão positiva na região do epigastro (“boca do estômago”), a qual fica localizada dois dedos abaixo do fim do esterno (osso longo que une as costelas), colaborando com a desobstrução e consequente passagem de ar.\n\nComo realizar a Manobra de Heimlich nos adultos e crianças maiores que um ano?\n\nAbraçar a pessoa engasgada pelo abdômen;\nNo caso de adultos, posicionar-se atrás da pessoa ainda consciente;\nNo caso de crianças, posicionar-se atrás, mas de joelhos.\n\nAtrás da vítima coloque uma das mãos sobre a região da “boca do estômago” e com a outra mão, comprima a primeira mão, ao mesmo tempo em que empurra a região dentro e para cima, parecendo que está levantando a pessoa.\n\nContinue o movimento até que a pessoa elimine o objeto que está causando a obstrução.\n\nEm caso de pessoa inconsciente, não realize a manobra e contate imediatamente o serviço de emergência.\n\nComo realizar a manobra em crianças menores de um ano e bebê\n\nBebê consciente\n\nColoque o bebê de bruços em cima de seu braço e faça 5 compressões entre as escápulas ( no meio das costas).\n\nDepois, vire o bebê de barriga para cima e faça 5 compressões sobre o esterno (osso do meio).\n\nSe conseguir visualizar o objeto, retire o mesmo.\n\nCaso não seja possível a visualização do objeto, nem a retirada, continue realizando as compressões até a chegada do serviço de emergência.\n\nBebê inconsciente\n\nDeite o bebê de barriga para cima sem seu braço e abra boca e nariz.\n\nVerifique se o bebê está respirando.\n\nSe o bebê não estiver respirando, realize duas respirações que boca-boca, bloqueando a boca e o nariz.\n\nObserve se há expansão do peito; em caso negativo, realize novamente a respiração.\n\nContate imediatamente o serviço de atendimento de emergência.\n\nEm todas as situações de primeiros socorros é necessário manter a calma, para poder agir com segurança e inteligência.",
    },
    {
      "title": "Desmaios e Convulsões",
      "content":
          "Desmaios são quedas causadas por um estado de semiconsciência ou inconsciência repentina, quando o cérebro deixa de receber a quantidade necessária de oxigênio ou açúcar para manter suas funções plenamente ativas.\n\nO desmaio pode ser ocasionado por diversas razões como calor, longos períodos sem ingerir alimentos, cansaço, emoções muito fortes, etc.\n\nIdentifica-se a pessoa com palidez, pulsação baixa, suor frio, fraqueza, entre outros; assemelha-se em sintomas com o estado de choque.\n\nSe a pessoa estiver prestes a desmaiar; sentá-la com a cabeça entre os joelhos e as penas formando um ângulo, ou deitá-la com as pernas levantadas.\n\nMolhar a testa da pessoa com água fria;\nAfrouxar as roupas da vítima.\n\nSe a pessoa já se encontrar desmaiada, deve-se deitá-la na PLS (Posição Lateral de Segurança), de preferência com a cabeça ligeiramente mais baixa que as pernas.\n\nAfrouxar as roupas da vítima e mantê-la de forma confortável e aquecida. Assim que a vítima recobrar seus sentidos, recomenda-se que se dê algo açucarado para tomar, para recuperar os níveis de açúcares perdidos os quais podem ter sido a causa do desmaio (vale lembrar que o consumo excessivo de açúcar em situações extraordinárias como a de um desmaio, não acarreta em prejuízo para o organismo).\n\nCaso a pessoa não recupere os sentidos, deve-se administrar uma espécie de pasta feita com água e açúcar, com pouca água e mais açúcar. Esta “pasta” deve ser colocada debaixo da lígua da pessoa mesmo inconsciente, e aguardar o socorro médico.\n\nNão se deve dar nada para tomar à vitima que ainda estiver inconsciente, pois ela pode se afogar ou engasgar com os líquidos, devido ao estado de inconsciência.\n\nAs convulsões são episódios onde o indivíduo perde a consciência com desmaio e inicia um período de tremores por todo o corpo com contração e relaxamento dos músculos.\n\nElas acontecem devido a uma má comunicação dos neurônios no cérebro e podem estar relacionadas com a epilepsia.\nNormalmente depois da convulsão o paciente não se lembra do que aconteceu e pode se encontrar desorientado e por isso é importante ajudar a vítima a se orientar e a perceber o que aconteceu.\n\nOs primeiros socorros para convulsões são:\n\nDar espaço para a vítima.\n\nAfastar objetos que possam machucar a vítima, como mesas e cadeiras.\n\nColocar a vítima de lado ou, se não for possível, colocar a cabeça dela de lado, sem forçar.\n\nDesapertar as roupas apertadas da vítima, abrindo os botões da camisa e abrindo o cinto.\n\nRetirar próteses dentárias e outros objetos que possam dificultar a respiração.\n\nColocar uma proteção entre os dentes, como um pedaço de pano enrolado, para evitar o ranger dos dentes e a mordedura da língua.\n\nFicar junto da vítima até que ela recupere a consciência.\n\nEm nenhum caso se deve colocar os dedos dentro da boca da vítima para impedir a queda da língua, pois com a contração muscular o indivíduo pode involuntariamente morder a mão do indivíduo.",
    },
    {
      "title": "Animais Peçonhetos",
      "content":
          "Não fazer sucção do veneno.\n\nNão espremer o local da picada.\n\nNão dar nada alcoólico, querosene ou fumo para o acidentado.\n\nNão fazer torniquete, impedindo a circulação do sangue: isso pode causar gangrena ou necrose local.\n\nNão cortar ou queimar o local da ferida.\n\nNão fazer aplicação de folhas, pó de café ou terra sobre a ferida, sob o risco de infecção.\n\nManter a pessoa em repouso, evitando o seu movimento para que não favoreça a absorção do veneno.\n\nManter a região picada no mesmo nível do coração ou, se possível, abaixo dele.\n\nLocalizar a marca da picada e limpar o local com água e sabão ou soro fisiológico.\n\nCobrir o local com um pano limpo;\nRemover anéis, pulseiras e outros objetos que possam prender a circulação sanguínea, em caso de inchaço do membro afetado.\n\nLevar a pessoa imediatamente para o pronto-socorro mais próximo ou ligar para o serviço de emergência.\n\nTentar identificar que tipo de animal atacou a vítima, observando cor, tamanho e características dele.\n\nSe possível, levar o animal causador do acidente para identificação.\n\nNo caso de acidentes causados por escorpiões, aranha-armadeira e viúva-negra, recomenda-se fazer compressas mornas no local e analgésicos para alívio da dor.",
    },
    {
      "title": "Descarga Elétrica",
      "content":
          "É a passagem de uma corrente pelo copo tornando-se um condutor elétrico.\n\nEssa condução de corrente varia de acordo com a intensidade de volts com que a pessoa é submetida no choque elétrico e pode gerar desde um pequeno susto, até uma fibrilação cardíaca, ou mesmo a morte.\n\nO choque elétrico pode ser causado por fenômenos naturais como um raio, por exemplo, ou acidentes como o contato direto com fiações elétricas domésticas ou públicas, áreas energizadas em decorrência de alguma fonte de energia mal isoladas, ou até mesmo o contato direto com uma pessoa que está recebendo uma descarga elétrica.\n\nNo caso de estar presenciando o momento do ocorrido, procurar imediatamente afastar a vítima com a fonte da corrente elétrica, desligando o interruptor próximo.\n\nCaso seja um fio, afaste da pessoa com um instrumento de material não condutor que esteja seco (madeira, plástico, pano grosso, borracha, com exceção de materiais de metal), procure locomover a vítima também com algum desses instrumentos, uma vez que ela estará energizada e poderá assim, transmitir o choque a você.\n\nAguarde uns segundos e inicie os procedimentos de socorro, já tendo acionado um serviço especializado antes. Observe os sinais e se a vítima estiver inconsciente, sem pulso ou respiração, aplique as técnicas de ressuscitação com massagem cardíaca e respiração artificial.\n\nDeve-se desapertar as roupas e ficar atento aos sinais vitais, ainda que a vítima tenha recuperado a pulsação e a respiração. Em casos de choques, essas variações de quadro são comuns, e pode ser necessária nova intervenção de reanimação.\n\nSe a vítima apresentar inconsciência; porém, estiver respirando e com pulsação, deve-se colocá-la na PLS (Posição Lateral de Segurança) descrita anteriormente e aguardar a chegada do socorro especializado.",
    },
    {
      "title": "Queimaduras",
      "content":
          "Podem ser provocadas por choque elétrico, fogo, ferro quente, água quente, exposição prolongada ao sol forte e outras situações.\n\n\nO que fazer?\n • Se a queimadura for superficial, lavar apenas com água gelada e secar o local com pano limpo.\n\n • Se houver necessidade de um curativo, deve-se fazê-lo com gaze para proteger, evitar atrito e contaminação.\n\n • Quando a queimadura é muito grande ou é causada pelo excesso de exposição ao sol, deve-se ingerir muito líquido.\n\n • Se a queimadura for grande, procure um hospital para receber tratamento adequado.\n\n\nATENÇÃO\n\nSe houver o aparecimento de bolhas, não as fure e não use pomadas, pasta de dente, azeite ou outro produto caseiro.",
    },
    {
      "title": "Fraturas",
      "content":
          "É a ruptura ou quebra de um osso. Podem ser ocasionadas por uma queda ou um choque entre dois corpos.\n\nQuando uma pessoa sofre algum tipo de fratura, ela deve ser encaminhada a um hospital para receber cuidados médicos.\n\n\nO que fazer?\n• Quando a fratura for no braço ou na perna, podemos imobilizar o osso quebrado com uma tala ou tipoia. A vítima deve manter-se o mais próximo possível da posição normal até que chegue ao hospital.\n\n • Quando a fratura for na cabeça, coluna ou pescoço, devemos imobilizar a vítima e não removê-la até que chegue a ambulância.",
    },
    {
      "title": "Afogamentos",
      "content":
          "Quando uma pessoa se afoga, ela perde a respiração. Isso acontece porque suas vias aéreas ficam inundadas.\n\n\nO que fazer?\n• Colocar a vítima de costas e fazer respiração boca a boca e massagens cardíacas intercaladas.\n\n • Conduzir imediatamente a vítima a um hospital ou pronto-socorro próximo.",
    },
    {
      "title": "Mordida de Animais",
      "content":
          "A mordida de cachorros e gatos pode ocasionar a raiva, que é uma doença muito perigosa. Ela pode ser evitada por meio da vacina antirrábica, que é aplicada nesses animais.\n\n\nO que fazer?\n• Lavar o local com água e sabão para desinfetá-lo.\n\n • Proteger o ferimento com gaze ou pano limpo e encaminhar a vítima para o hospital ou pronto-socorro mais próximo.\n\n • O animal que causou a mordedura deve ficar em observação para que se verifique se ele está doente.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Primeiros Socorros'.toUpperCase(),
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
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                margin: const EdgeInsets.all(24),
                child: ListView.builder(
                  itemCount: socorros.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () async {
                          InterstitialAdManager.showInterstitialAd(
                            context,
                            PrimeirosSocBase(
                                title: socorros[index]["title"]!,
                                content: socorros[index][
                                    "content"]!), // Passa o título e o conteúdo
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              const Icon(Icons.library_books),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  socorros[index]["title"]!.toUpperCase(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: 'Segoe Bold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const BannerAdWidget(), // Mantém o BannerAdWidget fixo na parte inferior
        ],
      ),
    );
  }
}
