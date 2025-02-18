import 'package:flutter/foundation.dart';
import 'package:guarda_corpo_2024/components/db_local/local_storage_service.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class ReportProvider with ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();
  final Logger _logger = Logger();
  List<Map<String, dynamic>> _reports = [];

  List<Map<String, dynamic>> get reports => _reports;

  Future<void> loadReports() async {
    _logger.i('Iniciando carregamento de relatórios...');
    _reports = await _localStorageService.getReports();
    _logger.i('Relatórios carregados: $_reports');
    notifyListeners();
  }

  Future<void> saveReport(
      Map<String, dynamic> report, List<File> images) async {
    _logger.i('Salvando relatório: $report');
    await _localStorageService.saveReport(report, images);
    await loadReports(); // Recarrega os relatórios após salvar um novo
  }

  Future<void> updateReport(
      int? index, Map<String, dynamic> updatedReport, List<File> images) async {
    _logger.i('Atualizando relatório no índice $index: $updatedReport');
    await _localStorageService.updateReport(index!, updatedReport);
    await loadReports();
  }

  Future<void> deleteReport(int index) async {
    _logger.i('Deletando relatório no índice $index');
    await _localStorageService.deleteReport(index);
    await loadReports();
  }
}
