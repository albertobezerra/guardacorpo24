import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_aet.dart';

class EditReportScreen extends StatefulWidget {
  final int? index;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onSave;

  const EditReportScreen({
    super.key,
    this.index,
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
        TextEditingController(text: widget.initialData['description'] ?? '');
    _locationController =
        TextEditingController(text: widget.initialData['location'] ?? '');
    _selectedDate = widget.initialData['date'] != null
        ? DateFormat('dd/MM/yyyy').parse(widget.initialData['date'])
        : null;
    _images = (widget.initialData['imagePaths'] as List<dynamic>? ?? [])
        .map((path) => File(path as String))
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

  Future<void> _confirmDeleteImage(File image) async {
    final bool shouldDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Excluir Imagem'),
              content: const Text(
                  'Você tem certeza que deseja excluir esta imagem?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _images.remove(image);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _locationController.text.isNotEmpty) {
      final bool shouldSave = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Salvar Alterações'),
                content: const Text(
                    'Você tem certeza que deseja salvar as alterações?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              );
            },
          ) ??
          false;

      if (shouldSave) {
        final updatedReport = {
          'description': _descriptionController.text,
          'location': _locationController.text,
          'date': DateFormat('dd/MM/yyyy').format(_selectedDate!),
          'imagePaths': _images.map((image) => image.path).toList(),
        };

        widget.onSave(updatedReport);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relatório atualizado')),
        );

        if (!mounted) return;
        Navigator.of(context).pop(
            updatedReport); // Volta para a tela anterior com o relatório atualizado
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
            'Editar Relatório'.toUpperCase(),
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
                  OutlinedTextField2(
                    controller: _descriptionController,
                    labelText: 'Descrição',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedTextField2(
                    controller: _locationController,
                    labelText: 'Localização',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text(_selectedDate == null
                        ? 'Selecionar Data'.toUpperCase()
                        : DateFormat('dd/MM/yyyy')
                            .format(_selectedDate!)
                            .toUpperCase()),
                  ),
                  const SizedBox(height: 16.0),
                  _images.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhuma imagem selecionada".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                        )
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
                                          child: Container(
                                            margin: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 0, 104, 55),
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.white),
                                              onPressed: () {
                                                _confirmDeleteImage(image);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text("Capturar Imagem".toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text("Selecionar da Galeria".toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text('Salvar alterações'.toUpperCase()),
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Segoe Bold',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
