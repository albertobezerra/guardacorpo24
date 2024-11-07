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
          "Os primeiros socorros são fundamentais para salvar vidas. De acordo com a NR 7, todo estabelecimento deve ter material necessário para primeiros socorros, considerando as características da atividade desenvolvida. Esse material deve ser armazenado em local adequado e sob cuidados de pessoa treinada.\n\nA pessoa responsável pelos primeiros socorros deve ser devidamente treinada. Esse treinamento envolve manuseio dos equipamentos, realização de curativos e atendimento emergencial.\n\nO KIT DE PRIMEIROS SOCORROS DEVE CONTER:\n\n• Caixa para acondicionar o kit.\n\n• Pinça: Para retirada de objetos cravados na pele, se absolutamente necessário (preferencialmente, deve-se esperar por atendimento médico).\n\n• Tesoura: Para cortar roupas em casos de imobilização, liberar alguém preso em equipamento ou cortar tiras de imobilização.\n\n• Luvas cirúrgicas: Para evitar contato direto com secreções da vítima.\n\n• Máscara facial: Para proteger o socorrista contra fluidos aéreos.\n\n• Óculos de proteção: Para proteger os olhos de fluidos potencialmente infecciosos.\n\n• Compressa quente: Ajuda na dilatação dos vasos sanguíneos e circulação; útil para reduzir inchaços.\n\n• Compressa fria: Usada para reduzir dor, inchaços e câimbras.\n\n• Gaze: Para compressas e limpeza de ferimentos, sendo colocada diretamente sobre o ferimento para curativos.\n\n• Esparadrapo: Fixador de curativos. É importante saber aplicá-lo corretamente em articulações.\n\n• Atadura de crepe: Para enfaixar e imobilizar áreas lesionadas.\n\n• Soro fisiológico ou solução iodada: Para lavar a área lesionada.\n\n• Cotonete: Para limpeza de ferimentos onde a água não foi suficiente.\n\n• Antisséptico: Para evitar a proliferação de micro-organismos.\n\n• Saco plástico vedante: Para descarte correto do lixo gerado."
    },
    {
      "title": "Esmagamentos",
      "content":
          "Esmagamentos podem causar ferimentos graves, abertos ou fechados, com danos extensivos a músculos, tendões e ossos. Esmagamentos no tórax e abdome podem ser fatais devido a distúrbios circulatórios e respiratórios.\n\nSe uma extremidade estiver presa em maquinaria industrial, deve-se desligar a máquina, realizar reversão manual lenta das engrenagens e retirar o membro. Caso não seja possível, desmontar a máquina e levar junto com a vítima ao hospital."
    },
    {
      "title": "Amputação",
      "content":
          "A amputação é a separação de uma parte do corpo, causada geralmente por objetos cortantes, acidentes de trânsito, violência, entre outros.\n\nBuscar atendimento rápido é crucial para evitar infecções e aumentar as chances de reimplante. Se precisar limpar o local, use um pano limpo. Comprima o local com força para conter o sangue e guarde a parte amputada em um saco plástico com gelo, sem contato direto com o gelo. O tempo decorrido até o socorro é decisivo para o sucesso do reimplante."
    },
    {
      "title": "Corte e Escoriações",
      "content":
          "Cortes são comuns e podem ocorrer em diversas situações. Para cortes superficiais, lave a ferida com água e sabão, aplique antisséptico, e cubra com gaze.\n\nPara cortes profundos, pressione com gaze ou pano limpo, lave cuidadosamente e, se necessário, eleve o membro para reduzir o fluxo de sangue. Em cortes graves, é indicado buscar atendimento médico imediatamente."
    },
    {
      "title": "Engasgamentos",
      "content":
          "Engasgos ocorrem quando há obstrução da traqueia por objetos estranhos, vômito ou sangue, podendo levar à asfixia.\n\nEm adultos e crianças maiores de um ano, a Manobra de Heimlich é indicada para desobstrução. Para bebês, recomenda-se alternar compressões nas costas e peito. Se a pessoa está inconsciente, contate o serviço de emergência imediatamente."
    },
    {
      "title": "Desmaios e Convulsões",
      "content":
          "Desmaios são causados pela falta temporária de oxigênio ou açúcar no cérebro. Se a pessoa mostrar sinais de desmaio, sente-a com a cabeça entre os joelhos ou deite-a com as pernas levantadas. Após o desmaio, se recobrar a consciência, ofereça algo açucarado.\n\nConvulsões são episódios de perda de consciência acompanhados de tremores. Afastar objetos perigosos, afrouxar roupas e manter a cabeça da vítima de lado são os passos recomendados. Não coloque os dedos na boca da vítima."
    },
    {
      "title": "Animais Peçonhentos",
      "content":
          "Em casos de picada por animais peçonhentos, não se deve fazer sucção, torniquete ou aplicar substâncias no local. Mantenha a pessoa em repouso, com a área da picada no mesmo nível do coração, se possível. Limpe com água e sabão, cubra com um pano limpo e leve a vítima imediatamente ao pronto-socorro."
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
