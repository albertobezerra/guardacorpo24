import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class EditReportScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const EditReportScreen({
    super.key,
    required this.index,
    required this.initialData,
    required this.onSave,
  });

  @override
  EditReportScreenState createState() => EditReportScreenState();
}

class EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.initialData['description']);
    _locationController =
        TextEditingController(text: widget.initialData['location']);
    _selectedDate = DateTime.parse(widget.initialData['date']);
    _images = List<String>.from(widget.initialData['imagePaths'])
        .map((path) => File(path))
        .toList();
  }

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
      initialDate: _selectedDate ?? DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'Editar Relatório',
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
              icon: const Icon(Icons.save),
              onPressed: () {
                final updatedReport = {
                  'description': _descriptionController.text,
                  'location': _locationController.text,
                  'date': DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  'timestamp': widget.initialData['timestamp'],
                  'imagePaths': _images.map((file) => file.path).toList(),
                };
                widget.onSave(updatedReport);
                Navigator.pop(context);
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
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      maxLines: null, // Permite múltiplas linhas para o texto
                    ),
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
                  ],
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
