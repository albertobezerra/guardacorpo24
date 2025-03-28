import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  // Estados iniciais
  bool _isLoggedIn = false;
  bool _isPremium = false;
  String _planType = '';
  DateTime? _expiryDate;
  String _error = ''; // Mensagem de erro

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isPremium => _isPremium;
  String get planType => _planType;
  DateTime? get expiryDate => _expiryDate;
  String get error => _error;

  bool get hasNoAds => _planType == 'ad_free' || _planType == 'premium';
  bool get hasPremiumAccess =>
      _isPremium && _expiryDate?.isAfter(DateTime.now()) == true;

  // Atualiza o estado do usuário
  void updateSubscription({
    required bool isLoggedIn,
    required bool isPremium,
    required String planType,
    DateTime? expiryDate,
  }) {
    _isLoggedIn = isLoggedIn;
    _isPremium = isPremium;
    _planType = planType;
    _expiryDate = expiryDate;
    notifyListeners();
  }

  void checkSubscriptionStatus() {
    if (_expiryDate != null && _expiryDate!.isBefore(DateTime.now())) {
      _isPremium = false;
      _planType = '';
      notifyListeners();
    }
  }

  // Reseta o estado do usuário
  void resetSubscription() {
    _isLoggedIn = false;
    _isPremium = false;
    _planType = '';
    _expiryDate = null;
    _error = '';
    notifyListeners();
  }

  // Trata erros
  void setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isPremium = prefs.getBool('isPremium') ?? false;
    _planType = prefs.getString('planType') ?? '';
    final expiryTimestamp = prefs.getInt('expiryDate');
    _expiryDate = expiryTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(expiryTimestamp)
        : null;
    notifyListeners();
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    resetSubscription();
    saveToCache();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  Future<void> loadUserData(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      _isLoggedIn = true;
      _isPremium = data['subscriptionStatus'] == 'active' &&
          data['expiryDate']?.toDate().isAfter(DateTime.now());
      _planType = data['planType'] ?? '';
      notifyListeners();
    }
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setBool('isPremium', _isPremium);
    await prefs.setString('planType', _planType);
    await prefs.setInt('expiryDate', _expiryDate?.millisecondsSinceEpoch ?? 0);
  }

  void startFirebaseListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        resetSubscription();
      } else {
        final subscriptionInfo =
            await SubscriptionService().getUserSubscriptionInfo(user.uid);
        updateSubscription(
          isLoggedIn: true,
          isPremium: subscriptionInfo['isPremium'] ?? false,
          planType: subscriptionInfo['planType'] ?? '',
          expiryDate: subscriptionInfo['expiryDate']?.toDate(),
        );
      }
      saveToCache(); // Salva alterações no cache
    });
  }

  bool hasActiveSubscription() {
    return _expiryDate != null && _expiryDate!.isAfter(DateTime.now());
  }

  bool hasAdFreePlan() {
    return _planType == 'ad_free' && hasActiveSubscription();
  }

  bool hasPremiumPlan() {
    return _planType == 'premium' && hasActiveSubscription();
  }
}
