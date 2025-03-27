import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_appBar.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_planCard.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/GenericMessagePage.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  List<ProductDetails> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _subscriptionService.initialize();

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(
      {'monthly_ad_free', 'monthly_full'}.toSet(),
    );

    if (response.error != null || response.notFoundIDs.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      products = response.productDetails;
      isLoading = false;
    });
  }

  void _handlePurchase(BuildContext context, ProductDetails product) async {
    try {
      await _subscriptionService.purchaseProduct(product);
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenericMessagePage(
            title: 'Compra Concluída',
            message: product.id == 'monthly_ad_free'
                ? 'Você agora está livre de publicidade!'
                : 'Você agora tem acesso ao conteúdo premium!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar compra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (products.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Planos'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Nenhum plano disponível no momento.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Planos Premium',
        backgroundImageAsset: 'assets/images/compras.jpg',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final product in products)
            CustomPlanCard(
              title: product.id == 'monthly_ad_free'
                  ? 'Plano Básico'
                  : 'Plano Full',
              description: product.id == 'monthly_ad_free'
                  ? 'Remove a publicidade.'
                  : 'Desbloqueie todo o conteúdo exclusivo.',
              price: product.price,
              onPressed: () => _handlePurchase(context, product),
            ),
        ],
      ),
    );
  }
}
