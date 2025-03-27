import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';

class SuaConta extends StatelessWidget {
  const SuaConta({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status da Conta',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                  userProvider.isLoggedIn ? Icons.check_circle : Icons.cancel),
              title: Text(userProvider.isLoggedIn ? 'Logado' : 'Não Logado'),
            ),
            ListTile(
              leading: Icon(
                  userProvider.hasNoAds ? Icons.check_circle : Icons.cancel),
              title: Text(userProvider.hasNoAds
                  ? 'Sem Publicidade'
                  : 'Com Publicidade'),
            ),
            ListTile(
              leading: Icon(userProvider.hasPremiumAccess
                  ? Icons.check_circle
                  : Icons.cancel),
              title: Text(userProvider.hasPremiumAccess
                  ? 'Acesso Premium'
                  : 'Sem Acesso Premium'),
            ),
            if (userProvider.expiryDate != null)
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                    'Expira em: ${userProvider.expiryDate!.toString().split(' ')[0]}'),
              ),
          ],
        ),
      ),
    );
  }
}
