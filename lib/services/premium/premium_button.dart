import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumButton extends StatelessWidget {
  final String buttonText;
  final String imagePath;
  final Widget destinationScreen; // Tela premium
  final double buttonHeight;

  const PremiumButton({
    super.key,
    required this.buttonText,
    required this.imagePath,
    required this.destinationScreen,
    this.buttonHeight = 250,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<bool>(
      future: user != null
          ? SubscriptionService().isUserPremium(user.uid)
          : Future.value(false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('Aguardando verificação do status premium...');
          return const CustomLoadingIndicator(); // Loading personalizado
        }

        final isPremium = snapshot.data ?? false;
        debugPrint('Status premium: $isPremium');

        return MaterialButton(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          onPressed: () => _handleButtonPress(context, isPremium),
          child: Stack(
            children: [
              // Imagem do botão (cinza para não premium)
              Container(
                width: MediaQuery.of(context).size.width,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: ExactAssetImage(imagePath),
                    colorFilter: !isPremium
                        ? const ColorFilter.mode(
                            Colors.grey, BlendMode.saturation)
                        : null,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Texto do botão (cinza para não premium)
              Positioned(
                left: 12,
                bottom: 8,
                child: Text(
                  buttonText.toUpperCase(),
                  style: TextStyle(
                    color: !isPremium ? Colors.grey : Colors.white,
                    fontFamily: 'Segoe Bold',
                    fontSize: 16,
                  ),
                ),
              ),

              // Ícone de coroa para não premium
              if (!isPremium)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/crown.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleButtonPress(BuildContext context, bool isPremium) {
    if (isPremium) {
      debugPrint('Usuário premium, navegando para tela premium...');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    } else {
      debugPrint('Usuário não premium, exibindo diálogo...');
      _showPremiumAlertDialog(context);
    }
  }

  void _showPremiumAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.all(0),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ],
              ),
              Center(
                child: Image.asset(
                  'assets/images/crown.png',
                  width: 64,
                  height: 64,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Conteúdo Exclusivo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            '\nEste conteúdo é exclusivo para assinantes premium.\n\nDeseja adquirir o plano "Premium" agora?\n',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _handlePurchase(context, 'monthly_full');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 104, 55),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SIM, quero ser premium!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handlePurchase(BuildContext context, String productId) async {
    try {
      final subscriptionService = SubscriptionService();
      final products =
          await InAppPurchase.instance.queryProductDetails({productId});

      if (products.notFoundIDs.isNotEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plano não disponível no momento.')),
        );
        return;
      }

      final product = products.productDetails.first;
      await subscriptionService.purchaseProduct(product);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra iniciada com sucesso!')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao iniciar compra: $e')),
      );
    }
  }
}
