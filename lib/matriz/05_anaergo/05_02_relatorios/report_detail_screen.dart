import 'package:flutter/material.dart';
import 'dart:io';
import '../../../admob/banner_ad_widget.dart';
import 'edit_report_screen.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;
  final int index;

  const ReportDetailScreen(
      {super.key, required this.report, required this.index});

  @override
  Widget build(BuildContext context) {
    final imagePaths = List<String>.from(report['imagePaths']);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'Detalhes do Relatório',
            style: TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/cid.jpg'),
            fit: BoxFit.cover,
          ),
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
                        Navigator.pop(context); // Feche a tela de edição
                        Navigator.pop(context,
                            updatedReport); // Feche a tela de detalhes e retorne o relatório atualizado
                      },
                    ),
                  ),
                ).then((updatedReport) {
                  if (updatedReport != null) {
                    // Atualize a exibição dos detalhes com os dados atualizados
                    report['description'] = updatedReport['description'];
                    report['location'] = updatedReport['location'];
                    report['date'] = updatedReport['date'];
                    report['imagePaths'] = updatedReport['imagePaths'];
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Descrição: ${report['description']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Localização: ${report['location']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Data: ${report['date']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ...imagePaths.map((path) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.file(File(path)),
                        )),
                  ],
                ),
              ),
            ),
          ),
          const BannerAdWidget(), // Adicione o widget do anúncio, se necessário
        ],
      ),
    );
  }
}
