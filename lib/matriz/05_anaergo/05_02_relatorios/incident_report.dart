import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../admob/banner_ad_widget.dart';
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
      locale: const Locale('pt', 'BR'), // Define o idioma para português
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
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Registro de Incidente'.toUpperCase(),
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: const EdgeInsets.all(30),
                alignment: AlignmentDirectional.topStart,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(labelText: 'Descrição'),
                        maxLines: null,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _locationController,
                        decoration:
                            const InputDecoration(labelText: 'Localização'),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
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
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
