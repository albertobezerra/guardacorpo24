import 'package:flutter/foundation.dart';
import 'package:guarda_corpo_2024/components/db_local/banco_checks.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/inspetor_checks.dart';
import 'package:logger/logger.dart';

class InspectionProvider with ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();
  final Logger _logger = Logger();
  List<Inspection> _inspections = [];

  List<Inspection> get inspections => _inspections;

  Future<void> loadInspections() async {
    _logger.i('Iniciando carregamento de inspeções...');
    _inspections = await _localStorageService.getInspections();
    _logger.i('Inspeções carregadas: $_inspections');
    notifyListeners();
  }

  Future<void> saveInspection(Inspection inspection) async {
    _logger.i('Salvando inspeção: $inspection');
    await _localStorageService.saveInspection(inspection);
    await loadInspections(); // Recarrega as inspeções após salvar uma nova
  }

  Future<void> updateInspection(
      int? index, Inspection updatedInspection) async {
    _logger.i('Atualizando inspeção no índice $index: $updatedInspection');
    await _localStorageService.updateInspection(index!, updatedInspection);
    await loadInspections();
  }

  Future<void> deleteInspection(int index) async {
    _logger.i('Deletando inspeção no índice $index');
    await _localStorageService.deleteInspection(index);
    await loadInspections();
  }

  void addInspection(Inspection newInspection) {
    _inspections.add(newInspection);
    notifyListeners();
  }
}
