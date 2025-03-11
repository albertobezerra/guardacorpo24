import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
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
    return FutureBuilder<bool>(
      future: SubscriptionService().isUserPremium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final isPremium = snapshot.data ?? false;

        return MaterialButton(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          onPressed: () {
            if (isPremium) {
              // Usuário premium navega diretamente para o destino
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destinationScreen),
              );
            } else {
              // Exibe alert dialog para não premium
              _showPremiumAlertDialog(context);
            }
          },
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

  void _showPremiumAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conteúdo Exclusivo'),
          content: const Text(
            'Este conteúdo é exclusivo para assinantes premium.\nDeseja adquirir o plano Premium agora?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Fecha o diálogo
                // Redireciona para a compra do plano "monthly_full"
                await _handlePurchase(context, 'monthly_full');
              },
              child: const Text('Comprar Plano'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao iniciar compra: $e')),
      );
    }
  }
}
