import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class ConteudoPremium extends StatefulWidget {
  const ConteudoPremium({super.key});

  @override
  ConteudoPremiumState createState() => ConteudoPremiumState();
}

class ConteudoPremiumState extends State<ConteudoPremium> {
  @override
  void initState() {
    super.initState();
    checkPremiumAccess(); // Verifica acesso no initState
  }

  Future<void> checkPremiumAccess() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pop(context);
      return;
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);

    if (!subscriptionInfo['isPremium']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Acesso restrito a assinantes premium'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conteúdo Premium'.toUpperCase()),
        flexibleSpace: Image.asset(
          'assets/images/premium.jpg', // Imagem de fundo da tela
          fit: BoxFit.cover,
        ),
      ),
      body: const Center(
        child: Text('Conteúdo Exclusivo para Assinantes!'),
      ),
    );
  }
}
