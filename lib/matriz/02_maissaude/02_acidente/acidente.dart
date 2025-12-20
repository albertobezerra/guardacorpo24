import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Acidente extends StatelessWidget {
  const Acidente({super.key});

  final Color primaryColor = const Color(0xFF006837);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SOBRE ACIDENTES',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Definição Legal'),
                  _buildText(
                      'Conforme dispõe o art. 19 da Lei nº 8.213/91, "acidente de trabalho é o que ocorre pelo exercício do trabalho a serviço da empresa ou pelo exercício do trabalho dos segurados, provocando lesão corporal ou perturbação funcional que cause a morte ou a perda ou redução, permanente ou temporária, da capacidade para o trabalho".\n\n'
                      'As doenças profissionais e ocupacionais equiparam-se a acidentes de trabalho.'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Doenças do Trabalho'),
                  _buildText(
                      'Os incisos do art. 20 da Lei nº 8.213/91 as conceitua:\n\n'
                      '• Doença Profissional: produzida pelo exercício do trabalho peculiar a determinada atividade.\n'
                      '• Doença do Trabalho: adquirida em função de condições especiais em que o trabalho é realizado.'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Equiparação a Acidente'),
                  _buildText('O art. 21 da Lei nº 8.213/91 equipara ainda:\n\n'
                      'I - Acidente ligado ao trabalho que contribuiu para morte ou redução da capacidade;\n'
                      'II - Acidente no local e horário de trabalho (agressão, ofensa física, imprudência, desabamento, etc);\n'
                      'III - Doença de contaminação acidental;\n'
                      'IV - Acidente fora do local (execução de ordem, viagem a serviço).'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Impactos'),
                  _buildText(
                      'Além das repercussões jurídicas, o empregador arca com custos econômicos e impacto no FAP (Fator Acidentário de Prevenção). Para o Estado, gera custos previdenciários bilionários com auxílios e pensões.'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Atos e Condições Inseguras'),
                  _buildText(
                      'Atos inseguros (falha humana/desrespeito às regras) e condições inseguras (ambiente inadequado) são as causas primárias. Mesmo acidentes sem gravidade devem ser vistos como oportunidades de prevenção.'),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.grey[800],
        height: 1.6,
      ),
    );
  }
}
