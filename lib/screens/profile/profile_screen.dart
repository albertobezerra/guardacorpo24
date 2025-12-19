import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // IMPORTANTE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/screens/settings/settings_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_store_screen.dart';
import '../../services/provider/userProvider.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Agora usamos a URL do provider ou do Firebase, não precisamos guardar File local persistente
  // Mas usamos File para preview imediato antes do upload terminar
  File? _localImagePreview;
  bool _isUploading = false;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Não precisamos mais carregar de SharedPreferences se usarmos a URL do UserProvider
  }

  // --- NOVA LÓGICA: UPLOAD PARA FIREBASE STORAGE ---

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: source, imageQuality: 70); // Qualidade 70 para economizar dados

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    // 1. Mostra preview imediato
    setState(() {
      _localImagePreview = imageFile;
      _isUploading = true;
    });

    try {
      final user = _currentUser;
      if (user == null) return;

      // 2. Referência no Storage
      // Pasta: profile_photos / uid.jpg
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      // 3. Upload
      await storageRef.putFile(imageFile);

      // 4. Obter URL
      final downloadUrl = await storageRef.getDownloadURL();

      // 5. Atualizar Auth e Firestore
      await user.updatePhotoURL(downloadUrl);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'photoUrl': downloadUrl});

      // 6. Atualizar Provider localmente
      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false)
          .setUserPhotoUrl(downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil atualizada!')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao enviar foto: $e'),
            backgroundColor: Colors.red),
      );
      // Reverter preview em caso de erro
      setState(() => _localImagePreview = null);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _deletePhoto() async {
    setState(() => _isUploading = true);
    try {
      final user = _currentUser;
      if (user == null) return;

      // Tenta deletar do Storage (pode falhar se não existir, então usamos try/catch)
      try {
        await FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${user.uid}.jpg')
            .delete();
      } catch (_) {}

      // Remove do Auth e Firestore
      await user.updatePhotoURL(null);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'photoUrl': FieldValue.delete()});

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setUserPhotoUrl(null);

      setState(() => _localImagePreview = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto removida!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
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

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = _currentUser;
    final bool isPremium = userProvider.hasActiveSubscription();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER COM FOTO
            _buildHeader(context, userProvider, user, isPremium),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // CARD VERDE (ASSINATURA)
                  if (userProvider.hasActiveSubscription() ||
                      userProvider.hasRewardActive)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
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
                              Text("Plano Ativo",
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(userProvider.planDisplayName.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(
                                  "Válido até: ${_formatDate(userProvider.expiryDate ?? userProvider.rewardExpiryDate)}",
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.verified_user,
                                color: Colors.white, size: 28),
                          )
                        ],
                      ),
                    ),

                  // CARD BRANCO (PONTOS)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            shape: BoxShape.circle),
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
                                builder: (_) => const RewardStoreScreen())),
                        child: const Text("Trocar",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // MENU DE OPÇÕES
                  _buildMenuOption(
                    context,
                    icon: Icons.settings_outlined,
                    title: "Configurações da Conta",
                    subtitle: "Editar perfil e senha",
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()))
                          .then((_) => setState(() {}));
                    },
                  ),

                  if (!isPremium)
                    _buildMenuOption(
                      context,
                      icon: Icons.star_border,
                      title: "Seja Premium",
                      subtitle: "Acesse todo o conteúdo",
                      iconColor: AppTheme.primaryColor,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PremiumPage())),
                    ),

                  _buildMenuOption(
                    context,
                    icon: Icons.help_outline,
                    title: "Suporte",
                    subtitle: "Ajuda e FAQ",
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),
                  _buildLogoutButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER COM FOTO ATUALIZADA ---
  Widget _buildHeader(
      BuildContext context, UserProvider provider, User? user, bool isPremium) {
    // Define qual imagem mostrar:
    // 1. Preview local (se acabou de tirar foto)
    // 2. URL do Provider (se veio do Firebase)
    // 3. Nulo (usa ícone padrão)
    ImageProvider? imageProvider;
    if (_localImagePreview != null) {
      imageProvider = FileImage(_localImagePreview!);
    } else if (provider.userPhotoUrl != null) {
      imageProvider = NetworkImage(provider.userPhotoUrl!);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF4CA078)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // AVATAR CLICÁVEL
              GestureDetector(
                onTap: _showPhotoOptions,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: imageProvider,
                    child: _isUploading
                        ? const CircularProgressIndicator(
                            color: AppTheme.primaryColor)
                        : (imageProvider == null
                            ? Icon(Icons.person,
                                size: 50, color: Colors.grey[300])
                            : null),
                  ),
                ),
              ),

              // ÍCONE DE CÂMERA (AGORA CLICÁVEL TAMBÉM)
              GestureDetector(
                onTap: _showPhotoOptions, // Abre o mesmo menu
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt,
                      color: AppTheme.primaryColor, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? provider.userName ?? "Usuário",
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          if (isPremium)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              child: const Text("PREMIUM",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10)),
            ),
        ],
      ),
    );
  }

  // --- MENU DE FOTOS COM CÂMERA ---
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // OPÇÃO 1: CÂMERA
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            // OPÇÃO 2: GALERIA
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            // OPÇÃO 3: REMOVER
            if (_localImagePreview != null ||
                Provider.of<UserProvider>(context, listen: false)
                        .userPhotoUrl !=
                    null)
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

  // ... (Resto dos widgets auxiliares _buildMenuOption, _buildLogoutButton permanecem iguais)

  Widget _buildMenuOption(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      Color? iconColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color:
                  (iconColor ?? AppTheme.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12)),
          child:
              Icon(icon, color: iconColor ?? AppTheme.primaryColor, size: 24),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text("Sair da Conta",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.red.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
