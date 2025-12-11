// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Simulação de delay (substituir pela lógica real do Firebase Auth)
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    // Navegar para a Home/NavStation
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NavStation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // LOGO OU ÍCONE
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security, // Substituir pelo seu logo.png
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // TEXTOS DE BOAS-VINDAS
              Text(
                "Bem-vindo de volta!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Faça login para continuar sua jornada segura.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 40),

              // INPUTS
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.grey[50],
                  suffixIcon: const Icon(
                      Icons.visibility_off_outlined), // Adicionar toggle
                ),
              ),

              // ESQUECEU A SENHA
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Esqueceu a senha?",
                    style: TextStyle(
                        color: AppTheme.primaryColor.withValues(alpha: 0.8)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO DE LOGIN
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                    shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "ENTRAR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white, // Forçando texto branco
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // DIVISOR "OU"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("ou continue com",
                        style: TextStyle(color: Colors.grey[500])),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 20),

              // REDES SOCIAIS (Opcional)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(Icons.g_mobiledata, () {}), // Ícone do Google
                  const SizedBox(width: 20),
                  _socialButton(Icons.apple, () {}),
                ],
              ),

              const SizedBox(height: 40),

              // CADASTRO
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Não tem uma conta? ",
                      style: TextStyle(color: Colors.grey[600])),
                  GestureDetector(
                    onTap: () {
                      // Navegar para cadastro
                    },
                    child: const Text(
                      "Cadastre-se",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
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
    );
  }

  Widget _socialButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Icon(icon, size: 32, color: Colors.grey[800]),
      ),
    );
  }
}
