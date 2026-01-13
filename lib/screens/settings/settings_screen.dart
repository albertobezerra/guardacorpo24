import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
              onTap: () => _showTermsDialog(context),
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: "Política de Privacidade",
              onTap: () => _showPrivacyDialog(context),
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

  // DIALOG TERMOS DE USO
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.article, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text("Termos de Uso", style: TextStyle(fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Última atualização: 13 de janeiro de 2026",
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle("1. Aceitação dos Termos"),
              _buildParagraph(
                "Ao criar uma conta no GuardaCorpo, você aceita estes termos. Se não concordar, não utilize o aplicativo.",
              ),
              _buildSectionTitle("2. Cadastro e Responsabilidades"),
              _buildParagraph(
                "• Você deve ter 18 anos ou mais para usar o app\n"
                "• Forneça informações verdadeiras ao se cadastrar\n"
                "• Mantenha sua senha segura e confidencial\n"
                "• Você é responsável por todas as atividades em sua conta",
              ),
              _buildSectionTitle("3. Planos Disponíveis"),
              _buildParagraph(
                "Plano Gratuito:\n"
                "• Acesso básico com anúncios\n"
                "• Ganhe pontos assistindo anúncios de recompensa\n\n"
                "Plano Premium (Mensal):\n"
                "• Sem anúncios\n"
                "• Acesso a recursos exclusivos\n"
                "• Renovação automática via Google Play\n"
                "• Cancelamento a qualquer momento nas Assinaturas da Play Store",
              ),
              _buildSectionTitle("4. Sistema de Pontos"),
              _buildParagraph(
                "• Pontos são ganhos visualizando anúncios de recompensa\n"
                "• Podem ser trocados por dias de acesso Premium\n"
                "• Não têm valor monetário e não podem ser transferidos\n"
                "• Não são reembolsáveis",
              ),
              _buildSectionTitle("5. Proibições de Uso"),
              _buildParagraph(
                "É estritamente proibido:\n"
                "• Usar o app para fins ilegais ou fraudulentos\n"
                "• Tentar hackear, burlar ou explorar vulnerabilidades\n"
                "• Criar múltiplas contas para obter vantagens indevidas\n"
                "• Compartilhar conteúdo ofensivo, discriminatório ou prejudicial\n"
                "• Revender, redistribuir ou comercializar o acesso ao app",
              ),
              _buildSectionTitle("6. Suspensão e Cancelamento"),
              _buildParagraph(
                "Podemos suspender ou encerrar sua conta imediatamente se:\n"
                "• Violar qualquer um destes termos\n"
                "• Usar o app de forma abusiva ou fraudulenta\n"
                "• Houver atividade suspeita em sua conta",
              ),
              _buildSectionTitle("7. Modificações no Serviço"),
              _buildParagraph(
                "Reservamo-nos o direito de:\n"
                "• Modificar, suspender ou descontinuar recursos\n"
                "• Alterar preços de planos (com aviso prévio de 30 dias)\n"
                "• Atualizar estes termos (você será notificado)",
              ),
              _buildSectionTitle("8. Isenção de Garantias"),
              _buildParagraph(
                "O GuardaCorpo é fornecido 'como está'. Não garantimos:\n"
                "• Funcionamento ininterrupto ou sem erros\n"
                "• Que atenderá todas as suas expectativas\n"
                "• Compatibilidade com todos os dispositivos",
              ),
              _buildSectionTitle("9. Lei Aplicável"),
              _buildParagraph(
                "Estes termos são regidos pelas leis brasileiras. Disputas serão resolvidas nos tribunais competentes do Brasil.",
              ),
              _buildSectionTitle("10. Contato"),
              _buildParagraph(
                "Dúvidas sobre os Termos de Uso?\n📧 albertofbezerra@gmail.com",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

// DIALOG POLÍTICA DE PRIVACIDADE
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                "Política de Privacidade",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Última atualização: 13 de janeiro de 2026",
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle("1. Introdução"),
              _buildParagraph(
                "Esta política explica como coletamos, usamos, armazenamos e protegemos seus dados pessoais no GuardaCorpo. Respeitamos sua privacidade e cumprimos a LGPD (Lei Geral de Proteção de Dados).",
              ),
              _buildSectionTitle("2. Dados que Coletamos"),
              _buildParagraph(
                "Informações de Cadastro:\n"
                "• Nome completo\n"
                "• Endereço de e-mail\n"
                "• Senha (armazenada com criptografia)\n\n"
                "Dados de Uso do App:\n"
                "• Histórico de login e acessos\n"
                "• Pontos de recompensa acumulados\n"
                "• Status de assinatura (gratuito/premium)\n"
                "• Preferências de notificações\n\n"
                "Dados Técnicos Automáticos:\n"
                "• Modelo do dispositivo\n"
                "• Versão do sistema operacional\n"
                "• Endereço IP (para segurança)\n"
                "• Identificador único do dispositivo",
              ),
              _buildSectionTitle("3. Como Usamos Seus Dados"),
              _buildParagraph(
                "• Autenticar seu acesso ao app\n"
                "• Gerenciar sua conta e assinatura Premium\n"
                "• Processar pagamentos via Google Play\n"
                "• Enviar notificações importantes (apenas se você autorizar)\n"
                "• Melhorar a experiência e funcionalidades do app\n"
                "• Prevenir fraudes e garantir segurança\n"
                "• Cumprir obrigações legais e regulatórias",
              ),
              _buildSectionTitle("4. Compartilhamento de Dados"),
              _buildParagraph(
                "NÃO vendemos, alugamos ou comercializamos seus dados pessoais.\n\n"
                "Compartilhamos apenas com:\n\n"
                "Firebase (Google):\n"
                "• Autenticação de usuários\n"
                "• Armazenamento seguro em nuvem (Firestore)\n"
                "• Hospedagem de arquivos (Storage)\n\n"
                "Google Play Store:\n"
                "• Processamento de pagamentos\n"
                "• Gestão de assinaturas",
              ),
              _buildSectionTitle("5. Segurança dos Dados"),
              _buildParagraph(
                "Medidas de Proteção:\n"
                "• Criptografia SSL/TLS em todas as comunicações\n"
                "• Senhas armazenadas com hash bcrypt\n"
                "• Autenticação via Firebase Authentication\n"
                "• Servidores protegidos em data centers Google Cloud\n"
                "• Monitoramento contínuo contra acessos não autorizados",
              ),
              _buildSectionTitle("6. Seus Direitos (LGPD)"),
              _buildParagraph(
                "Você tem direito a:\n\n"
                "• Acessar: Solicitar cópia de seus dados pessoais\n"
                "• Corrigir: Atualizar informações incorretas ou desatualizadas\n"
                "• Excluir: Solicitar remoção definitiva de seus dados\n"
                "• Portabilidade: Exportar seus dados em formato legível\n"
                "• Revogar consentimento: Desativar notificações a qualquer momento\n"
                "• Oposição: Contestar o uso de seus dados\n\n"
                "Para exercer seus direitos:\n📧 albertofbezerra@gmail.com",
              ),
              _buildSectionTitle("7. Retenção de Dados"),
              _buildParagraph(
                "• Dados de conta ativa: Mantidos enquanto você usar o app\n"
                "• Após exclusão da conta: Removidos em até 30 dias\n"
                "• Dados obrigatórios por lei: Retidos pelo período legal exigido\n"
                "• Backups automáticos: Removidos após 60 dias",
              ),
              _buildSectionTitle("8. Cookies e Tecnologias"),
              _buildParagraph(
                "Usamos cookies e tecnologias similares para:\n"
                "• Manter sua sessão de login ativa\n"
                "• Lembrar suas preferências\n"
                "• Analisar uso do app (dados anônimos)\n\n"
                "Você pode gerenciar cookies nas configurações do dispositivo.",
              ),
              _buildSectionTitle("9. Menores de Idade"),
              _buildParagraph(
                "O GuardaCorpo não é destinado a menores de 18 anos. Se você for menor, use apenas com autorização e supervisão de um responsável legal.",
              ),
              _buildSectionTitle("10. Alterações nesta Política"),
              _buildParagraph(
                "Podemos atualizar esta política periodicamente. Mudanças importantes serão notificadas via:\n"
                "• E-mail cadastrado\n"
                "• Notificação no app\n"
                "• Aviso ao fazer login",
              ),
              _buildSectionTitle("11. Contato - Proteção de Dados"),
              _buildParagraph(
                "Para dúvidas, solicitações ou reclamações sobre privacidade:\n\n"
                "📧 E-mail: albertofbezerra@gmail.com\n"
                "📍 Responsável: Alberto Bezerra\n"
                "⏰ Resposta em até 5 dias úteis",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

// HELPERS PARA FORMATAÇÃO DOS DIALOGS
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, height: 1.5, color: Colors.grey[800]),
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
