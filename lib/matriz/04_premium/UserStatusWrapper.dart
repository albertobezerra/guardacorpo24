import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class UserStatusWrapper extends StatelessWidget {
  final Widget child;

  const UserStatusWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (!userProvider.isLoggedIn || !userProvider.hasActiveSubscription()) {
          return child; // Sem privilégios
        }
        return Stack(
          children: [
            child,
            // Lógica de anúncios ou conteúdo premium (suposta)
          ],
        );
      },
    );
  }
}
