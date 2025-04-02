import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_appBar.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_planCard.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

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
        'Produtos encontrados: ${response.productDetails.map((p) => "${p.id}: ${p.price}")}');
    setState(() {
      products = response.productDetails;
      isLoading = false;
    });
  }

  Future<void> _handlePurchase(
      BuildContext context, ProductDetails product) async {
    if (!await InAppPurchase.instance.isAvailable()) {
      _showSnackBar('Compras não estão disponíveis.');
      return;
    }

    debugPrint('Iniciando compra para produto: ${product.id}');
    try {
      final purchase = await _subscriptionService.purchaseProduct(product);
      if (purchase == null || purchase.status != PurchaseStatus.purchased) {
        _showSnackBar('Compra não concluída.');
      }
    } catch (e) {
      _showSnackBar('Erro ao processar compra: $e');
    }
  }

  bool _isPlanActive(String productId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.planType == productId &&
        userProvider.hasActiveSubscription();
  }

  bool _isPlanEnabled(String productId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.planType == 'monthly_full' &&
        userProvider.hasActiveSubscription()) {
      return productId == 'monthly_full';
    }
    return !_isPlanActive(productId);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                'Não foi possível carregar os planos no momento.',
                textAlign: TextAlign.center,
              ),
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
        title: 'Planos de Assinatura',
        backgroundImageAsset: 'assets/images/compras.jpg',
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final product in products)
                  CustomPlanCard(
                    title: product.id == 'monthly_ad_free'
                        ? 'PLANO BÁSICO'
                        : 'PLANO FULL',
                    description: _isPlanActive(product.id)
                        ? null
                        : product.id == 'monthly_ad_free'
                            ? 'Remove a publicidade.'
                            : 'Desbloqueie todo o conteúdo exclusivo e remova a publicidade.',
                    price: _isPlanActive(product.id) ? null : product.price,
                    isEnabled: _isPlanEnabled(product.id),
                    infoText: _isPlanActive(product.id)
                        ? 'Assinatura ativa até ${_formatDate(userProvider.expiryDate)}'
                        : null,
                    onPressed:
                        _isPlanEnabled(product.id) && !_isPlanActive(product.id)
                            ? () => _handlePurchase(context, product)
                            : null,
                    backgroundColor: _isPlanActive(product.id)
                        ? const Color.fromARGB(255, 0, 104, 55)
                        : _isPlanEnabled(product.id)
                            ? Colors.white
                            : Colors.grey.shade300,
                    textColor: _isPlanActive(product.id)
                        ? Colors.white
                        : const Color.fromARGB(255, 0, 104, 55),
                    borderColor: _isPlanActive(product.id)
                        ? Colors.transparent
                        : const Color.fromARGB(255, 0, 104, 55),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
