import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_detail_screen.dart';
import 'dart:io';
import '../../../admob/banner_ad_widget.dart';
import '../../../components/db_local/local_storage_service.dart';
import 'edit_report_screen.dart';

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

  Future<void> _editReport(
      int index, Map<String, dynamic> updatedReport) async {
    await _localStorageService.updateReport(index, updatedReport);
    setState(() {}); // Recarrega a lista de relatórios
  }

  Future<void> _deleteReport(int index) async {
    await _localStorageService.deleteReport(index);
    setState(() {}); // Recarrega a lista de relatórios
  }

  Future<void> _confirmDeleteReport(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Você realmente deseja excluir este relatório?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _deleteReport(index);
                Navigator.of(context).pop();
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'Visualização de Relatórios',
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
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar relatórios'));
                }

                final List<Map<String, dynamic>> reports = snapshot.data ?? [];

                if (reports.isEmpty) {
                  return const Center(
                      child: Text('Nenhum relatório encontrado.'));
                }

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    final imagePaths = List<String>.from(report['imagePaths']);

                    return ListTile(
                      title: Text(report['description'] ?? 'Nenhuma descrição'),
                      subtitle:
                          Text('${report['date']} - ${report['location']}'),
                      leading: imagePaths.isNotEmpty
                          ? Image.file(File(imagePaths[0]))
                          : null,
                      trailing: PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditReportScreen(
                                  index: index,
                                  initialData: report,
                                  onSave: (updatedReport) =>
                                      _editReport(index, updatedReport),
                                ),
                              ),
                            );
                          } else if (result == 'delete') {
                            _confirmDeleteReport(index);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Excluir'),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailScreen(
                              report: report,
                              index: index,
                            ), // Passe o índice do relatório
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
