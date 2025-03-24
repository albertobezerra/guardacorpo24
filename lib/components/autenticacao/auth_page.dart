import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_login.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/UserStatusWrapper.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading = false; // Estado para indicador de progresso

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
    FirebaseAuth.instance.setLanguageCode('pt-BR');
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Verifica se o usuário já está logado
  void checkLoggedInStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
        return;
      }

      final data = snapshot.data()! as Map<String, dynamic>;
      final isPremium = data['subscriptionStatus'] == 'active' &&
          data['expiryDate']?.toDate().isAfter(DateTime.now());
      final planType = data['planType'] ?? '';

      // Salva o status do usuário no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await saveSharedPreferences(
        isLoggedIn: true,
        isPremium: isPremium,
        planType: planType,
        hasShownSplash: true, // Define que o splash já foi mostrado
      );

      debugPrint('isLoggedIn: ${prefs.getBool('isLoggedIn') ?? false}');
      debugPrint('isPremium: ${prefs.getBool('isPremium') ?? false}');
      debugPrint('planType: ${prefs.getString('planType') ?? ''}');
      debugPrint('hasShownSplash: ${prefs.getBool('hasShownSplash') ?? false}');

      // Redireciona para NavBarPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserStatusWrapper(child: NavBarPage()),
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

  /// Função auxiliar para salvar dados no SharedPreferences
  Future<void> saveSharedPreferences({
    required bool isLoggedIn,
    required bool isPremium,
    required String planType,
    required bool hasShownSplash,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setBool('isPremium', isPremium);
    await prefs.setString('planType', planType);
    await prefs.setBool('hasShownSplash', hasShownSplash);
  }

  /// Obtém informações da assinatura do usuário
  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!snapshot.exists) return {'isPremium': false, 'planType': ''};

    final data = snapshot.data() as Map<String, dynamic>;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate();
    final planType = data['planType'];

    if (subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now())) {
      return {'isPremium': true, 'planType': planType};
    }
    return {'isPremium': false, 'planType': ''};
  }

  /// Validação de entrada dos campos
  bool _validateInputs() {
    if (_nameController.text.isEmpty && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome.')),
      );
      return false;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu email.')),
      );
      return false;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido.')),
      );
      return false;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira sua senha.')),
      );
      return false;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('A senha deve ter pelo menos 6 caracteres.')),
      );
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Salva detalhes do usuário no Firestore
  Future<void> saveUserDetails(String uid, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'subscriptionStatus': 'inactive', // Status inicial da assinatura
      'expiryDate': null, // Data de expiração inicial (nula)
      'planType': '', // Tipo de plano inicial (vazio)
    });
  }

  /// Autenticação (login ou cadastro)
  Future<void> _authenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!_validateInputs()) return;
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Lógica de login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await prefs.setBool('isLoggedIn', true);

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final subscriptionService = SubscriptionService();
          final subscriptionInfo =
              await subscriptionService.getUserSubscriptionInfo(user.uid);

          // Mostrar mensagens sobre o plano
          if (subscriptionInfo['isPremium'] && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Você agora é premium!')),
            );
          } else if (subscriptionInfo['planType'] == 'ad_free' && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Você agora está livre de publicidade!')),
            );
          }

          // Salvar status localmente
          await saveSharedPreferences(
            isLoggedIn: true,
            isPremium: subscriptionInfo['isPremium'],
            planType: subscriptionInfo['planType'] ?? '',
            hasShownSplash: true, // Define que o splash já foi mostrado
          );

          // Redirecionar para NavBarPage via UserStatusWrapper
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const UserStatusWrapper(child: NavBarPage()),
              ),
            );
          }
        }
      } else {
        // Lógica de cadastro
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await userCredential.user!
            .updateDisplayName(_nameController.text.trim());

        await saveUserDetails(
          userCredential.user!.uid,
          _nameController.text.trim(),
          _emailController.text.trim(),
        );

        // Novos usuários não são premium por padrão
        await saveSharedPreferences(
          isLoggedIn: true,
          isPremium: false,
          planType: '',
          hasShownSplash: true, // Define que o splash já foi mostrado
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const UserStatusWrapper(child: NavBarPage()),
            ),
          );
        }
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
        case 'invalid-email':
          errorMessage = 'Email inválido.';
          break;
        case 'weak-password':
          errorMessage = 'A senha é muito fraca.';
          break;
        default:
          errorMessage = 'Ocorreu um erro. Tente novamente.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSubmit() {
    _closeKeyboard();
    if (mounted) {
      _authenticate(); // Chama o método de autenticação
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
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
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
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
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
                                    color: Colors.white,
                                  )
                                : Text(
                                    _isLogin ? 'Entrar' : 'Registrar',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Esqueci a senha',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
