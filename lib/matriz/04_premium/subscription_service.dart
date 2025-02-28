import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Inicializa o serviço de compras dentro do aplicativo
  Future<void> initialize() async {
    if (!await InAppPurchase.instance.isAvailable()) {
      debugPrint('In-app purchases não estão disponíveis');
      return;
    }
  }

  /// Compra um produto
  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Stream de compras
  Stream<List<PurchaseDetails>> get purchaseStream =>
      InAppPurchase.instance.purchaseStream;

  /// Lida com o resultado da compra
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'subscriptionStatus': 'active',
        'expiryDate': DateTime.now().add(const Duration(days: 30)), // Exemplo
        'planType': purchase.productID,
      });
      debugPrint('Assinatura ativada com sucesso!');
    } else if (purchase.status == PurchaseStatus.error) {
      debugPrint('Erro na compra: ${purchase.error?.message}');
    }
  }

  /// Verifica o status da assinatura do usuário
  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    final DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return {'isPremium': false, 'planType': ''};

    final data = snapshot.data() as Map<String, dynamic>;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate();
    final planType = data['planType'];

    if (subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now())) {
      return {'isPremium': true, 'planType': planType};
    }

    return {'isPremium': false, 'planType': ''};
  }
}
