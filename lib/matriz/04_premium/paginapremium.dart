import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
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
  final Color primaryColor = const Color(0xFF006837);

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: primaryColor),
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
        // Se estiver vazio, pode ser erro de configuração da loja
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

    const Widget homePage = NavStation();

    try {
      final purchase =
          await _subscriptionService.purchaseProduct(product, homePage);
      if (purchase == null) {
        // Cancelado pelo usuário ou pendente
      } else if (purchase.status == PurchaseStatus.purchased) {
        _showSnackBar('Compra realizada com sucesso!');
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor))),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!, textAlign: TextAlign.center),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PREMIUM',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header de Valor
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.workspace_premium,
                          size: 48, color: Colors.white),
                      const SizedBox(height: 12),
                      Text(
                        'Seja Premium',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Remova anúncios, desbloqueie conteúdo exclusivo e apoie o desenvolvimento.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  "Escolha seu Plano",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de Planos
                if (products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Nenhum plano disponível na loja no momento.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),

                // Lista de Planos (FILTRADA)
                if (products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Nenhum plano disponível na loja no momento.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),

                for (final product
                    in _getFilteredProducts(products, userProvider)) ...[
                  _buildPlanCard(
                    context: context,
                    title: product.title.replaceAll(RegExp(r'\(.*\)'), ''),
                    price: product.price,
                    description: product.description,
                    isPopular: product.id == 'monthly_full',
                    isActive: _isPlanActive(product.id),
                    onTap: () => _handlePurchase(context, product),
                  ),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 20),
                Text(
                  "Cancelamento: Gerenciado pela Google Play Store",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Filtra produtos para esconder plano "ad-free" se o usuário já for Premium
  List<ProductDetails> _getFilteredProducts(
    List<ProductDetails> allProducts,
    UserProvider userProvider,
  ) {
    // Se o usuário já é Premium (monthly_full), não mostra "monthly_ad_free"
    if (userProvider.planType == 'monthly_full' &&
        userProvider.hasActiveSubscription()) {
      return allProducts
          .where((product) => product.id != 'monthly_ad_free')
          .toList();
    }

    // Se o usuário já tem "ad-free" ativo, pode ver o upgrade para Premium
    // Caso contrário, mostra todos
    return allProducts;
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required String description,
    required bool isPopular,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isActive ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? primaryColor
                : (isPopular ? primaryColor : Colors.grey[200]!),
            width: isActive || isPopular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "ATIVO",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      if (!isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Assinar",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPopular && !isActive)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    "POPULAR",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
