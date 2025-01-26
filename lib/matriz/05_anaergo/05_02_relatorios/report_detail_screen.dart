import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/edit_report_screen.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;
  final int index;

  const ReportDetailScreen(
      {super.key, required this.report, required this.index});

  @override
  ReportDetailScreenState createState() => ReportDetailScreenState();
}

class ReportDetailScreenState extends State<ReportDetailScreen> {
  late Map<String, dynamic> report;

  @override
  void initState() {
    super.initState();
    report = widget.report;
  }

  void _updateReport(Map<String, dynamic> updatedReport) {
    setState(() {
      report = updatedReport;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = List<String>.from(report['imagePaths']);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Detalhes do Relatório'.toUpperCase(),
            style: const TextStyle(
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
            Container(
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 104, 55),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final updatedReport = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReportScreen(
                        index: widget.index,
                        initialData: report,
                        onSave: (updatedReport) {
                          final reportProvider = Provider.of<ReportProvider>(
                              context,
                              listen: false);
                          reportProvider.updateReport(
                              widget.index, updatedReport);
                        },
                      ),
                    ),
                  );

                  if (updatedReport != null) {
                    _updateReport(updatedReport);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Descrição:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(report['description'] ?? 'Nenhuma descrição'),
                  const SizedBox(height: 16),
                  const Text(
                    'Localização:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(report['location'] ?? 'Nenhuma localização'),
                  const SizedBox(height: 16),
                  const Text(
                    'Data:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(report['date'] ?? 'Nenhuma data'),
                  const SizedBox(height: 16),
                  const Text(
                    'Imagens:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  imagePaths.isEmpty
                      ? const Text("Nenhuma imagem selecionada")
                      : Column(
                          children: imagePaths.map((path) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.file(File(path)),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
