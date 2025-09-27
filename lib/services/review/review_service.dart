import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const String _reviewRequestedKey = 'last_review_request';
  static const String _appUsageCountKey = 'app_usage_count';
  static const String _hasAttemptedReviewKey = 'has_attempted_review';
  static const int minUsageCount = 5; // Mínimo de interações antes de pedir
  static const int minDaysSinceLastRequest = 30; // Intervalo entre pedidos

  // Verifica se é apropriado solicitar uma avaliação (para prompts automáticos)
  static Future<bool> shouldRequestReview() async {
    final prefs = await SharedPreferences.getInstance();
    final usageCount = prefs.getInt(_appUsageCountKey) ?? 0;
    final lastRequest = prefs.getInt(_reviewRequestedKey) ?? 0;

    // Incrementa a contagem de uso
    await prefs.setInt(_appUsageCountKey, usageCount + 1);

    // Verifica se já passou o intervalo mínimo e se o usuário usou o app o suficiente
    final now = DateTime.now().millisecondsSinceEpoch;
    final daysSinceLastRequest = (now - lastRequest) / (1000 * 60 * 60 * 24);
    return usageCount >= minUsageCount &&
        daysSinceLastRequest >= minDaysSinceLastRequest;
  }

  // Solicita a avaliação (para prompts automáticos)
  static Future<void> requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      // Salva a data da solicitação
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _reviewRequestedKey, DateTime.now().millisecondsSinceEpoch);
      await prefs.setBool(_hasAttemptedReviewKey, true);
    } else {
      // Fallback: abre a Google Play Store
      await inAppReview.openStoreListing();
    }
  }

  // Solicita a avaliação manualmente (para ações iniciadas pelo usuário)
  static Future<bool> requestManualReview() async {
    final inAppReview = InAppReview.instance;
    final prefs = await SharedPreferences.getInstance();
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      // Salva a data da solicitação e marca que o usuário tentou avaliar
      await prefs.setInt(
          _reviewRequestedKey, DateTime.now().millisecondsSinceEpoch);
      await prefs.setBool(_hasAttemptedReviewKey, true);
      return true;
    } else {
      // Fallback: abre a Google Play Store
      await inAppReview.openStoreListing();
      await prefs.setBool(_hasAttemptedReviewKey, true);
      return false;
    }
  }

  // Verifica se o usuário já tentou avaliar
  static Future<bool> hasAttemptedReview() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRequest = prefs.getInt(_reviewRequestedKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final daysSinceLastRequest = (now - lastRequest) / (1000 * 60 * 60 * 24);
    if (daysSinceLastRequest >= 365) {
      await prefs.setBool(_hasAttemptedReviewKey, false);
    }
    return prefs.getBool(_hasAttemptedReviewKey) ?? false;
  }

  // Incrementa a contagem de uso manualmente (se necessário)
  static Future<void> incrementUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final usageCount = prefs.getInt(_appUsageCountKey) ?? 0;
    await prefs.setInt(_appUsageCountKey, usageCount + 1);
  }
}
