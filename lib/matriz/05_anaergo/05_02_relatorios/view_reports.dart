import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/incident_report.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/edit_report_screen.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_detail_screen.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'package:provider/provider.dart';
import '../../../admob/banner_ad_widget.dart';

class ViewReports extends StatelessWidget {
  const ViewReports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Relatórios de Incidentes'.toUpperCase(),
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
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(30),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Esta seção permite que você visualize e gerencie seus relatórios de Análises Ergonômicas do Trabalho (AET). Os relatórios ajudam a identificar e avaliar problemas ergonômicos, promovendo a saúde e a segurança no local de trabalho.\n\n',
                          ),
                          TextSpan(
                            text: 'Funções dos Relatórios:\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                '• Visualizar Relatórios: Veja a descrição, data e local dos incidentes relatados.\n'
                                '• Editar Relatórios: Atualize as informações dos relatórios existentes.\n'
                                '• Excluir Relatórios: Remova relatórios desatualizados ou incorretos.\n\n',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Relatório'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IncidentReport(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Segoe Bold',
                        ),
                      ),
                    ),
                  ),
                  Consumer<ReportProvider>(
                    builder: (context, reportProvider, child) {
                      if (reportProvider.reports.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final reports = reportProvider.reports;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          final imagePaths =
                              List<String>.from(report['imagePaths']);

                          return ListTile(
                            title: Text(
                                report['description'] ?? 'Nenhuma descrição'),
                            subtitle: Text(
                                '${report['date']} - ${report['location']}'),
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
                                            reportProvider.updateReport(
                                                index, updatedReport),
                                      ),
                                    ),
                                  );
                                } else if (result == 'delete') {
                                  reportProvider.deleteReport(index);
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
                                      index:
                                          index), // Passe o índice do relatório
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const BannerAdWidget(), // Adicione o banner de anúncio aqui
        ],
      ),
    );
  }
}
