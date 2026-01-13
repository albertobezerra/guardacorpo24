import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/screens/faq/simple_faq_screen.dart';
import 'package:guarda_corpo_2024/screens/settings/settings_screen.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:guarda_corpo_2024/services/rewards/reward_store_screen.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/paginapremium.dart';
import '../../services/provider/userProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _localImagePreview;
  bool _isUploading = false;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  // UPLOAD FOTO PARA STORAGE (COM CROP E COMPRESSÃO)
  Future<void> _pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    // ✅ CROP DA IMAGEM
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Quadrado
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar Foto',
          toolbarColor: AppTheme.primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: AppTheme.primaryColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true, // Força aspecto quadrado
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Ajustar Foto',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (croppedFile == null) return; // Usuário cancelou

    final imageFile = File(croppedFile.path);

    setState(() {
      _localImagePreview = imageFile;
      _isUploading = true;
    });

    try {
      final user = _currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Comprime a imagem após o crop
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 70,
        minWidth: 512,
        minHeight: 512,
      );

      if (compressedBytes == null) {
        throw Exception('Erro ao comprimir imagem');
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      await storageRef.putData(
        compressedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await storageRef.getDownloadURL();

      await user.updatePhotoURL(downloadUrl);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'photoURL': downloadUrl}, SetOptions(merge: true));

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false)
          .setUserPhotoUrl(downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil atualizada!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Erro ao enviar foto: $e');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar foto: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
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

      // Tenta deletar do Storage (ignora se não existir)
      try {
        await FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${user.uid}.jpg')
            .delete();
      } catch (_) {
        // Arquivo pode não existir, ignora erro
      }

      // Remove do Firebase Auth
      await user.updatePhotoURL(null);

      // Remove do Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'photoURL': FieldValue.delete()});

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setUserPhotoUrl(null);

      setState(() => _localImagePreview = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto removida!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover foto: $e'),
          backgroundColor: Colors.red,
        ),
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
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = _currentUser;

    final hasPremium = userProvider.canAccessPremiumScreen();
    final hasAdFreeOnly = userProvider.isAdFree() && !hasPremium;

    String badgeText;
    if (hasPremium) {
      badgeText = 'Premium';
    } else if (hasAdFreeOnly) {
      badgeText = 'Sem anúncios';
    } else {
      badgeText = 'Gratuito';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, userProvider, user, badgeText),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // CARD VERDE (BENEFÍCIO ATIVO)
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
                              Text(
                                "Benefício ativo",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userProvider.planDisplayName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // ✅ DEPOIS:
                              Text(
                                "Válido até: ${_formatDate(userProvider.getActiveExpiryDate())}",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.verified_user,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
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
                      title: const Text(
                        "Pontos de Recompensa",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "${userProvider.rewardPoints} pontos acumulados",
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RewardStoreScreen(),
                          ),
                        ),
                        child: const Text(
                          "Trocar",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // MENU
                  _buildMenuOption(
                    context,
                    icon: Icons.settings_outlined,
                    title: "Configurações da Conta",
                    subtitle: "Editar perfil e senha",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),

                  if (!hasPremium)
                    _buildMenuOption(
                      context,
                      icon: Icons.star_border,
                      title: "Seja Premium",
                      subtitle: "Acesse todo o conteúdo",
                      iconColor: AppTheme.primaryColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PremiumPage(),
                        ),
                      ),
                    ),

                  _buildMenuOption(
                    context,
                    icon: Icons.help_outline,
                    title: "Suporte",
                    subtitle: "Ajuda e FAQ",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SimpleFAQScreen()),
                    ),
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

  // HEADER
  Widget _buildHeader(
    BuildContext context,
    UserProvider provider,
    User? user,
    String badgeText,
  ) {
    if (_localImagePreview != null) {
    } else if (provider.userPhotoUrl != null &&
        provider.userPhotoUrl!.isNotEmpty) {}

    final Color badgeColor;
    if (badgeText == 'Premium') {
      badgeColor = const Color(0xFFFFC107);
    } else if (badgeText == 'Sem anúncios') {
      badgeColor = const Color.fromARGB(255, 158, 255, 161);
    } else {
      badgeColor = Colors.white;
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
                    child: _isUploading
                        ? const CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          )
                        : _localImagePreview != null
                            ? ClipOval(
                                child: Image.file(
                                  _localImagePreview!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : provider.userPhotoUrl != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: provider.userPhotoUrl!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                        color: AppTheme.primaryColor,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey[300],
                                  ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showPhotoOptions,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? provider.userName ?? "Usuário",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.6)),
            ),
            child: Text(
              badgeText.toUpperCase(),
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            if (_localImagePreview != null ||
                (Provider.of<UserProvider>(context, listen: false)
                            .userPhotoUrl !=
                        null &&
                    Provider.of<UserProvider>(context, listen: false)
                        .userPhotoUrl!
                        .isNotEmpty))
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

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (iconColor ?? AppTheme.primaryColor).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text(
        "Sair da Conta",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.red.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
