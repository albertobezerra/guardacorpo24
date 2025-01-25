import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class LocalStorageService {
  final Logger _logger = Logger();

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/incident_reports.json';
  }

  Future<String> getImageDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveReport(
      Map<String, dynamic> report, List<File> images) async {
    final filePath = await getFilePath();
    _logger.i('Salvando relatório no caminho: $filePath');
    final imageDirectoryPath = await getImageDirectoryPath();

    final List<String> imagePaths = await Future.wait(images.map((image) async {
      final imageName = '${DateTime.now().toIso8601String()}.jpg';
      final imagePath = '$imageDirectoryPath/$imageName';
      await File(imagePath).writeAsBytes(await image.readAsBytes());
      return imagePath;
    }).toList());

    final reportData = {
      'description': report['description'],
      'location': report['location'],
      'imagePaths': imagePaths,
      'date': report['date'],
      'timestamp': report['timestamp'],
    };

    List<Map<String, dynamic>> reports = [];

    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty) {
        reports = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } else {
      _logger.i('Arquivo JSON não encontrado. Criando novo arquivo.');
    }

    reports.insert(0, reportData);

    final jsonString = jsonEncode(reports);
    await File(filePath)
        .writeAsString(jsonString, mode: FileMode.write, flush: true);
    _logger.i(
        'Relatório salvo com sucesso. Novo conteúdo do arquivo JSON: $jsonString');
  }

  Future<void> updateReport(
      int index, Map<String, dynamic> updatedReport) async {
    final filePath = await getFilePath();
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> reports =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        reports[index] = updatedReport;
        await File(filePath).writeAsString(jsonEncode(reports),
            mode: FileMode.write, flush: true);
        _logger.i('Relatório atualizado com sucesso: $updatedReport');
      }
    }
  }

  Future<void> deleteReport(int index) async {
    final filePath = await getFilePath();
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> reports =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        reports.removeAt(index);
        await File(filePath).writeAsString(jsonEncode(reports),
            mode: FileMode.write, flush: true);
        _logger.i('Relatório deletado com sucesso no índice: $index');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final filePath = await getFilePath();
    _logger.i('Carregando relatórios do caminho: $filePath');
    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty) {
        final reports = List<Map<String, dynamic>>.from(jsonDecode(content));
        _logger.i('Relatórios carregados com sucesso: $reports');
        return reports;
      }
    } else {
      _logger.i('Arquivo JSON não encontrado.');
    }
    _logger.i('Nenhum relatório encontrado.');
    return [];
  }
}
