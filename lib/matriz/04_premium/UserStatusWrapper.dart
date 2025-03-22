import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class UserStatusWrapper extends StatelessWidget {
  final Widget child;

  const UserStatusWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Usuário não logado, redireciona para AuthPage
      return const AuthPage();
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: SubscriptionService().getUserSubscriptionInfo(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!['isPremium']) {
          // Usuário premium, exibe snackbar informando
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Você é premium! Aproveite sem anúncios.')),
            );
          });
        } else if (snapshot.data!['planType'] == 'ad_free') {
          // Usuário ad-free, exibe snackbar informando
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Você está livre de publicidade!')),
            );
          });
        }

        // Navega para a tela principal após verificar o status
        return child;
      },
    );
  }
}
