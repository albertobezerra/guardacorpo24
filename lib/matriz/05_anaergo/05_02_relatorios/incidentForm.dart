import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_fild_aet4.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class IncidentForm extends StatefulWidget {
  final int? index; // Índice do relatório (opcional, usado apenas para edição)
  final Map? initialData; // Dados iniciais do relatório (opcional)

  const IncidentForm({
    super.key,
    this.index,
    this.initialData,
  });

  @override
  IncidentFormState createState() => IncidentFormState();
}

class IncidentFormState extends State<IncidentForm> {
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  List<File> _images = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final initialData = widget.initialData;
    _descriptionController = TextEditingController(
      text: initialData?['description'] ?? '',
    );
    _locationController = TextEditingController(
      text: initialData?['location'] ?? '',
    );
    _selectedDate = initialData?['date'] != null
        ? DateFormat('dd/MM/yyyy').parse(initialData!['date'])
        : null;
    if (initialData != null && initialData.containsKey('imagePaths')) {
      _images = (initialData['imagePaths'] as List<dynamic>? ?? [])
          .map((path) => File(path.toString()))
          .toList();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (!mounted || pickedFile == null) return;
    setState(() {
      _images.add(File(pickedFile.path));
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<bool> _confirmDeleteImage(File image) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Imagem'),
          content:
              const Text('Você tem certeza que deseja excluir esta imagem?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      setState(() {
        _images.remove(image);
      });
    }
    return shouldDelete ?? false;
  }

  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDate == null ||
        _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final report = {
      'description': _descriptionController.text,
      'location': _locationController.text,
      'date': DateFormat('dd/MM/yyyy').format(_selectedDate!),
      'imagePaths': _images.map((image) => image.path).toList(),
    };

    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    if (widget.index == null) {
      // Modo de criação
      await reportProvider.saveReport(report, _images);
    } else {
      // Modo de edição
      await reportProvider.updateReport(widget.index!, report, _images);
    }

    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relatório salvo com sucesso!')),
    );

    Navigator.of(context).pop(report);
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
            widget.index == null
                ? 'Novo Relatório de Incidente'.toUpperCase()
                : 'Editar Relatório de Incidente'.toUpperCase(),
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
            image: AssetImage('assets/images/relatorios.jpg'),
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
                  OutlinedTextField4(
                    controller: _descriptionController,
                    labelText: 'Descrição',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedTextField4(
                    controller: _locationController,
                    labelText: 'Localização',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
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
                          fontSize: 16, fontFamily: 'Segoe Bold'),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Selecionar Data'.toUpperCase()
                          : DateFormat('dd/MM/yyyy')
                              .format(_selectedDate!)
                              .toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          final image = _images[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            width: 100,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.red.withAlpha(180),
                                      child: InkWell(
                                        onTap: () => _confirmDeleteImage(image),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.delete,
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Segoe Bold'),
                    ),
                    child: Text("Tirar Foto".toUpperCase()),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Segoe Bold'),
                    ),
                    child: Text("Escolher da Galeria".toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(56, 56),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.check, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
