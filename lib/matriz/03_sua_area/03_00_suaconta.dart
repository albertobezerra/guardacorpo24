import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
import 'package:guarda_corpo_2024/services/premium/reward_store_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/provider/userProvider.dart';

class SuaConta extends StatefulWidget {
  const SuaConta({super.key});

  @override
  State<SuaConta> createState() => _SuaContaState();
}

class _SuaContaState extends State<SuaConta> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSaving = false;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserData();
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

  Future<void> _pickAndSetImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/profile_image_${_currentUser?.uid ?? 'default'}.jpg';
      final newImage = await File(pickedFile.path).copy(imagePath);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', imagePath);

      await FileImage(newImage).evict();

      setState(() => _profileImage = newImage);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Foto atualizada!')));
    }
  }

  Future<void> _deletePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');

    if (_profileImage != null) {
      await FileImage(_profileImage!).evict();
    }

    setState(() => _profileImage = null);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Foto removida!')));
  }

  void _openProfilePhotoViewer() {
    if (_profileImage == null) {
      // Sem foto: Abre galeria diretamente
      _pickAndSetImage();
    } else {
      // Com foto: Abre tela fullscreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePhotoViewer(
            imageFile: _profileImage!,
            onSwap: _pickAndSetImage,
            onDelete: _deletePhoto,
          ),
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    final user = _currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateUserField(String field, String value) async {
    final user = _currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      if (field == 'name') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': value});
        await user.updateDisplayName(value);
      } else if (field == 'email') {
        if (user.email != value) {
          await user.verifyBeforeUpdateEmail(value);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email de verificação enviado!')),
          );
        }
      } else if (field == 'password') {
        if (value.isEmpty) throw Exception('Senha não pode estar vazia');
        await user.updatePassword(value);
        _passwordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Provider.of<UserProvider>(context, listen: false).resetSubscription();
    Navigator.pushReplacementNamed(context, '/login');
  }

  String _formatDate(DateTime? date) {
    return date != null ? '${date.day}/${date.month}/${date.year}' : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = _currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SUA CONTA'.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Segoe Bold',
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Provider.of<NavigationState>(context, listen: false)
                .setIndex(0); // Volta para Home sem pop
          },
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with gradient
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 0, 104, 55), Colors.black],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:
                              _openProfilePhotoViewer, // Clique abre viewer ou galeria
                          child: Stack(
                            alignment: Alignment.center, // Centraliza conteúdo
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: _profileImage == null
                                    ? const Color.fromARGB(255, 0, 104, 55)
                                        .withOpacity(
                                            0.5) // Background vazio para sem foto
                                    : null,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: _profileImage == null
                                    ? const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size: 40,
                                      ) // Ícone centralizado sem foto
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName?.toUpperCase() ?? 'USUÁRIO',
                                style: const TextStyle(
                                    fontFamily: 'Segoe Bold',
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                              Text(
                                user?.email ?? '',
                                style: const TextStyle(
                                    fontFamily: 'Segoe',
                                    color: Colors.white70,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Editable fields
                  _buildEditableField('Nome', _nameController, Icons.person,
                      () => _updateUserField('name', _nameController.text)),
                  const SizedBox(height: 12),
                  _buildEditableField('Email', _emailController, Icons.email,
                      () => _updateUserField('email', _emailController.text)),
                  const SizedBox(height: 12),
                  _buildEditableField(
                      'Senha',
                      _passwordController,
                      Icons.lock,
                      () => _updateUserField(
                          'password', _passwordController.text),
                      obscure: true),
                  const SizedBox(height: 20),
                  // Subscription section
                  Text(
                    'ASSINATURA'.toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Segoe Bold',
                        color: Color.fromARGB(255, 0, 104, 55),
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  userProvider.hasActiveSubscription()
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'Plano:',
                                userProvider.planType == 'monthly_full'
                                    ? 'Premium'
                                    : 'Sem Anúncios'),
                            _buildInfoRow('Válido até:',
                                _formatDate(userProvider.expiryDate)),
                          ],
                        )
                      : const Text('Nenhuma assinatura ativa',
                          style: TextStyle(fontFamily: 'Segoe', fontSize: 14)),
                  const SizedBox(height: 20),
                  // Points
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.star,
                          color: Color.fromARGB(255, 0, 104, 55)),
                      title: const Text('Pontos de Recompensa',
                          style: TextStyle(fontFamily: 'Segoe Bold')),
                      subtitle: Text('${userProvider.rewardPoints} pontos',
                          style: const TextStyle(fontFamily: 'Segoe')),
                      trailing: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RewardStoreScreen())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 104, 55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Trocar',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Segoe Bold')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Logout
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Sair',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Segoe Bold')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      IconData icon, VoidCallback onSave,
      {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 0, 104, 55)),
        title: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label.toUpperCase(),
            border: InputBorder.none,
            labelStyle: const TextStyle(
                fontFamily: 'Segoe', color: Color.fromARGB(255, 0, 104, 55)),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.save, color: Color.fromARGB(255, 0, 104, 55)),
          onPressed: onSave,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(label,
            style:
                const TextStyle(fontFamily: 'Segoe Bold', color: Colors.black)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontFamily: 'Segoe')),
      ],
    );
  }
}

// Nova tela para visualização fullscreen da foto
class ProfilePhotoViewer extends StatelessWidget {
  final File imageFile;
  final VoidCallback onSwap;
  final VoidCallback onDelete;

  const ProfilePhotoViewer({
    super.key,
    required this.imageFile,
    required this.onSwap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Foto'),
        backgroundColor: const Color.fromARGB(255, 0, 104, 55),
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onSwap();
              },
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Trocar Foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 104, 55),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Apagar Foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
