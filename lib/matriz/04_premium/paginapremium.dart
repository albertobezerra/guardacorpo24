import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_appBar.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_planCard.dart';
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

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _loadProducts() async {
    await _subscriptionService.initialize();

    debugPrint('Carregando produtos...');
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(
      {'monthly_ad_free', 'monthly_full'}.toSet(),
    );

    if (response.error != null) {
      debugPrint('Erro ao carregar assinaturas: ${response.error?.message}');
      _showSnackBar('Falha ao carregar planos: ${response.error?.message}');
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Assinaturas não encontradas: ${response.notFoundIDs}');
      _showSnackBar('Nenhum plano disponível no momento.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    debugPrint(
        'Produtos encontrados: ${response.productDetails.map((p) => p.id)}');
    setState(() {
      products = response.productDetails;
      isLoading = false;
    });
  }

  void _handlePurchase(BuildContext context, ProductDetails product) async {
    if (!await InAppPurchase.instance.isAvailable()) {
      _showSnackBar('Compras não estão disponíveis.');
      return;
    }

    debugPrint('Iniciando compra para produto: ${product.id}');
    _subscriptionService.purchaseProduct(product);

    _showSnackBar('Processando sua compra...');
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
        appBar: const CustomAppBar(
          title: 'Planos',
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Nenhum plano disponível no momento.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true; // Reinicia o loading
                  });
                  _loadProducts(); // Tenta carregar novamente
                },
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
        backgroundImageAsset: 'assets/images/menu.jpg',
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
                  : 'Desbloqueie todo o conteúdo exclusivo e remova a publicidade.',
              price: product.price,
              onPressed: () => _handlePurchase(context, product),
            ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
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
          Text(price,
              style: const TextStyle(fontSize: 16, color: Colors.green)),
        ],
      ),
    );
  }
}
