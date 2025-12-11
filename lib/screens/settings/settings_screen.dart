// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Estado dos Switches (Toggles)
  bool _notifyApp = true;
  bool _notifyEmail = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEÇÃO CONTA ---
            _buildSectionHeader(Icons.person_outline, "Conta"),
            const SizedBox(height: 10),
            _buildSettingsTile(context, "Editar Perfil", onTap: () {}),
            _buildSettingsTile(context, "Alterar Senha", onTap: () {}),
            _buildSettingsTile(context, "Conectar Redes Sociais", onTap: () {}),

            const SizedBox(height: 30),

            // --- SEÇÃO NOTIFICAÇÕES ---
            _buildSectionHeader(Icons.notifications_none, "Notificações"),
            const SizedBox(height: 10),
            _buildSwitchTile("Notificações do App", _notifyApp,
                (val) => setState(() => _notifyApp = val)),
            _buildSwitchTile("Receber Emails", _notifyEmail,
                (val) => setState(() => _notifyEmail = val)),

            const SizedBox(height: 30),

            // --- SEÇÃO MAIS ---
            _buildSectionHeader(Icons.more_horiz, "Mais"),
            const SizedBox(height: 10),
            _buildSettingsTile(context, "Idioma", trailing: "Português (BR)"),
            _buildSettingsTile(context, "País / Região", trailing: "Brasil"),
            _buildSwitchTile(
                "Modo Escuro", // Exemplo de funcionalidade futura
                _darkMode,
                (val) => setState(() => _darkMode = val)),

            const SizedBox(height: 40),

            // --- BOTÃO SAIR ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton.icon(
                onPressed: () {
                  // Lógica de logout aqui
                },
                icon: const Icon(Icons.logout, color: Colors.grey),
                label: const Text(
                  "Sair da Conta",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para Cabeçalho de Seção (Ícone + Texto Grande)
  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  // Widget para Item de Menu Simples (Seta na direita)
  Widget _buildSettingsTile(BuildContext context, String title,
      {VoidCallback? onTap, String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(trailing,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            if (trailing != null) const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Widget para Item com Switch (Toggle)
  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }
}
