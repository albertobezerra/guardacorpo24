import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class SuaConta extends StatefulWidget {
  const SuaConta({super.key});

  @override
  SuaContaState createState() => SuaContaState();
}

class SuaContaState extends State<SuaConta>
    with SingleTickerProviderStateMixin {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Color?> _logoutColorAnimation;
  int _accessCount = 0;
  String? _lastAccess;
  bool _isVisible = false;
  String _appVersion = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserData();
    _loadAppVersion();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _logoutColorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.redAccent,
    ).animate(_animationController);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });

    _updateAccessStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = info.version;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
        imageCache.clear();
        imageCache.clearLiveImages();
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessCount = prefs.getInt('access_count') ?? 0;
      _lastAccess = prefs.getString('last_access');
    });
  }

  Future<void> _updateAccessStats() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt('access_count', _accessCount + 1);
    await prefs.setString('last_access', _formatDate(now));
    _loadUserData();
  }

  Future<void> _handleProfilePhoto() async {
    if (_profileImage == null) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        try {
          final user = FirebaseAuth.instance.currentUser;
          final directory = await getApplicationDocumentsDirectory();
          final imagePath =
              '${directory.path}/profile_image_${user?.uid ?? 'default'}.jpg';
          final newImage = await File(pickedFile.path).copy(imagePath);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('profile_image_path', imagePath);

          imageCache.clear();
          imageCache.clearLiveImages();

          setState(() {
            _profileImage = newImage;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Foto de perfil atualizada com sucesso!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao atualizar a foto de perfil: $e')),
            );
          }
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_image_path');
      imageCache.clear();
      imageCache.clearLiveImages();

      setState(() {
        _profileImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil removida!')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (_nameController.text.trim().isNotEmpty &&
          _nameController.text.trim() != user.displayName) {
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload();
      }
      if (_emailController.text.trim().isNotEmpty &&
          _emailController.text.trim() != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Um e-mail de verificação foi enviado para o novo endereço. Por favor, verifique para completar a alteração.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
      setState(() {});
      if (mounted && _emailController.text.trim() == user.email) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar perfil: $e')),
        );
      }
    }
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Fale Conosco',
          style: TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 104, 55),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _reportController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Descreva seu erro, reclamação ou sugestão...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_reportController.text.trim().isNotEmpty) {
                _submitReportToGoogleSheet();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Por favor, insira uma mensagem!')),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReportToGoogleSheet() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? 'anonymous';
    final name = user?.displayName ?? 'Usuário';
    final date = DateTime.now().toIso8601String();
    final message = _reportController.text.trim();

    // URL do Google Form extraída do HTML
    const formUrl =
        'https://docs.google.com/forms/d/e/1FAIpQLSdwONcrd5l8HK99OUIcnvSA-IzI57ckCZ__W1H84lLAlODBsw/formResponse';
    final response = await http.post(
      Uri.parse(formUrl),
      body: {
        'entry.1761278916': uid, // UID
        'entry.856318573': name, // Nome
        'entry.606841070': date, // Data
        'entry.836890464': message, // Mensagem
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Obrigado pelo seu feedback!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar feedback')),
        );
      }
    }
    _reportController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // Removido o appBar
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildHeader(user, context),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildAccountInfo(userProvider, user),
            ),
            const Divider(height: 30),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildSubscriptionSection(context, userProvider),
            ),
            const Divider(height: 30),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildAboutSection(context),
            ),
            const Divider(height: 30),
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _buildLogoutButton(context, userProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User? user, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 0, 104, 55), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/images/default-avatar.png')
                        as ImageProvider,
              ),
              GestureDetector(
                onTap: _handleProfilePhoto,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _profileImage == null ? Icons.add_a_photo : Icons.delete,
                    size: 20,
                    color: _profileImage == null
                        ? const Color.fromARGB(255, 0, 104, 55)
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName?.toUpperCase() ?? 'USUÁRIO',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Segoe',
                  ),
                ),
                Text(
                  user?.email ?? 'Sem e-mail',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontFamily: 'Segoe',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditDialog(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 20,
                color: Color.fromARGB(255, 0, 104, 55),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Novo nome'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Novo e-mail'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _updateProfile();
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(UserProvider userProvider, User? user) {
    final creationDate = user?.metadata.creationTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INFORMAÇÕES DA CONTA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 104, 55),
            fontFamily: 'Segoe',
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Data de Criação:',
            creationDate != null ? _formatDate(creationDate) : 'N/A'),
        const SizedBox(height: 8),
        _buildInfoRow('Último Acesso:', _lastAccess ?? 'N/A'),
        const SizedBox(height: 8),
        _buildInfoRow('Acessos Totais:', _accessCount.toString()),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPasswordPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 104, 55),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
          ),
          child: const Text(
            'MUDAR SENHA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Segoe',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Segoe'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontFamily: 'Segoe'),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(
      BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ASSINATURA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 104, 55),
            fontFamily: 'Segoe',
          ),
        ),
        const SizedBox(height: 12),
        if (userProvider.hasActiveSubscription()) ...[
          _buildInfoRow(
              'Assinatura:', _getSubscriptionName(userProvider.planType)),
          const SizedBox(height: 8),
          _buildInfoRow('Válido até:', _formatDate(userProvider.expiryDate)),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Última Assinatura:',
            _formatDate(
                userProvider.expiryDate!.subtract(const Duration(days: 30))),
          ),
        ] else ...[
          const Text(
            'Nenhuma assinatura ativa',
            style: TextStyle(fontSize: 14, fontFamily: 'Segoe'),
          ),
        ],
      ],
    );
  }

  String _getSubscriptionName(String? planType) {
    switch (planType) {
      case 'monthly_full':
        return 'Premium';
      case 'monthly_ad_free':
        return 'Sem Publicidade';
      default:
        return 'Desconhecida ($planType)';
    }
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SOBRE O APP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 104, 55),
            fontFamily: 'Segoe',
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Aplicativo destinado aos profissionais da área de Saúde e Segurança do Trabalho. O app buscar deixar sempre a mão destes profissionais normas regulamentadoras, assim como CLT, DDS e outros que fazem parte do dia-a-dia deste profissional. #segurancadotrabalho #tst #ppra #riscos',
          style: TextStyle(fontSize: 14, fontFamily: 'Segoe'),
        ),
        const SizedBox(height: 8),
        _buildInfoRow('Versão:', _appVersion),
        const SizedBox(height: 8),
        _buildInfoRow('Data da Última Atualização:', '16/02/2025'),
        const SizedBox(height: 8),
        const Text(
          'Notas da Última Atualização:\n- Melhorias no módulo de incêndio \n- Melhorias no módulo de ordem de serviço\n- Implementação de notificações',
          style: TextStyle(fontSize: 14, fontFamily: 'Segoe'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => _showReportDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 104, 55),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
          ),
          child: const Text(
            'FALE CONOSCO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Segoe',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return AnimatedBuilder(
      animation: _logoutColorAnimation,
      builder: (context, child) {
        return ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('profile_image_path');
            setState(() {
              _profileImage = null;
            });
            if (context.mounted) {
              userProvider.logout(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
                (route) => false,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _logoutColorAnimation.value,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'SAIR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Segoe',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
