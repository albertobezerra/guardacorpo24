import 'package:flutter/material.dart';
import 'dart:io';
import '../../../components/db_local/local_storage_service.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({super.key});

  @override
  ViewReportsState createState() => ViewReportsState();
}

class ViewReportsState extends State<ViewReports> {
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<List<Map<String, dynamic>>> _getReports() async {
    return await _localStorageService.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios de Incidentes"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar relatórios'));
          }

          final List<Map<String, dynamic>> reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(child: Text('Nenhum relatório encontrado.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final imagePaths = List<String>.from(report['imagePaths']);

              return ListTile(
                title: Text(report['description'] ?? 'Nenhuma descrição'),
                subtitle: Text(report['date']),
                leading: imagePaths.isNotEmpty
                    ? Image.file(File(imagePaths[0]))
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
