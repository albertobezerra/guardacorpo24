import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-app purchases NÃO estão disponíveis no dispositivo');
    }
  }

  void startPurchaseListener(BuildContext context, Widget child) {
    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      for (final purchase in purchaseDetailsList) {
        if (!context.mounted) return;
        handlePurchase(purchase, context, child);
      }
    }, onError: (error) {
      debugPrint('Erro ao ouvir stream de compras: $error');
    });
  }

  Future<void> handlePurchase(
      PurchaseDetails purchase, BuildContext context, Widget child) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(
          {
            'subscriptionStatus': 'active',
            'expiryDate': DateTime.now().add(const Duration(days: 30)),
            'planType': purchase.productID,
          },
          SetOptions(merge: true),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Compra concluída com sucesso!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => child),
          );
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

  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    final Stream<List<PurchaseDetails>> purchaseUpdatedStream =
        _inAppPurchase.purchaseStream;

    await for (final List<PurchaseDetails> purchaseDetailsList
        in purchaseUpdatedStream) {
      for (final PurchaseDetails purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).set(
              {
                'subscriptionStatus': 'active',
                'expiryDate': DateTime.now().add(const Duration(days: 30)),
                'planType': product.id,
              },
              SetOptions(merge: true),
            );
          }
          return;
        } else if (purchase.status == PurchaseStatus.error) {
          throw Exception(
              'Erro ao processar compra: ${purchase.error?.message}');
        }
      }
    }
  }

  Future<bool> isUserPremium(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final expiryDate = data['expiryDate']?.toDate();
    return expiryDate != null && expiryDate.isAfter(DateTime.now());
  }

  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
