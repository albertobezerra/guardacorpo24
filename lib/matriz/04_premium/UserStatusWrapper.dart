import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class UserStatusWrapper extends StatefulWidget {
  final Widget child;

  const UserStatusWrapper({super.key, required this.child});

  @override
  UserStatusWrapperState createState() => UserStatusWrapperState();
}

class UserStatusWrapperState extends State<UserStatusWrapper> {
  bool _isLoading = true;
  bool _isPremium = false;
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redireciona para login se não estiver logado
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      }
      return;
    }

    // Verifica a assinatura premium
    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);
    setState(() {
      _isLogged = true;
      _isPremium = subscriptionInfo['isPremium'] ?? false;
      _isLoading = false;
    });

    if (mounted && _isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Você é premium! Aproveite sem anúncios.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CustomLoadingIndicator());
    }

    if (!_isLogged) {
      return const AuthPage();
    }

    return widget.child;
  }
}
