import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import '../../services/provider/userProvider.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-app purchases NÃO estão disponíveis no dispositivo');
    }
  }

  void startPurchaseListener(BuildContext context, Widget homePage) {
    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      for (final purchase in purchaseDetailsList) {
        if (!context.mounted) return;
        _handlePurchase(purchase, context, homePage);
      }
    }, onError: (error) {
      debugPrint('Erro ao ouvir stream de compras: $error');
    });
  }

  Future<void> _handlePurchase(
      PurchaseDetails purchase, BuildContext context, Widget homePage) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime? transactionDate = purchase.transactionDate != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(purchase.transactionDate!))
            : DateTime.now();
        DateTime expiryDate = transactionDate.add(const Duration(days: 30));

        final currentHasEverSubscribed =
            await _getCurrentHasEverSubscribedPremium(user.uid);
        final hasEverSubscribedPremium =
            purchase.productID == 'monthly_full' || currentHasEverSubscribed;

        await _firestore.collection('users').doc(user.uid).set(
          {
            'planType': purchase.productID,
            'expiryDate': Timestamp.fromDate(expiryDate),
            'subscriptionStatus': 'active',
            'subscription': FieldValue.delete(),
            'hasEverSubscribedPremium': hasEverSubscribedPremium,
          },
          SetOptions(merge: true),
        );

        if (context.mounted) {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.updateSubscription(
            isLoggedIn: true,
            isPremium: purchase.productID == 'monthly_full',
            planType: purchase.productID,
            expiryDate: expiryDate,
            hasEverSubscribedPremium: hasEverSubscribedPremium,
          );
        }

        if (purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
        }

        if (context.mounted) {
          await _showSuccessAlert(context, purchase.productID);
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => homePage),
              (route) => false,
            );
          }
        }
      }
    } else if (purchase.status == PurchaseStatus.error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro ao processar compra: ${purchase.error?.message}')),
        );
      }
    }
  }

  Future<bool> _getCurrentHasEverSubscribedPremium(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return false;
    final data = snapshot.data();
    return data != null && data['hasEverSubscribedPremium'] is bool
        ? data['hasEverSubscribedPremium']
        : false;
  }

  Future<PurchaseDetails?> purchaseProduct(
      ProductDetails product, Widget homePage) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    debugPrint('Iniciando compra do produto: ${product.id}');
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    await for (final List<PurchaseDetails> purchaseDetailsList
        in _inAppPurchase.purchaseStream) {
      for (final PurchaseDetails purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            DateTime? transactionDate = purchase.transactionDate != null
                ? DateTime.fromMillisecondsSinceEpoch(
                    int.parse(purchase.transactionDate!))
                : DateTime.now();
            DateTime expiryDate = transactionDate.add(const Duration(days: 30));

            final currentHasEverSubscribed =
                await _getCurrentHasEverSubscribedPremium(user.uid);
            final hasEverSubscribedPremium =
                product.id == 'monthly_full' || currentHasEverSubscribed;

            debugPrint(
                'Compra confirmada - planType: ${product.id}, expiryDate: $expiryDate');
            await _firestore.collection('users').doc(user.uid).set(
              {
                'planType': product.id,
                'expiryDate': Timestamp.fromDate(expiryDate),
                'subscriptionStatus': 'active',
                'subscription': FieldValue.delete(),
                'hasEverSubscribedPremium': hasEverSubscribedPremium,
              },
              SetOptions(merge: true),
            );

            final context = navigatorKey.currentContext;
            if (context != null && context.mounted) {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.updateSubscription(
                isLoggedIn: true,
                isPremium: product.id == 'monthly_full',
                planType: product.id,
                expiryDate: expiryDate,
                hasEverSubscribedPremium: hasEverSubscribedPremium,
              );

              await _showSuccessAlert(context, product.id);

              // Redirecionamento adicionado aqui
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => homePage),
                  (route) => false,
                );
              }
            }

            if (purchase.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchase);
            }
          }
          return purchase;
        } else if (purchase.status == PurchaseStatus.error) {
          debugPrint('Erro na compra: ${purchase.error?.message}');
          throw Exception(
              'Erro ao processar compra: ${purchase.error?.message}');
        }
      }
    }
    return null;
  }

  Future<void> _showSuccessAlert(BuildContext context, String productId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Compra Concluída!'),
        content: Text(
          'Você adquiriu o plano "${productId == 'monthly_full' ? 'Premium' : 'Livre de Publicidade'}" com sucesso!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> isUserPremium(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    final expiryDate = data['expiryDate']?.toDate();
    return data['subscriptionStatus'] == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now());
  }

  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      if (!snapshot.exists) return {'isPremium': false, 'planType': ''};
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        'isPremium': data['subscriptionStatus'] == 'active' &&
            data['expiryDate']?.toDate().isAfter(DateTime.now()),
        'planType': data['planType'] ?? '',
        'expiryDate': data['expiryDate'],
      };
    } catch (e) {
      debugPrint('Erro ao carregar informações de assinatura: $e');
      return {'isPremium': false, 'planType': ''};
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
