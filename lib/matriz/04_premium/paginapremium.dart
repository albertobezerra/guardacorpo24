import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav.dart';
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
  String? errorMessage;

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
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _subscriptionService.initialize();

      debugPrint('Carregando produtos...');
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(
        {'monthly_ad_free', 'monthly_full'}.toSet(),
      );

      if (response.error != null) {
        debugPrint('Erro ao carregar assinaturas: ${response.error?.message}');
        setState(() {
          errorMessage = 'Falha ao carregar planos: ${response.error?.message}';
          isLoading = false;
        });
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Assinaturas não encontradas: ${response.notFoundIDs}');
        setState(() {
          errorMessage = 'Nenhum plano disponível no momento.';
          isLoading = false;
        });
        return;
      }

      debugPrint(
          'Produtos encontrados: ${response.productDetails.map((p) => "${p.id}: ${p.price}").join(', ')}');
      setState(() {
        products = response.productDetails;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro inesperado ao carregar produtos: $e');
      setState(() {
        errorMessage = 'Erro ao carregar planos: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _handlePurchase(
      BuildContext context, ProductDetails product) async {
    if (!await InAppPurchase.instance.isAvailable()) {
      _showSnackBar('Compras não estão disponíveis.');
      return;
    }

    const Widget homePage = NavBarPage();

    debugPrint('Iniciando compra para produto: ${product.id}');
    try {
      final purchase =
          await _subscriptionService.purchaseProduct(product, homePage);
      if (purchase == null) {
        _showSnackBar('Compra cancelada ou não iniciada.');
      } else if (purchase.status == PurchaseStatus.purchased) {
        _showSnackBar('Compra realizada com sucesso!');
      } else if (purchase.status == PurchaseStatus.error) {
        _showSnackBar('Erro na compra: ${purchase.error?.message}');
      } else {
        _showSnackBar('Compra não concluída.');
      }
    } catch (e) {
      debugPrint('Erro ao processar compra: $e');
      _showSnackBar('Erro ao processar compra: $e');
    }
  }

  bool _isPlanActive(String productId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.planType == productId &&
        userProvider.hasActiveSubscription();
  }

  bool _isPlanEnabled(String productId) {
    // Um plano só é clicável se não estiver ativo
    return !_isPlanActive(productId);
  }

  bool _isAdFreeDisabled() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // "Livre de Publicidade" fica desativado visualmente se Premium está ativo
    return userProvider.planType == 'monthly_full' &&
        userProvider.hasActiveSubscription();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Planos',
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
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
            padding: const EdgeInsets.only(top: 12),
            child: ListView(
              children: [
                for (final product in products)
                  CustomPlanCard(
                    title: product.id == 'monthly_ad_free'
                        ? 'Livre de Publicidade'.toUpperCase()
                        : 'Premium'.toUpperCase(),
                    description: _isPlanActive(product.id)
                        ? null
                        : product.id == 'monthly_ad_free'
                            ? 'Remove a publicidade.'
                            : 'Desbloqueie todo o conteúdo exclusivo e remova a publicidade.',
                    price: _isPlanActive(product.id) ? null : product.price,
                    isEnabled: product.id == 'monthly_ad_free'
                        ? !_isAdFreeDisabled() && _isPlanEnabled(product.id)
                        : _isPlanEnabled(product.id),
                    infoText: _isPlanActive(product.id)
                        ? 'Assinatura ativa até ${_formatDate(userProvider.expiryDate)}'
                        : null,
                    onPressed: _isPlanEnabled(product.id)
                        ? () => _handlePurchase(context, product)
                        : null,
                    // Quando ativo: fundo verde e texto branco
                    // Quando "Livre de Publicidade" e Premium ativo: cinza
                    backgroundColor: _isPlanActive(product.id)
                        ? const Color.fromARGB(255, 0, 104, 55)
                        : product.id == 'monthly_ad_free' && _isAdFreeDisabled()
                            ? const Color.fromARGB(20, 158, 158, 158)
                            : Colors.transparent,
                    textColor: _isPlanActive(product.id)
                        ? Colors.white
                        : product.id == 'monthly_ad_free' && _isAdFreeDisabled()
                            ? Colors.grey
                            : const Color.fromARGB(255, 0, 104, 55),
                    borderColor: _isPlanActive(product.id)
                        ? const Color.fromARGB(255, 0, 104, 55)
                        : product.id == 'monthly_ad_free' && _isAdFreeDisabled()
                            ? Colors.grey
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
