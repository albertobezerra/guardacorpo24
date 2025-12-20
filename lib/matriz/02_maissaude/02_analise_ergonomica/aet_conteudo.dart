import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';

class AetConteudo extends StatelessWidget {
  const AetConteudo({super.key});

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
          'SOBRE A ANÁLISE ERGONÔMICA',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'O que é AET?',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A ergonomia estuda a interação entre trabalhadores e ambiente de trabalho, buscando otimizar bem‑estar e desempenho. '
                    'A Análise Ergonômica do Trabalho (AET) é uma ferramenta fundamental para identificar, avaliar e corrigir problemas ergonômicos, '
                    'prevenindo lesões e promovendo saúde no trabalho.\n',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Para que serve a AET?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBullet(
                      'Identificar riscos ergonômicos: posturas inadequadas, movimentos repetitivos e fatores que geram desconforto ou lesões.'),
                  _buildBullet(
                      'Melhorar postura e conforto: propor ajustes em mobiliário, layout e organização do trabalho.'),
                  _buildBullet(
                      'Aumentar produtividade: reduzir fadiga e esforço desnecessário.'),
                  _buildBullet(
                      'Reduzir absenteísmo: prevenir adoecimentos relacionados ao trabalho.'),
                  _buildBullet(
                      'Cumprir normas e regulamentações de SST, evitando penalidades.'),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
