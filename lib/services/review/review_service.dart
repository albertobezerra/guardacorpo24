import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static const String _reviewRequestedKey = 'last_review_request';
  static const String _appUsageCountKey = 'app_usage_count';
  static const int minUsageCount = 5; // Mínimo de interações antes de pedir
  static const int minDaysSinceLastRequest = 30; // Intervalo entre pedidos

  // Verifica se é apropriado solicitar uma avaliação
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

  // Solicita a avaliação
  static Future<void> requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      // Salva a data da solicitação
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _reviewRequestedKey, DateTime.now().millisecondsSinceEpoch);
    } else {
      // Fallback: abre a loja (opcional, dependendo do caso)
      await inAppReview.openStoreListing(
          appStoreId: 'SEU_APP_STORE_ID'); // Para iOS
    }
  }

  // Incrementa a contagem de uso manualmente (se necessário)
  static Future<void> incrementUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final usageCount = prefs.getInt(_appUsageCountKey) ?? 0;
    await prefs.setInt(_appUsageCountKey, usageCount + 1);
  }
}
