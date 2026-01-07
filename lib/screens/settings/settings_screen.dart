import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Estado dos Switches
  bool _notifyApp = true;
  bool _notifyEmail = false;
  String _appVersion = "Carregando...";

  // Controladores de Edição
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPasswordController = TextEditingController();
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _loadAppVersion();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editPasswordController.dispose();
    super.dispose();
  }

  // CARREGA PREFERÊNCIAS DO FIRESTORE
  Future<void> _loadUserPreferences() async {
    final user = _currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        setState(() {
          _notifyApp = data?['notifyApp'] ?? true;
          _notifyEmail = data?['notifyEmail'] ?? false;
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar preferências: $e");
    }
  }

  // SALVA PREFERÊNCIAS NO FIRESTORE
  Future<void> _savePreference(String field, bool value) async {
    final user = _currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({field: value}, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              field == 'notifyApp'
                  ? 'Notificações ${value ? 'ativadas' : 'desativadas'}'
                  : 'E-mails ${value ? 'ativados' : 'desativados'}',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // CARREGA VERSÃO REAL DO APP
  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar versão: $e");
      if (mounted) {
        setState(() {
          _appVersion = "Indisponível";
        });
      }
    }
  }

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
            // SEÇÃO CONTA
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
            _buildSwitchTile("Notificações Push", _notifyApp, (v) {
              setState(() => _notifyApp = v);
              _savePreference('notifyApp', v);
            }),
            _buildSwitchTile("Receber E-mails", _notifyEmail, (v) {
              setState(() => _notifyEmail = v);
              _savePreference('notifyEmail', v);
            }),

            const SizedBox(height: 30),

            // SEÇÃO SOBRE
            _buildSectionHeader("Sobre"),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: "Termos de Uso",
              /*onTap: () => _launchURL(
                  'https://guardacorpoapp.com.br/termos-de-uso'),*/ // Substitua pela sua URL real
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: "Política de Privacidade",
              /*onTap: () => _launchURL(
                  'https://guardacorpoapp.com.br/privacidade'),*/ // Substitua pela sua URL real
            ),
            _buildSettingsTile(
              icon: Icons.perm_device_information,
              title: "Versão do App",
              trailing: _appVersion,
            ),
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        trailing: trailing != null
            ? Text(trailing,
                style: const TextStyle(color: Colors.grey, fontSize: 13))
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

  // ABRIR URLs (Termos/Privacidade)
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o link';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao abrir link: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // BOTTOM SHEET DE EDIÇÃO
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
                  labelText: "Nova Senha (mínimo 6 caracteres)",
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

    if (value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("O campo não pode estar vazio"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (field == 'password' && value.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A senha deve ter no mínimo 6 caracteres"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pop(context); // Fecha modal

    try {
      if (field == 'name') {
        // Alterar nome (não precisa reauthenticar)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'name': value.trim()}, SetOptions(merge: true));
        await user.updateDisplayName(value.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Nome atualizado com sucesso!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (field == 'password') {
        // Alterar senha (PRECISA reauthenticar)
        await _reauthenticateAndChangePassword(value);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'requires-recent-login') {
        errorMessage =
            'Por segurança, faça login novamente para alterar a senha';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Senha muito fraca. Use no mínimo 6 caracteres';
      } else {
        errorMessage = 'Erro ao atualizar: ${e.message}';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// NOVA FUNÇÃO: Reauthenticar e alterar senha
  Future<void> _reauthenticateAndChangePassword(String newPassword) async {
    final user = _currentUser;
    if (user == null || user.email == null) return;

    // Pede a senha atual para reauthenticar
    final currentPasswordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirme sua Identidade"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Por segurança, digite sua senha atual:",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha Atual",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text("Confirmar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || currentPasswordController.text.isEmpty) {
      return; // Usuário cancelou
    }

    try {
      // 1. Reauthenticar com senha atual
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // 2. Agora pode alterar a senha
      await user.updatePassword(newPassword);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Senha alterada com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'Senha atual incorreta';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Nova senha muito fraca';
      } else if (e.code == 'user-mismatch') {
        errorMessage = 'Erro de autenticação. Faça login novamente';
      } else {
        errorMessage = 'Erro: ${e.message}';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      currentPasswordController.dispose();
    }
  }
}
