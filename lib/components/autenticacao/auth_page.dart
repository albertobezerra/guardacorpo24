import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart';
// MUDANÇA 1: Importar NavStation
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_login.dart';
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

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
    FirebaseAuth.instance.setLanguageCode('pt-BR');
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

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
            // MUDANÇA 2: Usar NavStation
            builder: (context) => const UserStatusWrapper(child: NavStation()),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao verificar status de login: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      }
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
              // MUDANÇA 3: Usar NavStation
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
        default:
          errorMessage = 'Erro desconhecido. Por favor, tente novamente.';
      }
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .setError(errorMessage);
        _showSnackBar(errorMessage);
      }
    } catch (e) {
      debugPrint('Erro ao autenticar: $e');
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .setError('Erro desconhecido. Por favor, tente novamente.');
        _showSnackBar('Erro desconhecido. Por favor, tente novamente.');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _handleSubmit() {
    _closeKeyboard();
    if (mounted) {
      _authenticate();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double logoHeight = screenHeight * 0.14;
    double titleFontSize = screenHeight * 0.04;
    double subtitleFontSize = screenHeight * 0.02;
    FontWeight subtitleFontWeight =
        screenHeight < 800 ? FontWeight.normal : FontWeight.bold;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: _closeKeyboard,
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/index.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(230),
                      Colors.black.withAlpha(180),
                      Colors.black.withAlpha(50),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Image(
                        height: logoHeight,
                        width: screenWidth,
                        image: const AssetImage('assets/images/logo.png'),
                      ),
                      Text(
                        'Guarda Corpo',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe Black',
                          fontSize: titleFontSize,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Um app sobre saúde e segurança do trabalho',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Segoe Light',
                            fontWeight: subtitleFontWeight,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (!_isLogin)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedTextField(
                              controller: _nameController,
                              labelText: 'Nome',
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              onSubmitted: (value) => _handleSubmit(),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            onSubmitted: (value) => _handleSubmit(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedTextField(
                            controller: _passwordController,
                            labelText: 'Password',
                            obscureText: true,
                            onSubmitted: (value) => _handleSubmit(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    _isLogin ? 'Entrar' : 'Registrar',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Não tem uma conta? Registre-se aqui'
                              : 'Já tem uma conta? Faça login aqui',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ResetPasswordPage()),
                          );
                        },
                        child: const Text(
                          'Esqueci a senha',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
