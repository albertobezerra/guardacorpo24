// lib/screens/profile/profile_screen.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/screens/settings/settings_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_store_screen.dart';
import '../../services/provider/userProvider.dart';
// Certifique-se que o NavigationState está acessível aqui, ou remova se usar outra navegação
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();

  // Controladores para edição (usaremos BottomSheet para editar)
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  final TextEditingController _editPasswordController = TextEditingController();

  bool _isSaving = false;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserData();
  }

  // --- LÓGICA EXISTENTE (Mantida) ---

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      if (!mounted) return;
      setState(() => _profileImage = File(imagePath));
    }
  }

  Future<void> _pickAndSetImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/profile_image_${_currentUser?.uid ?? 'default'}.jpg';

    // Remove imagem antiga se existir para não acumular lixo
    if (File(imagePath).existsSync()) {
      try {
        await File(imagePath).delete();
      } catch (_) {}
    }

    final newImage = await File(pickedFile.path).copy(imagePath);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', imagePath);

    await FileImage(newImage).evict();
    if (!mounted) return;
    setState(() => _profileImage = newImage);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto atualizada!')),
    );
  }

  Future<void> _deletePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');
    if (_profileImage != null) {
      await FileImage(_profileImage!).evict();
      try {
        await _profileImage!.delete();
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() => _profileImage = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto removida!')),
    );
  }

  Future<void> _loadUserData() async {
    final user = _currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists && mounted) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? user.displayName ?? '';
      // Atualiza controladores de edição também
      _editNameController.text = _nameController.text;
      _editEmailController.text = user.email ?? '';
    }
  }

  Future<void> _updateUserField(String field, String value) async {
    final user = _currentUser;
    if (user == null) return;

    // Fecha o modal de edição se estiver aberto
    Navigator.pop(context);

    setState(() => _isSaving = true);
    try {
      if (field == 'name') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': value});
        await user.updateDisplayName(value);
        setState(() => _nameController.text = value);
      } else if (field == 'email') {
        await user.verifyBeforeUpdateEmail(value);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email de verificação enviado!')),
        );
      } else if (field == 'password') {
        if (value.isEmpty) throw Exception('Senha não pode estar vazia');
        await user.updatePassword(value);
        _editPasswordController.clear();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${field.toUpperCase()} atualizado com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Provider.of<UserProvider>(context, listen: false).resetSubscription();
    Navigator.pushReplacementNamed(context, '/login');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // --- UI MODERNA ---

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = _currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isSaving
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER CURVO E AVATAR
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Curva Verde
                      ClipPath(
                        clipper: HeaderCurveClipper(),
                        child: Container(
                          height: 240,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.secondaryColor,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Botão Voltar
                      Positioned(
                        top: 50,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 24),
                          onPressed: () {
                            try {
                              Provider.of<NavigationState>(context,
                                      listen: false)
                                  .setIndex(0);
                            } catch (e) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),

                      // Título
                      Positioned(
                        top: 50,
                        child: Text(
                          "MEU PERFIL",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Foto de Perfil
                      Positioned(
                        bottom: -50,
                        child: GestureDetector(
                          onTap: _showPhotoOptions, // Opções de foto ao clicar
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: _profileImage != null
                                      ? FileImage(_profileImage!)
                                      : null,
                                  child: _profileImage == null
                                      ? Icon(Icons.person,
                                          size: 60, color: Colors.grey[400])
                                      : null,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      width: 3),
                                ),
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60), // Espaço para o avatar

                  // NOME E EMAIL
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : (user?.displayName ?? "Usuário"),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3436),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "email@exemplo.com",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),

                  const SizedBox(height: 25),

                  // STATUS / ASSINATURA CARD
                  if (userProvider.hasActiveSubscription() ||
                      userProvider.hasRewardActive)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Plano Ativo",
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userProvider.planDisplayName.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Válido até: ${_formatDate(userProvider.expiryDate ?? userProvider.rewardExpiryDate)}",
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.verified_user,
                                color: Colors.white, size: 28),
                          )
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),

                  // MENU DE OPÇÕES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildMenuOption(
                          context,
                          icon: Icons.person_outline,
                          title: "Editar Dados Pessoais",
                          onTap: () => _showEditBottomSheet(context, 'name'),
                        ),
                        _buildMenuOption(
                          context,
                          icon: Icons.lock_outline,
                          title: "Alterar Senha",
                          onTap: () =>
                              _showEditBottomSheet(context, 'password'),
                        ),
                        _buildMenuOption(
                          context,
                          icon: Icons.settings_outlined,
                          title: "Configurações",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()));
                          },
                        ),

                        // CARD DE PONTOS
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star,
                                  color: Colors.amber, size: 22),
                            ),
                            title: const Text("Pontos de Recompensa",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                "${userProvider.rewardPoints} pontos acumulados"),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RewardStoreScreen()),
                              ),
                              child: const Text("Trocar",
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),

                        _buildMenuOption(
                          context,
                          icon: Icons.logout,
                          title: "Sair da Conta",
                          isDestructive: true,
                          onTap: _logout,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  // Widget Auxiliar para Itens de Menu
  Widget _buildMenuOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: isDestructive ? Colors.red : AppTheme.primaryColor,
              size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : const Color(0xFF2D3436),
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      ),
    );
  }

  // Modal para Opções de Foto
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSetImage();
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _deletePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  // Modal para Edição de Campos
  void _showEditBottomSheet(BuildContext context, String fieldType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para o teclado não cobrir
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldType == 'name' ? "Editar Nome" : "Alterar Senha",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
              child: ElevatedButton(
                onPressed: () => _updateUserField(
                    fieldType,
                    fieldType == 'name'
                        ? _editNameController.text
                        : _editPasswordController.text),
                child: const Text("Salvar Alterações"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Clipper para a curva do Header (Mesmo do exemplo anterior)
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
