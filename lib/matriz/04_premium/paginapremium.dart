import 'package:flutter/material.dart';
// MUDANÇA 1: Importar NavStation
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
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
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(
        {'monthly_ad_free', 'monthly_full'}.toSet(),
      );

      if (response.error != null) {
        setState(() {
          errorMessage = 'Falha ao carregar planos: ${response.error?.message}';
          isLoading = false;
        });
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        setState(() {
          errorMessage = 'Nenhum plano disponível no momento.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        products = response.productDetails;
        isLoading = false;
      });
    } catch (e) {
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

    // MUDANÇA 2: Usar NavStation
    const Widget homePage = NavStation();

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
      _showSnackBar('Erro ao processar compra: $e');
    }
  }

  bool _isPlanActive(String productId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.planType == productId &&
        userProvider.hasActiveSubscription();
  }

  bool _isPlanEnabled(String productId) {
    return !_isPlanActive(productId);
  }

  bool _isAdFreeDisabled() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    color: const Color.fromARGB(255, 0, 104, 55),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Eleve sua experiência! Com nossos planos, remova anúncios e acesse conteúdos exclusivos de forma ilimitada. Imagine o app mais fluido e completo, pronto para te ajudar no dia a dia. Escolha o que melhor se adapta a você e comece agora!',
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
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
