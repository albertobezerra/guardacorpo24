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
  bool _hasEverSubscribedPremium = false;

  // 🔹 Recompensas
  int _rewardPoints = 0;
  DateTime? _rewardExpiryDate;

  // Contador de telas para intersticial
  int _screenCountSinceLastAd = 0;
  final int _adFrequency = 4;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isPremium => _isPremium;
  String get planType => _planType;
  DateTime? get expiryDate => _expiryDate;
  String? get errorMessage => _errorMessage;
  bool get hasEverSubscribedPremium => _hasEverSubscribedPremium;
  int get rewardPoints => _rewardPoints;
  DateTime? get rewardExpiryDate => _rewardExpiryDate;

  bool get hasRewardActive =>
      _rewardExpiryDate != null && _rewardExpiryDate!.isAfter(DateTime.now());

  UserProvider() {
    loadFromCache();
  }

  // 🔹 Cache
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

    await prefs.setInt('rewardPoints', _rewardPoints);
    if (_rewardExpiryDate != null) {
      await prefs.setInt(
          'rewardExpiryDate', _rewardExpiryDate!.millisecondsSinceEpoch);
    } else {
      await prefs.remove('rewardExpiryDate');
    }
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
    _rewardPoints = prefs.getInt('rewardPoints') ?? 0;
    final rewardExpiryMillis = prefs.getInt('rewardExpiryDate');
    _rewardExpiryDate = rewardExpiryMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(rewardExpiryMillis)
        : null;

    checkSubscriptionAndRewards(); // ✅ verifica expirações

    notifyListeners();
  }

  // 🔹 Atualização de assinatura
  void updateSubscription({
    required bool isLoggedIn,
    required bool isPremium,
    required String planType,
    DateTime? expiryDate,
    bool? hasEverSubscribedPremium,
  }) {
    _isLoggedIn = isLoggedIn;
    _isPremium = isPremium || planType == 'reward_full_access';
    _planType = planType;
    _expiryDate = expiryDate;
    _hasEverSubscribedPremium =
        hasEverSubscribedPremium ?? _hasEverSubscribedPremium;

    checkSubscriptionAndRewards(); // ✅ verifica expirações

    notifyListeners();
  }

  // 🔹 Atualização de recompensa
  void updateReward({int? points, DateTime? expiry}) {
    if (points != null) _rewardPoints = points;
    if (expiry != null) _rewardExpiryDate = expiry;

    checkSubscriptionAndRewards(); // ✅ verifica expirações

    saveToCache();
    notifyListeners();
  }

  // 🔹 Adicionar pontos
  Future<void> addRewardPointsAndSave(int amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _rewardPoints += amount;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'rewardPoints': _rewardPoints,
    });

    await saveToCache();
    notifyListeners();
  }

  // 🔹 Ativar recompensa por pontos (flexível para 7 ou 14 dias)
  Future<void> activateReward({
    required int cost,
    required String type, // "reward_full_access" ou "ad_free_reward"
    required int days,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (_rewardPoints < cost) return;

    final newExpiry = DateTime.now().add(Duration(days: days));

    _rewardPoints -= cost;

    final updateData = {
      'rewardPoints': _rewardPoints,
      'rewardExpiryDate': newExpiry,
      'subscriptionStatus': 'active',
    };

    // Atualiza Firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(updateData);

    // Atualiza estado local
    _rewardExpiryDate = newExpiry;

    if (type == 'reward_full_access') {
      // Premium total
      _isPremium = true;
      _planType = type;
      _expiryDate = newExpiry;
    } else if (type == 'ad_free_reward') {
      // Apenas remove anúncios
      // Não altera _isPremium nem _planType nem _expiryDate
    }

    checkSubscriptionAndRewards(); // ✅ verifica expirações

    await saveToCache();
    notifyListeners();
  }

  // 🔹 Status
  bool hasActiveSubscription() {
    return _planType.isNotEmpty &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        (_planType == 'monthly_full' ||
            _planType == 'monthly_ad_free' ||
            _planType == 'ad_free_reward' ||
            _planType == 'reward_full_access');
  }

  bool hasPremiumPlan() {
    return _isPremium && _planType == 'monthly_full';
  }

  bool canAccessPremiumScreen() {
    return hasActiveSubscription() &&
        (_planType == 'monthly_full' || _planType == 'reward_full_access');
  }

  bool isAdFree() {
    return hasActiveSubscription() || hasRewardActive;
  }

  void resetSubscription() {
    _isLoggedIn = false;
    _isPremium = false;
    _planType = '';
    _expiryDate = null;
    _errorMessage = null;
    _rewardExpiryDate = null;

    saveToCache();
    notifyListeners();
  }

  bool shouldShowInterstitial() {
    if (isAdFree()) return false;

    _screenCountSinceLastAd++;
    if (_screenCountSinceLastAd >= _adFrequency) {
      _screenCountSinceLastAd = 0;
      return true;
    }
    return false;
  }

  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // 🔹 Listener Firebase
  void startFirebaseListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        resetSubscription();
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data()!;
            final expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
            final planType = data['planType'] ?? '';
            final subscriptionStatus = data['subscriptionStatus'] ?? 'inactive';
            final isPremium = subscriptionStatus == 'active' &&
                expiryDate != null &&
                expiryDate.isAfter(DateTime.now());
            final hasEverSubscribedPremium =
                data['hasEverSubscribedPremium'] is bool
                    ? data['hasEverSubscribedPremium']
                    : false;
            final rewardPoints = data['rewardPoints'] ?? 0;
            final rewardExpiryDate =
                (data['rewardExpiryDate'] as Timestamp?)?.toDate();

            updateSubscription(
              isLoggedIn: true,
              isPremium: isPremium,
              planType: planType,
              expiryDate: expiryDate,
              hasEverSubscribedPremium: hasEverSubscribedPremium,
            );

            updateReward(points: rewardPoints, expiry: rewardExpiryDate);

            checkSubscriptionAndRewards(); // ✅ garante atualização
          }
        });
      }
    });
  }

  // 🔹 ✅ Verifica expiração de assinaturas e recompensas
  void checkSubscriptionAndRewards() {
    final now = DateTime.now();

    // Assinatura normal
    if (_expiryDate != null && _expiryDate!.isBefore(now)) {
      _isPremium = false;
      _planType = '';
      _expiryDate = null;
    }

    // Recompensa ativa
    if (_rewardExpiryDate != null && _rewardExpiryDate!.isBefore(now)) {
      _rewardExpiryDate = null;
      if (_planType == 'reward_full_access' || _planType == 'ad_free_reward') {
        _isPremium = false;
        _planType = '';
      }
    }
  }
}
