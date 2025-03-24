import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/UserStatusWrapper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /// Inicializa o listener de compras
  void startPurchaseListener(BuildContext context, Widget? child) {
    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      for (final purchase in purchaseDetailsList) {
        if (!context.mounted) return;
        handlePurchase(
            purchase, context, child); // Chama o método de tratamento
      }
    }, onError: (error) {
      debugPrint('Erro ao ouvir stream de compras: $error');
    });
  }

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
  Future<void> handlePurchase(
      PurchaseDetails purchase, BuildContext context, Widget? child) async {
    if (purchase.status == PurchaseStatus.purchased) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId == null) {
          debugPrint('Usuário não logado durante a compra.');
          return;
        }

        // Atualiza Firestore
        await _firestore.collection('users').doc(userId).set({
          'subscriptionStatus': 'active',
          'expiryDate': FieldValue.serverTimestamp(),
          'planType': purchase.productID,
        }, SetOptions(merge: true));

        debugPrint('Assinatura atualizada com sucesso para o usuário: $userId');

        // Notifica o usuário com SnackBar
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parabéns! Você agora é premium!')),
        );

        // Reconstrói o widget principal para refletir as mudanças
        if (context.mounted && child != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserStatusWrapper(
                child: child,
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Erro ao atualizar assinatura: $e');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar sua assinatura: $e')),
        );
      }
    } else if (purchase.status == PurchaseStatus.error) {
      debugPrint('Erro na compra: ${purchase.error?.message}');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao realizar a compra: ${purchase.error?.message}')),
      );
    } else if (purchase.status == PurchaseStatus.restored) {
      debugPrint('Compra restaurada para o usuário: ${purchase.productID}');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sua assinatura foi restaurada!')),
      );
    }
  }

  /// Verifica se o usuário é premium
  Future<bool> isUserPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('Usuário não logado.');
      return false;
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      debugPrint('Documento do usuário não encontrado no Firestore.');
      return false;
    }

    final data = doc.data()!;
    final subscriptionStatus = data['subscriptionStatus'];
    final expiryDate = data['expiryDate']?.toDate();

    debugPrint('subscriptionStatus: $subscriptionStatus');
    debugPrint('expiryDate: $expiryDate');
    debugPrint('Data atual: ${DateTime.now()}');

    return subscriptionStatus == 'active' &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now());
  }

  /// Verifica o status da assinatura
  Future<Map<String, dynamic>> getUserSubscriptionInfo(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return {'isPremium': false, 'planType': ''};

    final data = snapshot.data()!;
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
