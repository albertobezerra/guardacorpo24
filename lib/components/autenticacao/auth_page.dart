import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/UserStatusWrapper.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Cor principal do tema
  final Color primaryColor = const Color(0xFF006837);

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
    FirebaseAuth.instance.setLanguageCode('pt-BR');
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // --- LÓGICA DE LOGIN ---
  Future<void> checkLoggedInStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final subscriptionService = SubscriptionService();
      final subscriptionInfo =
          await subscriptionService.getUserSubscriptionInfo(user.uid);

      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateSubscription(
          isLoggedIn: true,
          isPremium: subscriptionInfo['isPremium'] ?? false,
          planType: subscriptionInfo['planType'] ?? '',
          expiryDate: subscriptionInfo['expiryDate']?.toDate(),
        );
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserStatusWrapper(child: NavStation()),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao verificar status de login: $e');
    }
  }

  bool _validateInputs() {
    if (!_isLogin && _nameController.text.isEmpty) {
      _showSnackBar('Por favor, insira seu nome.');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showSnackBar('Por favor, insira seu email.');
      return false;
    }
    if (!_isValidEmail(_emailController.text.trim())) {
      _showSnackBar('Por favor, insira um email válido.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Por favor, insira sua senha.');
      return false;
    }
    if (_passwordController.text.length < 6) {
      _showSnackBar('A senha deve ter pelo menos 6 caracteres.');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> saveUserDetails(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'subscriptionStatus': 'inactive',
      'expiryDate': null,
      'planType': '',
    });
  }

  Future<void> _authenticate() async {
    if (!_validateInputs()) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await userCredential.user!
            .updateDisplayName(_nameController.text.trim());
        await saveUserDetails(userCredential.user!.uid,
            _nameController.text.trim(), _emailController.text.trim());
      }
      final user = FirebaseAuth.instance.currentUser!;
      final subscriptionInfo =
          await SubscriptionService().getUserSubscriptionInfo(user.uid);

      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateSubscription(
          isLoggedIn: true,
          isPremium: subscriptionInfo['isPremium'] ?? false,
          planType: subscriptionInfo['planType'] ?? '',
          expiryDate: subscriptionInfo['expiryDate']?.toDate(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const UserStatusWrapper(child: NavStation())),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email não cadastrado.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email já está em uso.';
          break;
        case 'weak-password':
          errorMessage = 'A senha é muito fraca.';
          break;
        default:
          errorMessage = 'Erro: ${e.message}';
      }
      if (mounted) {
        _showSnackBar(errorMessage, isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Erro desconhecido. Tente novamente.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          backgroundColor: isError ? Colors.red[700] : primaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _handleSubmit() {
    _closeKeyboard();
    if (mounted) {
      _authenticate();
    }
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: _closeKeyboard,
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // LOGO HORIZONTAL
                // Ajuste o nome do arquivo se necessário (ex: .png ou .jpg)
                Image.asset(
                  'assets/images/logo_horizontal.png',
                  height: 160, // Altura ajustada para logo horizontal
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 80),

                // TÍTULO DINÂMICO
                Text(
                  _isLogin ? 'Bem-vindo de volta!' : 'Criar Conta',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  _isLogin
                      ? 'Faça login para continuar sua jornada'
                      : 'Cadastre-se e comece a usar agora',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 40),

                // CAMPOS DE TEXTO
                if (!_isLogin)
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nome Completo',
                    icon: Icons.person_outline,
                    inputType: TextInputType.name,
                  ),

                if (!_isLogin) const SizedBox(height: 16),

                _buildTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  icon: Icons.email_outlined,
                  inputType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  onSubmitted: (_) => _handleSubmit(),
                ),

                // ESQUECI A SENHA
                if (_isLogin)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage()),
                        );
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // BOTÃO PRINCIPAL
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 4,
                      shadowColor: primaryColor.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isLogin ? 'ENTRAR' : 'CRIAR CONTA',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                  ),
                ),

                const Spacer(flex: 2),

                // ALTERNAR MODO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Não tem uma conta?' : 'Já possui conta?',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Registre-se' : 'Faça Login',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _obscurePassword,
        keyboardType: inputType,
        style: GoogleFonts.poppins(color: Colors.black87),
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: primaryColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
