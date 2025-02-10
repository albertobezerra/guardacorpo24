import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/incidentForm.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_detail_screen.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({super.key});

  @override
  ViewReportsState createState() => ViewReportsState();
}

class ViewReportsState extends State {
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future _loadReports() async {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    await reportProvider
        .loadReports(); // Suponha que há um método loadReports()
  }

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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage(
                'assets/images/relatorios.jpg'), // Altere para o caminho da imagem desejada
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30.0, top: 30.0, right: 30.0),
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
                                'Esta seção permite que você visualize e gerencie seus relatórios de incidentes. Os relatórios ajudam a documentar e rastrear eventos importantes.\n\n',
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
                  Consumer<ReportProvider>(
                    builder: (context, reportProvider, child) {
                      if (reportProvider.reports.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Nenhum relatório encontrado.\nVamos criar seu primeiro relatório?',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return DefaultTextStyle(
                          style: const TextStyle(fontFamily: 'Segoe'),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'SEUS RELATÓRIOS',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Segoe Bold',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 104, 55),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reportProvider.reports.length,
                                  itemBuilder: (context, index) {
                                    final report =
                                        reportProvider.reports[index];
                                    final imagePaths =
                                        List.from(report['imagePaths'] ?? []);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        elevation: 0,
                                        color: const Color.fromARGB(
                                            0, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 104, 55),
                                            width: 2.0,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(16.0),
                                          title: Text(
                                            report['description'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 104, 55),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(report['date']))} - ${report['location']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 0, 104, 55),
                                                ),
                                              ),
                                              if (imagePaths.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Image.file(
                                                    File(imagePaths[0]),
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportDetailScreen(
                                                  report: report,
                                                  index: index,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Botão flutuante no final da tela
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncidentForm(
                        index: null,
                        initialData: null,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 0, 104, 55), // Cor verde
                  shape: const CircleBorder(), // Forma circular
                  padding: const EdgeInsets.all(16), // Espaçamento interno
                  minimumSize: const Size(56, 56), // Tamanho mínimo do botão
                ),
                child: const Icon(
                  Icons.add, // Ícone de adição
                  color: Colors.white, // Cor do ícone
                  size: 28, // Tamanho do ícone
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
