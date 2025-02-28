import 'package:flutter/material.dart';
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

    if (response.error != null) {
      debugPrint('Erro ao carregar produtos: ${response.error?.message}');
    }

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Produtos não encontrados: ${response.notFoundIDs}');
    }

    setState(() {
      products = response.productDetails;
      isLoading = false;
    });
  }

  void _handlePurchase(BuildContext context, ProductDetails product) async {
    if (!await InAppPurchase.instance.isAvailable()) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compras não estão disponíveis.')),
      );
      return;
    }

    // Inicia a compra do produto selecionado
    _subscriptionService.purchaseProduct(product);

    if (!context.mounted) return;
    // Exibe uma mensagem informando que a compra está sendo processada
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processando sua compra...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Planos Premium')),
        body: const Center(child: Text('Nenhum plano disponível no momento.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos Premium'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha seu plano:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (final product in products)
              PlanCard(
                title: product.id == 'monthly_ad_free'
                    ? 'Plano Básico'
                    : 'Plano Full',
                description: product.id == 'monthly_ad_free'
                    ? 'Remova apenas a publicidade.'
                    : 'Desbloqueie todo o conteúdo premium e remova a publicidade.',
                price: product.price, // Corrigido aqui
                onPressed: () => _handlePurchase(context, product),
              ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String price; // Preço do produto
  final VoidCallback onPressed;

  const PlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Text(price, // Exibe o preço corretamente
              style: const TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}
