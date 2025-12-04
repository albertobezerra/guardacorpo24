import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService {
  static const String _historyKey = 'reading_history';
  static const int _maxHistoryItems = 5;

  // Adicionar item ao histórico
  static Future<void> addToHistory({
    required String type, // 'nr' ou 'dds'
    required String title,
    required String path, // caminho do PDF ou ID do DDS
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    // Criar item de histórico como JSON
    final item = jsonEncode({
      'type': type,
      'title': title,
      'path': path,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Remove se já existe (para não duplicar)
    history.removeWhere((h) {
      final decoded = jsonDecode(h);
      return decoded['path'] == path;
    });

    // Adiciona no início
    history.insert(0, item);

    // Mantém só os últimos 5
    if (history.length > _maxHistoryItems) {
      history = history.sublist(0, _maxHistoryItems);
    }

    await prefs.setStringList(_historyKey, history);
  }

  // Buscar histórico
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    return history.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList();
  }

  // Limpar histórico
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
