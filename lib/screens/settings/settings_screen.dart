import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Estado dos Switches
  bool _notifyApp = true;
  bool _notifyEmail = false;

  // Controladores de Edição (Movidos para cá)
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPasswordController = TextEditingController();
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Configurações",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // SEÇÃO CONTA (Funcional)
            _buildSectionHeader("Minha Conta"),
            _buildSettingsTile(
                icon: Icons.edit,
                title: "Alterar Nome",
                onTap: () {
                  _editNameController.text = _currentUser?.displayName ?? "";
                  _showEditBottomSheet(context, 'name');
                }),
            _buildSettingsTile(
                icon: Icons.lock_outline,
                title: "Alterar Senha",
                onTap: () {
                  _editPasswordController.clear();
                  _showEditBottomSheet(context, 'password');
                }),

            const SizedBox(height: 30),

            // SEÇÃO PREFERÊNCIAS
            _buildSectionHeader("Preferências"),
            _buildSwitchTile("Notificações Push", _notifyApp,
                (v) => setState(() => _notifyApp = v)),
            _buildSwitchTile("Receber E-mails", _notifyEmail,
                (v) => setState(() => _notifyEmail = v)),
            // _buildSwitchTile("Modo Escuro", _darkMode, (v) => setState(() => _darkMode = v)), // Opcional

            const SizedBox(height: 30),

            // SEÇÃO SOBRE
            _buildSectionHeader("Sobre"),
            _buildSettingsTile(
                icon: Icons.info_outline, title: "Termos de Uso", onTap: () {}),
            _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: "Política de Privacidade",
                onTap: () {}),
            _buildSettingsTile(
                icon: Icons.perm_device_information,
                title: "Versão do App",
                trailing: "1.0.0"),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      {required IconData icon,
      required String title,
      VoidCallback? onTap,
      String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            Colors.grey[50], // Fundo levemente cinza para diferenciar do branco
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        trailing: trailing != null
            ? Text(trailing, style: const TextStyle(color: Colors.grey))
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primaryColor,
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      ),
    );
  }

  // --- LÓGICA DE EDIÇÃO (Movida para cá) ---
  void _showEditBottomSheet(BuildContext context, String fieldType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 24,
            right: 24,
            top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldType == 'name' ? "Editar Nome" : "Alterar Senha",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            if (fieldType == 'name')
              TextField(
                controller: _editNameController,
                decoration: InputDecoration(
                  labelText: "Nome Completo",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            if (fieldType == 'password')
              TextField(
                controller: _editPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Nova Senha",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _updateUserField(
                    fieldType,
                    fieldType == 'name'
                        ? _editNameController.text
                        : _editPasswordController.text),
                child: const Text("Salvar",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserField(String field, String value) async {
    final user = _currentUser;
    if (user == null) return;
    Navigator.pop(context); // Fecha modal

    try {
      if (field == 'name') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': value});
        await user.updateDisplayName(value);
      } else if (field == 'password') {
        if (value.isEmpty) throw Exception('Senha vazia');
        await user.updatePassword(value);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Atualizado com sucesso!")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red));
      }
    }
  }
}
