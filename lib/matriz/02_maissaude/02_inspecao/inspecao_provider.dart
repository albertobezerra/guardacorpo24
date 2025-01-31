import 'package:flutter/foundation.dart';
import 'package:guarda_corpo_2024/components/db_local/inspecao_storage_service.dart';
import 'dados_inspecao.dart';

class InspecaoProvider with ChangeNotifier {
  final InspecaoStorageService _storageService = InspecaoStorageService();
  List<Inspecao> _inspecoes = [];

  List<Inspecao> get inspecoes => _inspecoes;

  Future<void> loadInspecoes() async {
    final data = await _storageService.getInspecoes();
    _inspecoes = data.map((map) => Inspecao.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> saveInspecao(Inspecao inspecao) async {
    await _storageService.saveInspecao(inspecao);
    await loadInspecoes();
  }

  Future<void> updateInspecao(int index, Inspecao updatedInspecao) async {
    await _storageService.updateInspecao(index, updatedInspecao.toMap());
    await loadInspecoes();
  }

  Future<void> deleteInspecao(int index) async {
    await _storageService.deleteInspecao(index);
    await loadInspecoes();
  }
}
