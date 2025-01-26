import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_aet.dart';
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
  final TextEditingController _descriptionController = TextEditingController();
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
        _descriptionController.text.isNotEmpty &&
        _selectedDate != null &&
        _locationController.text.isNotEmpty) {
      final report = {
        'description': _descriptionController.text,
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
    _descriptionController.clear();
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
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
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
            'Novo Relatório de Incidente'.toUpperCase(),
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
                        ))
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
                  const SizedBox(height: 30.0),
                  Center(
                    child: Text(
                      'Atenção: Todos os campos são obrigatórios'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
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
                label: Text('Salvar Relatório'.toUpperCase()),
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
