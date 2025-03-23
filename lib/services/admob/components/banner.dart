import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/conf/banner_ad_widget.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class ConditionalBannerAdWidget extends StatefulWidget {
  const ConditionalBannerAdWidget({super.key});

  @override
  State<ConditionalBannerAdWidget> createState() =>
      _ConditionalBannerAdWidgetState();
}

class _ConditionalBannerAdWidgetState extends State<ConditionalBannerAdWidget> {
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();

    // Adiciona um listener para detectar mudanças no status do usuário
    FirebaseAuth.instance.authStateChanges().listen((_) {
      if (mounted) {
        _checkUserStatus();
      }
    });
  }

  Future<void> _checkUserStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isPremium = false; // Usuário não logado, não é premium
      });
      return;
    }

    final subscriptionInfo =
        await SubscriptionService().getUserSubscriptionInfo(user.uid);

    setState(() {
      _isPremium = subscriptionInfo['isPremium'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPremium) {
      // Usuário premium, não exibe o banner
      return const SizedBox.shrink();
    }

    // Exibe o banner para usuários gratuitos
    return const BannerAdWidget();
  }
}
