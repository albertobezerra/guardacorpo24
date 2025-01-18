import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/incident_reports.json';
  }

  Future<String> getImageDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveReport(Map<String, String> report, List<File> images) async {
    final filePath = await getFilePath();
    final imageDirectoryPath = await getImageDirectoryPath();

    final List<String> imagePaths = await Future.wait(images.map((image) async {
      final imageName = '${DateTime.now().toIso8601String()}.jpg';
      final imagePath = '$imageDirectoryPath/$imageName';
      await File(imagePath).writeAsBytes(image.readAsBytesSync());
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
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        reports = List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    }

    reports.insert(0, reportData);

    await File(filePath)
        .writeAsString(jsonEncode(reports), mode: FileMode.write, flush: true);
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
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final filePath = await getFilePath();
    if (await File(filePath).exists()) {
      final content = await File(filePath).readAsString();
      if (content.isNotEmpty) {
        return List<Map<String, dynamic>>.from(jsonDecode(content));
      }
    }
    return [];
  }
}
