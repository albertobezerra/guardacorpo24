import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../components/db_local/local_storage_service.dart';

class IncidentReport extends StatefulWidget {
  const IncidentReport({super.key});

  @override
  IncidentReportState createState() => IncidentReportState();
}

class IncidentReportState extends State<IncidentReport> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageService();
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
      await _localStorageService.saveReport(report, _images);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório enviado')),
      );
      _controller.clear();
      _locationController.clear();
      setState(() {
        _images.clear();
        _selectedDate = null;
      });
    }
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
