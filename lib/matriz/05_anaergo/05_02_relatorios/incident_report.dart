import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({super.key});

  @override
  IncidentReportState createState() => IncidentReportState();
}

class IncidentReportState extends State<IncidentReport> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<File> _images = [];
  DateTime? _selectedDate;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (!mounted) return;
    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      }
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt'), // Define o idioma para português
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_images.isNotEmpty &&
        _controller.text.isNotEmpty &&
        _selectedDate != null &&
        _locationController.text.isNotEmpty) {
      final report = {
        'description': _controller.text,
        'location': _locationController.text,
        'date': DateFormat('dd/MM/yyyy').format(_selectedDate!),
        'timestamp': DateTime.now().toIso8601String(),
      };

      final reportProvider =
          Provider.of<ReportProvider>(context, listen: false);
      await reportProvider.saveReport(report, _images);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório enviado')),
      );

      if (!mounted) return;
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Relatório Salvo'),
          content: const Text(
              'Deseja criar um novo relatório ou voltar para a lista de relatórios?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _clearForm(); // Limpa o formulário
                _focusOnDescription(); // Foca no campo de descrição
              },
              child: const Text('Criar Novo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Volta para a tela de relatórios
              },
              child: const Text('Ver Relatórios'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _controller.clear();
    _locationController.clear();
    setState(() {
      _images.clear();
      _selectedDate = null;
    });
  }

  void _focusOnDescription() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
        FocusScope.of(context).requestFocus(
            FocusNode()); // Atualiza o foco para o campo de descrição
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatório de Incidente"),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: null, // Permite múltiplas linhas
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(_selectedDate == null
                  ? 'Selecionar Data'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
            ),
            const SizedBox(height: 20),
            _images.isEmpty
                ? const Text("Nenhuma imagem selecionada")
                : Column(
                    children: _images
                        .map((image) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Stack(
                                children: [
                                  Image.file(image),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _images.remove(image);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text("Capturar Imagem"),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text("Selecionar da Galeria"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text("Salvar Relatório"),
            ),
          ],
        ),
      ),
    );
  }
}
