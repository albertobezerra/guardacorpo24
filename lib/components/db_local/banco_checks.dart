import 'dart:convert';
import 'dart:io';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/inspetor_checks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/check_model.dart';

class LocalStorageService {
  final Logger _logger = Logger();

  Future<String> getFilePath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$filename';
  }

  Future<String> getImageDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Métodos para Inspeções de Segurança
  Future<void> saveInspection(Inspection inspection) async {
    final filePath = await getFilePath('inspections.json');
    _logger.i('Salvando inspeção no caminho: $filePath');
    final imageDirectoryPath = await getImageDirectoryPath();

    final List<String> imagePaths = await Future.wait(
      inspection.checklist.expand((item) => item.photos).map((image) async {
        final imageName = '${DateTime.now().toIso8601String()}.jpg';
        final imagePath = '$imageDirectoryPath/$imageName';
        await File(imagePath).writeAsBytes(await image.readAsBytes());
        return imagePath;
      }).toList(),
    );

    final inspectionData = {
      'title': inspection.title,
      'date': inspection.date.toIso8601String(),
      'checklist': inspection.checklist
          .map((item) => {
                'description': item.description,
                'isComplete': item.isComplete,
                'note': item.note,
                'photos': imagePaths,
              })
          .toList(),
    };

    List<Map<String, dynamic>> inspections = [];

    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty) {
        inspections = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } else {
      _logger.i('Arquivo JSON não encontrado. Criando novo arquivo.');
    }

    inspections.add(inspectionData);

    final jsonString = jsonEncode(inspections);
    await File(filePath)
        .writeAsString(jsonString, mode: FileMode.write, flush: true);
    _logger.i(
        'Inspeção salva com sucesso. Novo conteúdo do arquivo JSON: $jsonString');
  }

  Future<void> updateInspection(int index, Inspection updatedInspection) async {
    final filePath = await getFilePath('inspections.json');
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> inspections =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        inspections[index] = {
          'title': updatedInspection.title,
          'date': updatedInspection.date.toIso8601String(),
          'checklist': updatedInspection.checklist
              .map((item) => {
                    'description': item.description,
                    'isComplete': item.isComplete,
                    'note': item.note,
                    'photos': item.photos.map((file) => file.path).toList(),
                  })
              .toList(),
        };
        await File(filePath).writeAsString(jsonEncode(inspections),
            mode: FileMode.write, flush: true);
        _logger.i('Inspeção atualizada com sucesso: $updatedInspection');
      }
    }
  }

  Future<void> deleteInspection(int index) async {
    final filePath = await getFilePath('inspections.json');
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> inspections =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        inspections.removeAt(index);
        if (inspections.isEmpty) {
          _logger.i('Nenhuma inspeção restante. Excluindo arquivo JSON.');
          await File(filePath).delete();
        } else {
          final jsonString = jsonEncode(inspections);
          await File(filePath)
              .writeAsString(jsonString, mode: FileMode.write, flush: true);
          _logger.i(
              'Inspeção deletada com sucesso no índice: $index. Novo conteúdo do arquivo JSON: $jsonString');
        }
      }
    }
  }

  Future<List<Inspection>> getInspections() async {
    final filePath = await getFilePath('inspections.json');
    _logger.i('Carregando inspeções do caminho: $filePath');
    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty && content != '[]') {
        final List<Map<String, dynamic>> inspectionsData =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        final inspections = inspectionsData.map((data) {
          return Inspection(
            title: data['title'],
            date: DateTime.parse(data['date']),
            checklist: (data['checklist'] as List<dynamic>).map((item) {
              return ChecklistItem(
                description: item['description'],
                isComplete: item['isComplete'],
                note: item['note'],
                photos: (item['photos'] as List<dynamic>)
                    .map((path) => File(path))
                    .toList(),
              );
            }).toList(),
          );
        }).toList();
        _logger.i('Inspeções carregadas com sucesso: $inspections');
        return inspections;
      }
    } else {
      _logger.i('Arquivo JSON não encontrado.');
    }
    _logger.i('Nenhuma inspeção encontrada.');
    return [];
  }
}
