import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

class Epi extends StatelessWidget {
  const Epi({super.key});

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
          'SOBRE E.P.IS',
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
                  Text(
                    'O que são EPIs?',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Equipamentos de Proteção Individual (EPIs) protegem o trabalhador contra riscos capazes de ameaçar sua saúde e integridade física. '
                    'São essenciais em atividades com exposição a ruído, altura, agentes químicos, biológicos, entre outros.\n',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Tipos de EPI'),
                  _bodyText(
                    'Os tipos de EPIs variam conforme a atividade, o risco presente e a parte do corpo a ser protegida.',
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle('EPC x EPI'),
                  _bodyText(
                    'Equipamentos de Proteção Coletiva (EPCs) atuam sobre o ambiente (ex.: enclausuramento acústico, ventilação, proteção de máquinas). '
                    'Quando os EPCs não eliminam o risco, o uso de EPIs é obrigatório.',
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Principais grupos de EPIs'),
                  const SizedBox(height: 8),
                  _bullet('Proteção da cabeça: capacetes.'),
                  _bullet(
                      'Proteção auditiva: abafadores de ruído, protetores auriculares.'),
                  _bullet(
                      'Proteção respiratória: máscaras e respiradores específicos.'),
                  _bullet(
                      'Proteção ocular e facial: óculos, viseiras, protetores faciais.'),
                  _bullet(
                      'Proteção de mãos e braços: luvas para riscos mecânicos, químicos, térmicos, biológicos ou elétricos.'),
                  _bullet(
                      'Proteção de pés e pernas: sapatos, botas, coturnos adequados ao risco.'),
                  _bullet(
                      'Proteção contra quedas: cinturões, talabartes e sistemas antiqueda.'),
                  _bullet(
                      'Proteção de tronco: aventais, jaquetas, coletes, conforme o risco.'),
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

  Widget _bodyText(String text) {
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
