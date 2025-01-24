import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../components/db_local/banco_local.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({super.key});

  @override
  IncidentReportState createState() => IncidentReportState();
}

class IncidentReportState extends State<IncidentReport> {
  final TextEditingController _controller = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageService();
  final List<File> _images = [];

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (!mounted) return; // Verificação do `BuildContext`
    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      }
    });
  }

  Future<void> _submitReport() async {
    if (_images.isNotEmpty && _controller.text.isNotEmpty) {
      final report = {
        'description': _controller.text,
        'date': DateTime.now().toIso8601String(),
      };
      await _localStorageService.saveReport(report, _images);

      if (!mounted) return; // Verificação do `BuildContext`
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório enviado')),
      );
      _controller.clear();
      setState(() {
        _images.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatório de Incidente"),
      ),
      resizeToAvoidBottomInset: true, // Esta linha vai ajudar o teclado a subir
      body: SingleChildScrollView(
        // Adiciona rolagem para prevenir overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            _images.isEmpty
                ? const Text("Nenhuma imagem selecionada")
                : Column(
                    children: _images
                        .map((image) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.file(image),
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
              child: const Text("Enviar Relatório"),
            ),
          ],
        ),
      ),
    );
  }
}
