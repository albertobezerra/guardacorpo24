import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_appBar.dart';
import 'package:guarda_corpo_2024/components/customizacao/custom_planCard.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/sucessPage.dart';
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
    final purchaseResult = await _subscriptionService.purchaseProduct(product);

    if (purchaseResult == true) {
      // Compra bem-sucedida
      if (!context.mounted) return; // Verifica se o widget ainda está montado
      if (product.id == 'monthly_ad_free') {
        _showSnackBar(
            'Compra realizada com sucesso! Você agora está livre de publicidade.');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SuccessPage(planType: 'ad_free')),
        );
      } else if (product.id == 'monthly_full') {
        _showSnackBar(
            'Compra realizada com sucesso! Você agora tem acesso ao conteúdo premium.');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SuccessPage(planType: 'premium')),
        );
      }
      _updateUserSubscription(product.id); // Atualiza o estado do usuário
    } else {
      // Falha na compra
      _showSnackBar('Falha ao processar sua compra.');
    }
  }

  Future<void> loadUserSubscription(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final subscriptionData = userDoc.data()?['subscription'];

      if (subscriptionData != null) {
        final type = subscriptionData['type'];
        final expiresAt = DateTime.parse(subscriptionData['expiresAt']);

        if (!context.mounted) return; // Verifica se o widget ainda está montado
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateSubscription(
          isLoggedIn: true,
          isPremium: type == 'premium',
          planType: type,
          expiryDate: expiresAt,
        );

        if (expiresAt.isBefore(DateTime.now())) {
          _showSnackBar('Sua assinatura expirou.');
          userProvider.resetSubscription(); // Reseta se a assinatura expirou
        }
      }
    } catch (e) {
      _showSnackBar('Erro ao carregar assinatura: $e');
    }
  }

  Future<void> _updateUserSubscription(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('Usuário não autenticado.');
      return;
    }

    final subscriptionType =
        productId == 'monthly_ad_free' ? 'no_ads' : 'premium';
    final subscriptionExpiresAt =
        DateTime.now().add(const Duration(days: 30)); // Exemplo: 30 dias

    if (!mounted) return; // Verifica se o widget ainda está montado
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateSubscription(
      isLoggedIn: true,
      isPremium: subscriptionType == 'premium',
      planType: subscriptionType,
      expiryDate: subscriptionExpiresAt,
    );

    // Salva no Firestore
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'subscription': {
            'type': subscriptionType,
            'expiresAt': subscriptionExpiresAt.toIso8601String(),
          },
        },
        SetOptions(merge: true),
      );

      _showSnackBar('Assinatura ativada com sucesso!');
    } catch (e) {
      _showSnackBar('Erro ao salvar assinatura: $e');
    }
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
                  : 'Desbloqueie todo o conteúdo exclusivo e remova a publicidade.',
              price: product.price,
              onPressed: () => _handlePurchase(context, product),
            ),
        ],
      ),
    );
  }
}
