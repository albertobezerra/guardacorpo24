import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_service.dart';
import 'package:guarda_corpo_2024/components/autenticacao/reset_password.dart';
import 'package:guarda_corpo_2024/components/autenticacao/outlined_text_field.dart';

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

  @override
  void initState() {
    super.initState();
    checkLoggedInStatus(context);
    FirebaseAuth.instance.setLanguageCode('pt-BR');
  }

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
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
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.2),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedTextField(
                              controller: _nameController,
                              labelText: 'Nome',
                              onSubmitted: (value) => _closeKeyboard(),
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
                            onSubmitted: (value) => _closeKeyboard(),
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
                            onSubmitted: (value) => _closeKeyboard(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _closeKeyboard();
                              authenticate(
                                context,
                                _isLogin,
                                _emailController,
                                _passwordController,
                                _nameController,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
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
                      const SizedBox(
                        height: 10,
                      ),
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
