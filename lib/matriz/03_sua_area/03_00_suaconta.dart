import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart'; // Para mudar senha

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
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;
  late Animation<Color?> _logoutColorAnimation;
  int _accessCount = 0;
  String? _lastAccess;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserData();
    final user = FirebaseAuth.instance.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _logoutColorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.redAccent,
    ).animate(_animationController);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _isVisible = true);
    });

    _updateAccessStats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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

  Future<void> _uploadProfilePhoto() async {
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
  }

  Future<void> _deleteProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');
    setState(() {
      _profileImage = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil removida!')),
      );
    }
  }

  Future<void> _updateProfile(String field) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      if (field == 'name') {
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload();
        setState(() {});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nome atualizado com sucesso!')),
          );
        }
      } else if (field == 'email') {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar $field: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SUA CONTA'),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Segoe',
        ),
      ),
      body: ListView(
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
            child: _buildLogoutButton(context, userProvider),
          ),
        ],
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
            color: Colors.black.withValues(alpha: 0.3),
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
              GestureDetector(
                onTap: _uploadProfilePhoto,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/images/default-avatar.png')
                          as ImageProvider,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit,
                        size: 20, color: Color.fromARGB(255, 0, 104, 55)),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _deleteProfilePhoto,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user?.displayName?.toUpperCase() ?? 'USUÁRIO',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _showEditDialog(context, 'name'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user?.email ?? 'Sem e-mail',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: 'Segoe',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _showEditDialog(context, 'email'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar ${field == 'name' ? 'Nome' : 'E-mail'}'),
        content: TextField(
          controller: field == 'name' ? _nameController : _emailController,
          decoration: InputDecoration(
              hintText: 'Novo ${field == 'name' ? 'nome' : 'e-mail'}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _updateProfile(field);
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
            creationDate != null ? _formatDate(creationDate) : 'Indisponível'),
        const SizedBox(height: 8),
        _buildInfoRow('ID do Usuário:', user?.uid ?? 'N/A'),
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
                fontFamily: 'Segoe'),
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
            'Plano:',
            userProvider.planType == 'monthly_full' ? 'FULL' : 'BÁSICO',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Válido até:',
            _formatDate(userProvider.expiryDate),
          ),
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
          const SizedBox(height: 12),
          ScaleTransition(
            scale: _buttonAnimation,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<NavBarPageState>(context, listen: false)
                    .setIndex(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(
                    color: Color.fromARGB(255, 0, 104, 55), width: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.credit_card,
                      color: Color.fromARGB(255, 0, 104, 55)),
                  SizedBox(width: 8),
                  Text(
                    'ASSINAR AGORA',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 104, 55),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Segoe',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
