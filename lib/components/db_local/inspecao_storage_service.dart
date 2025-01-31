import 'dart:convert';
import 'dart:io';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/dados_inspecao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class InspecaoStorageService {
  final Logger _logger = Logger();

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/inspecoes.json'; // Caminho do arquivo JSON
  }

  Future<void> saveInspecao(Inspecao inspecao) async {
    final filePath = await getFilePath();
    _logger.i('Salvando inspeção no caminho: $filePath');

    final inspecaoData = inspecao.toMap();

    List<Map<String, dynamic>> inspecoes = [];

    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty) {
        inspecoes = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    } else {
      _logger.i('Arquivo JSON não encontrado. Criando novo arquivo.');
    }

    inspecoes.add(inspecaoData);

    final jsonString = jsonEncode(inspecoes);
    await File(filePath)
        .writeAsString(jsonString, mode: FileMode.write, flush: true);
    _logger.i(
        'Inspeção salva com sucesso. Novo conteúdo do arquivo JSON: $jsonString');
  }

  Future<void> updateInspecao(
      int index, Map<String, dynamic> updatedInspecao) async {
    final filePath = await getFilePath();
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> inspecoes =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        inspecoes[index] = updatedInspecao;
        await File(filePath).writeAsString(jsonEncode(inspecoes),
            mode: FileMode.write, flush: true);
        _logger.i('Inspeção atualizada com sucesso: $updatedInspecao');
      }
    }
  }

  Future<void> deleteInspecao(int index) async {
    final filePath = await getFilePath();
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        List<Map<String, dynamic>> inspecoes =
            List<Map<String, dynamic>>.from(jsonDecode(content));
        inspecoes.removeAt(index);
        if (inspecoes.isEmpty) {
          _logger.i('Nenhuma inspeção restante. Excluindo arquivo JSON.');
          await File(filePath).delete();
        } else {
          final jsonString = jsonEncode(inspecoes);
          await File(filePath)
              .writeAsString(jsonString, mode: FileMode.write, flush: true);
          _logger.i(
              'Inspeção deletada com sucesso no índice: $index. Novo conteúdo do arquivo JSON: $jsonString');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> getInspecoes() async {
    final filePath = await getFilePath();
    _logger.i('Carregando inspeções do caminho: $filePath');
    if (await File(filePath).exists()) {
      _logger.i('Arquivo JSON encontrado. Lendo conteúdo...');
      final content = await File(filePath).readAsString();
      _logger.i('Conteúdo do arquivo JSON: $content');
      if (content.isNotEmpty && content != '[]') {
        final inspecoes = List<Map<String, dynamic>>.from(jsonDecode(content));
        _logger.i('Inspeções carregadas com sucesso: $inspecoes');
        return inspecoes;
      }
    } else {
      _logger.i('Arquivo JSON não encontrado.');
    }
    _logger.i('Nenhuma inspeção encontrada.');
    return [];
  }
}
