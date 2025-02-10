import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/incidentForm.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ReportDetailScreen extends StatefulWidget {
  final Map<String, dynamic> report;
  final int index;

  const ReportDetailScreen({
    super.key,
    required this.report,
    required this.index,
  });

  @override
  ReportDetailScreenState createState() => ReportDetailScreenState();
}

class ReportDetailScreenState extends State<ReportDetailScreen> {
  late Map<String, dynamic> _report;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

  void _visualizarImagem(BuildContext context, String? imagePath) {
    if (imagePath == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FutureBuilder(
            future: Future.microtask(() => File(imagePath)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(child: Text('Erro ao carregar imagem'));
              } else {
                return Image.file(snapshot.data!);
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteReport(BuildContext context) async {
    // Exibe o diálogo de confirmação
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir Relatório'),
          content: const Text('Tem certeza que deseja excluir este relatório?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // Verifica se o widget ainda está montado
    if (!context.mounted || shouldDelete != true) return;

    try {
      // Armazena as referências antes do await
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      Navigator.of(context);

      // Realiza a exclusão do relatório
      final reportProvider =
          Provider.of<ReportProvider>(context, listen: false);
      await reportProvider.deleteReport(widget.index);

      // Mostra a mensagem de sucesso
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Relatório excluído com sucesso')),
        );
      }
    } catch (e) {
      // Trata erros de exclusão
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir o relatório: $e')),
        );
      }
    } finally {
      // Navega de volta à tela anterior
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color.fromARGB(255, 0, 104, 55);

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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: buttonColor),
                onPressed: () async {
                  final updatedReport = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IncidentForm(
                        index: widget.index,
                        initialData: _report,
                      ),
                    ),
                  );

                  if (updatedReport != null && mounted) {
                    setState(() {
                      _report = updatedReport;
                    });
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
                  Text(_report['description'] ?? 'Nenhuma descrição'),
                  const Divider(height: 32, thickness: 1, color: Colors.grey),
                  const Text(
                    'Localização:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_report['location'] ?? 'Nenhuma localização'),
                  const Divider(height: 32, thickness: 1, color: Colors.grey),
                  const Text(
                    'Data:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_report['date'] ?? 'Nenhuma data'),
                  const Divider(height: 32, thickness: 1, color: Colors.grey),
                  const Text(
                    'Imagens:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (_report['imagePaths'] == null ||
                      _report['imagePaths'].isEmpty)
                    const Text("Nenhuma imagem selecionada")
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _report['imagePaths'].length,
                        itemBuilder: (context, index) {
                          final imagePath = _report['imagePaths'][index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () =>
                                  _visualizarImagem(context, imagePath),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: buttonColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _deleteReport(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(48, 48),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
