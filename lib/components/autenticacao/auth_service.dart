import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz_mestra.dart';

Future<void> checkLoggedInStatus(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn && context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Raiz()),
    );
  }
}

Future<void> authenticate(
  BuildContext context,
  bool isLogin,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController nameController,
) async {
  if (emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      (!isLogin && nameController.text.isEmpty)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, preencha todos os campos.')),
    );
    return;
  }

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isLogin) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await prefs.setBool('isLoggedIn', true);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Raiz()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido! ')),
      );
    } else {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await userCredential.user!.updateDisplayName(nameController.text.trim());
      await prefs.setBool('isLoggedIn', true);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Raiz()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro bem-sucedido! ')),
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
      case 'invalid-email':
        errorMessage = 'Email inválido.';
        break;
      case 'weak-password':
        errorMessage = 'A senha é muito fraca.';
        break;
      default:
        errorMessage = 'Ocorreu um erro. Tente novamente.';
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
