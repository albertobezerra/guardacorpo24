import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /// Inicializa o serviço de compras
  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('In-app purchases NÃO estão disponíveis no dispositivo');
      return;
    }
    debugPrint('In-app purchases DISPONÍVEL!');
  }

  /// Compra um produto
  Future<void> purchaseProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Lida com a stream de compras
  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  /// Processa o resultado da compra
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        // Atualiza Firestore
        await _firestore.collection('users').doc(userId).update({
          'subscriptionStatus': 'active',
          'expiryDate': FieldValue.serverTimestamp(),
          'planType': purchase.productID,
        });

        // Atualiza SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isPremium', true);
        await prefs.setString('planType', purchase.productID);
      } catch (e) {
        debugPrint('Erro ao atualizar assinatura: $e');
      }
    } else if (purchase.status == PurchaseStatus.error) {
      debugPrint('Erro na compra: ${purchase.error?.message}');
    }
  }

  Future<bool> isUserPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate(); // Adicione '?'

    return subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now());
  }

  /// Verifica o status da assinatura
  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return {'isPremium': false, 'planType': ''};

    final data = snapshot.data() as Map<String, dynamic>;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate(); // Adicione '?'
    final planType = data['planType'];

    if (subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now())) {
      return {'isPremium': true, 'planType': planType};
    }

    return {'isPremium': false, 'planType': ''};
  }
}
