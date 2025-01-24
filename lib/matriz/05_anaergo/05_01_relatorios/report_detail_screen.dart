import 'package:flutter/material.dart';
import 'dart:io';
import 'edit_report_screen.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final int index; // Adicione o índice do relatório

  const ReportDetailScreen(
      {super.key,
      required this.report,
      required this.index}); // Modifique o construtor

  @override
  Widget build(BuildContext context) {
    final imagePaths = List<String>.from(report['imagePaths']);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Relatório"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditReportScreen(
                    index: index,
                    initialData: report,
                    onSave: (updatedReport) {
                      // Ação para salvar o relatório atualizado
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Descrição: ${report['description']}",
                  style: const TextStyle(fontSize: 18)),
              Text("Localização: ${report['location']}",
                  style: const TextStyle(fontSize: 18)),
              Text("Data: ${report['date']}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ...imagePaths.map((path) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.file(File(path)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
