import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_appBar.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_planCard.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/GenericMessagePage.dart';
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
      if (purchase != null && purchase.status == PurchaseStatus.purchased) {
        if (!context.mounted) return;
        if (product.id == 'monthly_ad_free') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GenericMessagePage(
                title: 'Compra Concluída',
                message: 'Você agora está livre de publicidade!',
              ),
            ),
          );
        } else if (product.id == 'monthly_full') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const GenericMessagePage(
                title: 'Compra Concluída',
                message: 'Você agora tem acesso ao conteúdo premium!',
              ),
            ),
          );
        }
        await _updateUserSubscription(product.id, purchase);
      } else {
        _showSnackBar('Compra não concluída.');
      }
    } catch (e) {
      _showSnackBar('Erro ao processar compra: $e');
    }
  }

  Future<void> _updateUserSubscription(
      String productId, PurchaseDetails purchase) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Usuário não autenticado.');
      return;
    }

    DateTime? transactionDate = purchase.transactionDate != null
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(purchase.transactionDate!))
        : DateTime.now();
    DateTime subscriptionExpiresAt =
        transactionDate.add(const Duration(days: 30));

    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateSubscription(
      isLoggedIn: true,
      isPremium: productId == 'monthly_full',
      planType: productId,
      expiryDate: subscriptionExpiresAt,
      hasEverSubscribedPremium: productId == 'monthly_full'
          ? true
          : userProvider.hasEverSubscribedPremium,
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'planType': productId,
          'expiryDate': Timestamp.fromDate(subscriptionExpiresAt),
          'subscriptionStatus': 'active',
          'subscription': FieldValue.delete(),
          'hasEverSubscribedPremium': productId == 'monthly_full'
              ? true
              : FieldValue.serverTimestamp(), // Mantém se já existia
        },
        SetOptions(merge: true),
      );
      _showSnackBar('Assinatura ativada com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao salvar assinatura: $e');
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
      // Se monthly_full está ativo, desativa todos os outros planos
      return false;
    }
    // Caso contrário, permite comprar qualquer plano não ativo
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final product in products)
                CustomPlanCard(
                  title: product.id == 'monthly_ad_free'
                      ? 'PLANO BÁSICO'
                      : 'PLANO FULL',
                  description: product.id == 'monthly_ad_free'
                      ? 'Remove a publicidade.'
                      : 'Desbloqueie todo o conteúdo exclusivo e remova a publicidade.',
                  price: product.price,
                  isEnabled: _isPlanEnabled(product.id),
                  infoText: _isPlanActive(product.id)
                      ? 'Assinatura ativa até ${_formatDate(userProvider.expiryDate)}'
                      : null,
                  onPressed: () => _handlePurchase(context, product),
                ),
            ],
          );
        },
      ),
    );
  }
}
