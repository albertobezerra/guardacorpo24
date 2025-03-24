import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // Estados iniciais
  bool _isLoggedIn = false; // Se o usuário está logado
  bool _isPremium = false; // Se o usuário tem uma assinatura premium
  String _planType = ''; // Tipo de plano ('ad_free', 'premium', '')
  DateTime? _expiryDate; // Data de expiração da assinatura

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isPremium => _isPremium;
  String get planType => _planType;
  DateTime? get expiryDate => _expiryDate;

  // Verifica se o usuário tem permissão para remover publicidade
  bool get hasNoAds => _planType == 'ad_free' || _planType == 'premium';

  // Verifica se o usuário tem acesso ao conteúdo premium
  bool get hasPremiumAccess =>
      _isPremium && _expiryDate?.isAfter(DateTime.now()) == true;

  // Atualiza o estado do usuário após login ou compra de assinatura
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

    notifyListeners(); // Notifica os listeners sobre a mudança de estado
  }

  // Reseta o estado do usuário (ex.: logout ou expiração de assinatura)
  void resetSubscription() {
    _isLoggedIn = false;
    _isPremium = false;
    _planType = '';
    _expiryDate = null;

    notifyListeners();
  }
}
