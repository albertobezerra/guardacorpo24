import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';

class Tecnico extends StatelessWidget {
  const Tecnico({super.key});

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
          'TÉCNICO EM SEGURANÇA DO TRABALHO',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: primary,
            letterSpacing: 1.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const _TecnicoContent(),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _TecnicoContent extends StatelessWidget {
  const _TecnicoContent();

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
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
        style: const TextStyle(fontSize: 14, height: 1.6),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(
          'O profissional de Segurança do Trabalho pode atuar como técnico, engenheiro, médico ou enfermeiro, conforme a formação. '
          'O técnico em segurança do trabalho tem papel central no dia a dia das empresas, apoiando a prevenção de acidentes e doenças ocupacionais.\n',
        ),
        _title('Atuação do técnico'),
        _body(
          'Entre as principais atividades estão:\n'
          '• Desenvolver e acompanhar programas de prevenção de acidentes e doenças.\n'
          '• Apoiar a CIPA e demais comissões de segurança.\n'
          '• Orientar sobre uso adequado de EPI e EPC.\n'
          '• Realizar inspeções de segurança, registrar não conformidades e propor melhorias.\n'
          '• Elaborar relatórios, laudos básicos e participar de treinamentos e campanhas.\n',
        ),
        _title('Trabalho em equipe multiprofissional'),
        _body(
          'O técnico atua em conjunto com engenheiros de segurança, médicos e enfermeiros do trabalho, bem como com gestores e RH. '
          'Enquanto a área médica foca em prevenção de doenças e exames ocupacionais, o técnico concentra-se nas condições de ambiente, '
          'organização do trabalho e comportamentos seguros.\n',
        ),
        _title('Novos desafios e tecnologias'),
        _body(
          'A evolução tecnológica trouxe recursos como monitoramento em tempo real, sensores, análises de dados e sistemas digitais de gestão de SST. '
          'Cabe ao técnico atualizar-se continuamente para usar essas ferramentas e melhorar a prevenção.\n',
        ),
        _title('Cultura de segurança'),
        _body(
          'Mais do que cumprir normas, o técnico contribui para construir uma cultura de segurança, estimulando a participação dos trabalhadores, '
          'a comunicação aberta sobre riscos e o aprendizado com incidentes. Essa abordagem reduz acidentes e fortalece o bem-estar no trabalho.\n',
        ),
      ],
    );
  }
}
