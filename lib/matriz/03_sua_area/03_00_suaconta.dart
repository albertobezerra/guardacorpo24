import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/utils/utils.dart';

class SuaConta extends StatelessWidget {
  const SuaConta({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua Conta'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Status de Login'),
            subtitle: Text(userProvider.isLoggedIn ? 'Logado' : 'Não Logado'),
          ),
          ListTile(
            title: const Text('Assinatura'),
            subtitle: userProvider.hasPremiumPlan()
                ? const Text('Premium Ativo')
                : userProvider.hasAdFreePlan()
                    ? const Text('Sem Publicidade Ativa')
                    : const Text('Nenhuma Assinatura Ativa'),
          ),
          ListTile(
            title: const Text('Validade da Assinatura'),
            subtitle: Text(
              userProvider.expiryDate != null
                  ? 'Válido até ${formatDate(userProvider.expiryDate)}'
                  : 'Nenhuma assinatura ativa',
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Sair'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.logout(context); // Chama o método de logout
            },
          ),
        ],
      ),
    );
  }
}
