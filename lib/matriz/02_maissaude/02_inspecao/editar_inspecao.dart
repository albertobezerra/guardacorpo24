import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';

class EditInspecaoScreen extends StatefulWidget {
  final int index;
  final Inspecao initialData;

  const EditInspecaoScreen({
    super.key,
    required this.index,
    required this.initialData,
  });

  @override
  EditInspecaoScreenState createState() => EditInspecaoScreenState();
}

class EditInspecaoScreenState extends State<EditInspecaoScreen> {
  late TextEditingController _tipoController;
  late TextEditingController _localController;
  late TextEditingController _descricaoController;
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _pontos = [];
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _tipoController =
        TextEditingController(text: widget.initialData.tipoInspecao);
    _localController = TextEditingController(text: widget.initialData.local);
    _descricaoController =
        TextEditingController(text: widget.initialData.descricao);
    _selectedDate = widget.initialData.data;
    _pontos = widget.initialData.pontos;
    _images = widget.initialData.anexos.map((path) => File(path)).toList();
  }

  Future<void> _pickImage(ImageSource source, int index) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (!mounted) return;
    setState(() {
      if (pickedFile != null) {
        _pontos[index]['imagem'] = File(pickedFile.path);
      }
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

  Future<void> _submitInspecao() async {
    if (_tipoController.text.isNotEmpty &&
        _localController.text.isNotEmpty &&
        _descricaoController.text.isNotEmpty &&
        _selectedDate != null) {
      final updatedInspecao = Inspecao(
        id: widget.initialData.id,
        tipoInspecao: _tipoController.text,
        data: _selectedDate!,
        local: _localController.text,
        descricao: _descricaoController.text,
        anexos: _images.map((file) => file.path).toList(),
        pontos: _pontos,
      );

      final inspecaoProvider =
          Provider.of<InspecaoProvider>(context, listen: false);
      await inspecaoProvider.updateInspecao(widget.index, updatedInspecao);

      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      // Mostra alerta de erro
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Todos os campos são obrigatórios.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Inspeção'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _tipoController,
                decoration:
                    const InputDecoration(labelText: 'Tipo de Inspeção')),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(_selectedDate == null
                  ? 'Selecionar Data'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
            ),
            TextField(
                controller: _localController,
                decoration: const InputDecoration(labelText: 'Local')),
            TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição')),

            // Lista de pontos verificados
            ListView.builder(
              shrinkWrap: true,
              itemCount: _pontos.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    TextField(
                      decoration:
                          InputDecoration(labelText: 'Ponto ${index + 1}'),
                      onChanged: (value) {
                        _pontos[index]['descricao'] = value;
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: () =>
                              _pickImage(ImageSource.gallery, index),
                        ),
                        if (_pontos[index]['imagem'] != null)
                          Image.file(
                            _pontos[index]['imagem'],
                            width: 100,
                            height: 100,
                          ),
                        Checkbox(
                          value: _pontos[index]['conforme'],
                          onChanged: (value) {
                            setState(() {
                              _pontos[index]['conforme'] = value;
                            });
                          },
                        ),
                        if (!(_pontos[index]['conforme'] ?? true))
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Inconformidade'),
                              onChanged: (value) {
                                _pontos[index]['inconformidade'] = value;
                              },
                            ),
                          ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pontos.add({'descricao': '', 'conforme': true});
                });
              },
              child: const Text('Adicionar Ponto de Verificação'),
            ),
            ElevatedButton(
              onPressed: _submitInspecao,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
