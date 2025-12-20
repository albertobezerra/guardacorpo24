import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class MapaDaRisco extends StatelessWidget {
  const MapaDaRisco({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'SOBRE MAPA DE RISCO',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const _MapaContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _MapaContent extends StatelessWidget {
  const _MapaContent();

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _body(String text) => Text(
        text,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.6,
        ),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ',
                style:
                    TextStyle(fontSize: 16, height: 1.4, color: Colors.black)),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'O Mapa de Risco é uma ferramenta que representa visualmente os riscos existentes no ambiente de trabalho, '
          'facilitando a identificação de perigos e a conscientização dos trabalhadores.\n',
        ),
        _body(
          'Para construí‑lo, é necessário estudar cada setor da empresa, identificar agentes de risco e sua intensidade, '
          'e registrar essas informações de forma simples e objetiva.\n',
        ),
        _body(
          'Criado na década de 60 na Itália, o método chegou ao Brasil no fim dos anos 70 e passou a ser amplamente utilizado '
          'em função do aumento dos acidentes de trabalho e da necessidade de prevenção.\n',
        ),
        _body(
          'Com a NR‑5, o Mapa de Risco se consolidou como instrumento obrigatório em locais onde há CIPA, '
          'sendo exigido pelos órgãos de fiscalização de segurança e saúde no trabalho.\n',
        ),
        _title('Como fazer um Mapa de Risco?'),
        _body(
          'Embora cada empresa tenha suas particularidades, alguns passos são comuns ao processo de elaboração:',
        ),
        const SizedBox(height: 8),
        _bullet(
            'Reunir informações suficientes para diagnosticar a situação de segurança e saúde no trabalho do estabelecimento.'),
        _bullet(
            'Estimular a participação dos trabalhadores, promovendo troca e divulgação de informações sobre riscos e prevenção.'),
        _bullet('Conhecer o processo de trabalho no local analisado:'),
        _bullet(
            'Número de trabalhadores, distribuição por sexo e idade, formação profissional e treinamentos de SST.'),
        _bullet('Jornada de trabalho e organização das atividades.'),
        _bullet('Instrumentos, máquinas, equipamentos e materiais utilizados.'),
        _bullet('Características do ambiente físico.'),
        _bullet('Identificar os riscos existentes em cada posto ou setor.'),
        _bullet(
            'Mapear medidas de prevenção já existentes (coletivas, organizacionais, individuais, higiene e conforto) e sua eficácia.'),
        _bullet(
            'Levantar queixas mais frequentes, doenças ocupacionais relacionadas e principais causas de afastamento.'),
        _bullet('Verificar levantamentos ambientais já realizados.'),
        _bullet('Quantificar o número de trabalhadores expostos a cada risco.'),
        _bullet(
            'Classificar os agentes de risco (químicos, físicos, biológicos, ergonômicos ou de acidentes).'),
        _bullet(
            'Após aprovação da CIPA, fixar o Mapa de Risco em locais de fácil visualização para todos os trabalhadores.'),
        _title('Grupos de Risco'),
        _body(
          'Para facilitar a leitura, os riscos são agrupados por tipo e representados por cores padronizadas:',
        ),
        const SizedBox(height: 8),
        _bullet(
            'Grupo 1 – Riscos Físicos (Verde): ruído, vibração, radiações, frio, calor, pressões anormais e umidade.'),
        _bullet(
            'Grupo 2 – Riscos Químicos (Vermelho): poeiras, fumos, neblinas, gases, vapores e substâncias químicas em geral.'),
        _bullet(
            'Grupo 3 – Riscos Biológicos (Marrom): vírus, bactérias, fungos, parasitas e outros microrganismos.'),
        _bullet(
            'Grupo 4 – Riscos Ergonômicos (Amarelo): esforço físico intenso, levantamento de peso, postura inadequada, ritmos excessivos, turnos noturnos, monotonia e fatores de estresse.'),
        _bullet(
            'Grupo 5 – Riscos de Acidentes (Azul): arranjo físico inadequado, máquinas sem proteção, iluminação deficiente, risco de incêndio ou explosão, armazenamento inadequado, entre outros.'),
        _title('Quantificação dos Riscos'),
        _body(
          'Depois de qualificar e localizar os riscos, a etapa seguinte é quantificá‑los. Isso é feito, sempre que possível, '
          'por meio de medições com equipamentos específicos para cada agente (por exemplo, dosímetros, decibelímetros, bombas de amostragem).\n',
        ),
        _body(
          'O Mapa de Risco pode ser construído sobre a planta baixa da empresa ou sobre fotos dos ambientes, o que facilita a compreensão dos trabalhadores. '
          'Quando bem elaborado e divulgado, contribui para reduzir acidentes e doenças ocupacionais, reforçando a cultura de prevenção.\n',
        ),
      ],
    );
  }
}
