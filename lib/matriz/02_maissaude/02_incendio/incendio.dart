import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

class Incendio extends StatelessWidget {
  const Incendio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SOBRE INCÊNDIO',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('O que é um incêndio?'),
                  _bodyText(
                    'Incêndio é a ocorrência de fogo não controlado, capaz de causar danos a pessoas, estruturas e ao meio ambiente. '
                    'Os principais riscos estão ligados à inalação de fumaça e gases tóxicos, queimaduras e desabamentos.\n',
                  ),
                  _sectionTitle('Formas de propagação do fogo'),
                  _bodyText(
                    'Em edificações, os incêndios podem começar por falhas elétricas, uso inadequado de equipamentos, velas, cigarros, entre outros. '
                    'O fogo se propaga principalmente por quatro mecanismos:',
                  ),
                  const SizedBox(height: 8),
                  _bullet(
                      'Irradiação: energia térmica se propaga por ondas eletromagnéticas (infravermelho).'),
                  _bullet(
                      'Convecção: o ar aquecido se desloca, levando calor e chamas para outros pontos.'),
                  _bullet(
                      'Condução: o calor se transfere por materiais sólidos (ex.: estruturas metálicas).'),
                  _bullet(
                      'Projeção de partículas: fagulhas e brasas são transportadas pelo vento ou explosões.'),
                  const SizedBox(height: 16),
                  _sectionTitle('Incêndios florestais'),
                  _bodyText(
                    'Podem ser intencionais ou acidentais e impactam grandes áreas, afetando fauna, flora e economia. '
                    'Mesmo quando controlados, exigem planejamento e recursos especializados.',
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Métodos de extinção'),
                  const SizedBox(height: 8),
                  _bullet(
                      'Arrefecimento: redução da temperatura do combustível, geralmente com água.'),
                  _bullet(
                      'Abafamento: redução ou retirada do oxigênio em contato com o fogo.'),
                  _bullet(
                      'Retirada do combustível: isolamento do material combustível ou corte de suprimento.'),
                  const SizedBox(height: 16),
                  _sectionTitle('Classes de incêndio'),
                  const SizedBox(height: 8),
                  _subTitle('Classe A'),
                  _bodyText(
                      'Materiais sólidos combustíveis, como papel, tecido, madeira. Extintor mais indicado: água e espuma.'),
                  _subTitle('Classe B'),
                  _bodyText(
                      'Líquidos inflamáveis, óleos, graxas, solventes. Extintores indicados: pó químico seco, CO₂, espuma mecânica.'),
                  _subTitle('Classe C'),
                  _bodyText(
                      'Equipamentos e instalações elétricas energizadas. Extintores: pó químico seco e CO₂.'),
                  _subTitle('Classe D'),
                  _bodyText(
                      'Metais pirofóricos (magnésio, sódio, potássio). Exigem agentes extintores especiais para metais.'),
                  _subTitle('Classe K'),
                  _bodyText(
                      'Óleos e gorduras de cozinhas industriais/comerciais. Devem ser usados extintores específicos classe K.'),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _subTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _bodyText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[800],
          height: 1.6,
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 16, height: 1.4, color: Colors.black)),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
