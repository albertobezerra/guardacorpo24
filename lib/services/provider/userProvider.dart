import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isPremium = false;
  String _planType = '';
  DateTime? _expiryDate;
  String? _errorMessage;
  bool _hasEverSubscribedPremium = false; // Rastreia se já assinou monthly_full

  bool get isLoggedIn => _isLoggedIn;
  bool get isPremium => _isPremium;
  String get planType => _planType;
  DateTime? get expiryDate => _expiryDate;
  String? get errorMessage => _errorMessage;
  bool get hasEverSubscribedPremium => _hasEverSubscribedPremium;

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setBool('isPremium', _isPremium);
    await prefs.setString('planType', _planType);
    if (_expiryDate != null) {
      await prefs.setInt('expiryDate', _expiryDate!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('expiryDate');
    }
    await prefs.setBool('hasEverSubscribedPremium', _hasEverSubscribedPremium);
  }

  void updateSubscription({
    required bool isLoggedIn,
    required bool isPremium,
    required String planType,
    DateTime? expiryDate,
    bool? hasEverSubscribedPremium,
  }) {
    _isLoggedIn = isLoggedIn;
    _isPremium = isPremium;
    _planType = planType;
    _expiryDate = expiryDate;
    if (hasEverSubscribedPremium != null) {
      _hasEverSubscribedPremium = hasEverSubscribedPremium;
    }
    _errorMessage = null;
    debugPrint(
        'Estado atualizado - isPremium: $_isPremium, planType: $_planType, hasEverSubscribedPremium: $_hasEverSubscribedPremium');
    notifyListeners();
  }

  void resetSubscription() {
    _isLoggedIn = false;
    _isPremium = false;
    _planType = '';
    _expiryDate = null;
    _errorMessage = null;
    // Não reseta _hasEverSubscribedPremium, pois é histórico
    notifyListeners();
  }

  bool canAccessPremiumScreen() {
    return hasActiveSubscription(); // Apenas assinatura ativa dá acesso ao conteúdo Premium
  }

  bool canAccessPremiumSubscriptionPage() {
    return true; // Todos podem acessar a tela de assinatura
  }

  bool hasActiveSubscription() {
    return _isPremium &&
        _planType.isNotEmpty &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now());
  }

  bool hasPremiumPlan() {
    return hasActiveSubscription() && _planType == 'monthly_full';
  }

  bool hasAdFreePlan() {
    return hasActiveSubscription() && _planType == 'monthly_ad_free';
  }

  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    resetSubscription();
    await saveToCache();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  void startFirebaseListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        resetSubscription();
        await saveToCache();
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) async {
          if (snapshot.exists) {
            final data = snapshot.data()!;
            final expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
            final planType = data['planType'] ?? '';
            final isPremium = planType == 'monthly_full' &&
                expiryDate != null &&
                expiryDate.isAfter(DateTime.now());
            final hasEverSubscribedPremium =
                data['hasEverSubscribedPremium'] ?? false;

            debugPrint(
                'Firestore - planType: $planType, expiryDate: $expiryDate, isPremium: $isPremium, hasEverSubscribedPremium: $hasEverSubscribedPremium');
            updateSubscription(
              isLoggedIn: true,
              isPremium: isPremium,
              planType: planType,
              expiryDate: expiryDate,
              hasEverSubscribedPremium: hasEverSubscribedPremium,
            );

            if (expiryDate != null && !expiryDate.isAfter(DateTime.now())) {
              debugPrint('Assinatura expirada, atualizando status');
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                'subscriptionStatus': 'inactive',
              });
            }

            await saveToCache(); // Garante que o cache seja atualizado
          }
        });
      }
    });
  }

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isPremium = prefs.getBool('isPremium') ?? false;
    _planType = prefs.getString('planType') ?? '';
    final expiryMillis = prefs.getInt('expiryDate');
    _expiryDate = expiryMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(expiryMillis)
        : null;
    _hasEverSubscribedPremium =
        prefs.getBool('hasEverSubscribedPremium') ?? false;
    notifyListeners();
  }
}
