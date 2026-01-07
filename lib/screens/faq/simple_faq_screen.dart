import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleFAQScreen extends StatelessWidget {
  const SimpleFAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ajuda & FAQ",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildFAQItem(
            question: "Como funciona o sistema de pontos?",
            answer:
                "Você ganha pontos ao assistir anúncios de recompensa. Acumule pontos e troque por dias de acesso Premium sem anúncios.",
          ),
          _buildFAQItem(
            question: "O que é o Plano Premium?",
            answer:
                "Com o Premium você tem acesso a todo o conteúdo do app sem anúncios, incluindo recursos exclusivos como Inspeções e modelos avançados.",
          ),
          _buildFAQItem(
            question: "Como alterar minha senha?",
            answer:
                "Vá em Perfil → Configurações da Conta → Alterar Senha. Você pode redefinir sua senha a qualquer momento.",
          ),
          _buildFAQItem(
            question: "Meu benefício expirou, e agora?",
            answer:
                "Você pode renovar seu plano Premium na aba Premium, ou acumular pontos assistindo anúncios para resgatar dias grátis.",
          ),
          _buildFAQItem(
            question: "Como entrar em contato com o suporte?",
            answer:
                "Use o botão abaixo para falar conosco via WhatsApp ou e-mail.",
          ),

          const SizedBox(height: 30),

          // Botões de Contato
          ElevatedButton.icon(
            onPressed: () => _launchWhatsApp(),
            icon: const Icon(Icons.chat, color: Colors.white),
            label:
                const Text("WhatsApp", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => _launchEmail(),
            icon: const Icon(Icons.email, color: AppTheme.primaryColor),
            label: const Text("E-mail",
                style: TextStyle(color: AppTheme.primaryColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppTheme.primaryColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style:
                  TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  void _launchWhatsApp() async {
    final url = Uri.parse(
        'https://wa.me/351932046580?text=Olá,%20preciso%20de%20ajuda%20com%20o%20GuardaCorpo');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _launchEmail() async {
    final url = Uri.parse(
        'mailto:albertofbezerra@gmail.com?subject=Suporte%20GuardaCorpo');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
