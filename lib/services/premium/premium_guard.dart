import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

class PremiumGuard extends StatelessWidget {
  final Widget child;

  const PremiumGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SubscriptionService().isUserPremium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.data ?? false) {
          return child;
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Acesso Restrito')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Conteúdo exclusivo para assinantes premium'),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/subscription'),
                    child: const Text('Assinar'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
