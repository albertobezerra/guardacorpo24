// lib/services/provider/userProvider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  // Dados do Usuário
  bool _isLoggedIn = false;
  String? _userName;
  String? _userPhotoUrl;

  // Dados de Assinatura / Benefício
  bool _isPremium = false;
  String _planType =
      ''; // monthly_full, monthly_ad_free, reward_full_access, ad_free_reward
  DateTime? _expiryDate;
  String? _errorMessage;
  bool _hasEverSubscribedPremium = false;

  // Dados de Recompensa
  int _rewardPoints = 0;
  DateTime? _rewardExpiryDate;

  // Controle de Ads
  int _screenCountSinceLastAd = 0;
  final int _adFrequency = 4;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userPhotoUrl => _userPhotoUrl;

  bool get isPremium => _isPremium;
  String get planType => _planType;
  DateTime? get expiryDate => _expiryDate;
  String? get errorMessage => _errorMessage;
  bool get hasEverSubscribedPremium => _hasEverSubscribedPremium;
  int get rewardPoints => _rewardPoints;
  DateTime? get rewardExpiryDate => _rewardExpiryDate;

  bool get hasRewardActive =>
      _rewardExpiryDate != null && _rewardExpiryDate!.isAfter(DateTime.now());

  bool get hasActivePremiumReward =>
      _planType == 'reward_full_access' && hasRewardActive;

  UserProvider() {
    loadFromCache();
  }

  // Nome amigável do benefício
  String get planDisplayName {
    switch (_planType) {
      case 'monthly_full':
        return 'Premium (mensal)';
      case 'monthly_ad_free':
        return 'Sem anúncios (mensal)';
      case 'reward_full_access':
        return 'Premium (via pontos)';
      case 'ad_free_reward':
        return 'Sem anúncios (via pontos)';
      default:
        return 'Nenhum benefício ativo';
    }
  }

  Future<void> saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setBool('isPremium', _isPremium);
    await prefs.setString('planType', _planType);

    if (_userName != null) await prefs.setString('userName', _userName!);
    if (_userPhotoUrl != null) {
      await prefs.setString('userPhotoUrl', _userPhotoUrl!);
    }

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

  void setUserPhotoUrl(String? url) {
    _userPhotoUrl = url;
    notifyListeners();
  }

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isPremium = prefs.getBool('isPremium') ?? false;
    _planType = prefs.getString('planType') ?? '';

    _userName = prefs.getString('userName');
    _userPhotoUrl = prefs.getString('userPhotoUrl');

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

    checkSubscriptionAndRewards();
    notifyListeners();
  }

  void updateUserData({String? name, String? photoUrl}) {
    if (name != null) _userName = name;
    if (photoUrl != null) _userPhotoUrl = photoUrl;
    notifyListeners();
  }

  void updateSubscription({
    required bool isLoggedIn,
    required bool isPremium,
    required String planType,
    DateTime? expiryDate,
    bool? hasEverSubscribedPremium,
  }) {
    _isLoggedIn = isLoggedIn;
    // premium completo: full mensal ou via pontos
    _isPremium = isPremium ||
        planType == 'reward_full_access' ||
        planType == 'monthly_full';
    _planType = planType;
    _expiryDate = expiryDate;
    _hasEverSubscribedPremium =
        hasEverSubscribedPremium ?? _hasEverSubscribedPremium;

    checkSubscriptionAndRewards();
    saveToCache();
    notifyListeners();
  }

  void updateReward({int? points, DateTime? expiry}) {
    if (points != null) _rewardPoints = points;
    if (expiry != null) _rewardExpiryDate = expiry;

    checkSubscriptionAndRewards();
    saveToCache();
    notifyListeners();
  }

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

  Future<void> activateReward({
    required int cost,
    required String type, // 'reward_full_access' ou 'ad_free_reward'
    required int days,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _rewardPoints < cost) return;

    final newExpiry = DateTime.now().add(Duration(days: days));
    _rewardPoints -= cost;

    final updateData = {
      'rewardPoints': _rewardPoints,
      'rewardExpiryDate': Timestamp.fromDate(newExpiry),
      'subscriptionStatus': 'active',
      'planType': type,
    };

    if (type == 'reward_full_access') {
      updateData['expiryDate'] = Timestamp.fromDate(newExpiry);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(updateData, SetOptions(merge: true));

    _rewardExpiryDate = newExpiry;
    _planType = type;

    if (type == 'reward_full_access') {
      _expiryDate = newExpiry;
      _isPremium = true; // premium via pontos
    } else {
      // ad_free_reward: apenas remove anúncios
      _isPremium = false;
    }

    saveToCache();
    notifyListeners();
  }

  bool hasActiveSubscription() {
    final now = DateTime.now();
    return (_planType == 'monthly_full' || _planType == 'monthly_ad_free') &&
        _expiryDate != null &&
        _expiryDate!.isAfter(now);
  }

  bool hasPremiumPlan() => _planType == 'monthly_full';

  bool canAccessPremiumScreen() =>
      _isPremium &&
      (_planType == 'monthly_full' || _planType == 'reward_full_access');

  bool isAdFree() => hasActiveSubscription() || hasRewardActive;

  void resetSubscription() {
    _isLoggedIn = false;
    _isPremium = false;
    _planType = '';
    _expiryDate = null;
    _rewardExpiryDate = null;
    _userName = null;
    _userPhotoUrl = null;
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

  void startFirebaseListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        resetSubscription();
      } else {
        _userName = user.displayName;
        _userPhotoUrl = user.photoURL;

        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data()!;

            if (data.containsKey('name')) {
              _userName = data['name'];
            }

            final expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
            final planType = data['planType'] ?? '';
            final subscriptionStatus = data['subscriptionStatus'] ?? 'inactive';

            final isPremium = subscriptionStatus == 'active' &&
                expiryDate != null &&
                expiryDate.isAfter(DateTime.now());

            final hasEverSubscribedPremium =
                data['hasEverSubscribedPremium'] == true;
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
          }
        });
      }
    });
  }

  void checkSubscriptionAndRewards() {
    final now = DateTime.now();

    // Expirou assinatura mensal
    if (_expiryDate != null && _expiryDate!.isBefore(now)) {
      if (_planType == 'monthly_full' || _planType == 'monthly_ad_free') {
        _planType = '';
        _expiryDate = null;
        _isPremium = false;
      }
    }

    // Expirou recompensa
    if (_rewardExpiryDate != null && _rewardExpiryDate!.isBefore(now)) {
      _rewardExpiryDate = null;
      if (_planType == 'reward_full_access' || _planType == 'ad_free_reward') {
        _planType = '';
        _isPremium = false;
      }
    }

    // Se recompensa premium ainda válida
    if (_planType == 'reward_full_access' &&
        _rewardExpiryDate != null &&
        _rewardExpiryDate!.isAfter(now)) {
      _isPremium = true;
    }

    // Premium completo: mensal full ou via pontos
    if (_planType == 'monthly_full') _isPremium = true;
  }
}
