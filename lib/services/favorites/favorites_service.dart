import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  // Adicionar aos favoritos
  static Future<void> addFavorite({
    required String type,
    required String title,
    required String path,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    final item = jsonEncode({
      'type': type,
      'title': title,
      'path': path,
    });

    // Evita duplicatas
    if (!favorites.any((fav) {
      final decoded = jsonDecode(fav);
      return decoded['path'] == path;
    })) {
      favorites.add(item);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Remover dos favoritos
  static Future<void> removeFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.removeWhere((fav) {
      final decoded = jsonDecode(fav);
      return decoded['path'] == path;
    });

    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Verificar se está favoritado
  static Future<bool> isFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.any((fav) {
      final decoded = jsonDecode(fav);
      return decoded['path'] == path;
    });
  }

  // Buscar todos os favoritos
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList();
  }

  // Limpar todos os favoritos
  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }

  // Contar favoritos
  static Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }

  // Buscar favoritos por tipo (nr ou dds)
  static Future<List<Map<String, dynamic>>> getFavoritesByType(
      String type) async {
    final allFavorites = await getFavorites();
    return allFavorites.where((fav) => fav['type'] == type).toList();
  }
}
