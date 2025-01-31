import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';

class EditInspecaoScreen extends StatefulWidget {
  final int index;
  final Inspecao initialData;

  const EditInspecaoScreen(
      {super.key, required this.index, required this.initialData});

  @override
  EditInspecaoScreenState createState() => EditInspecaoScreenState();
}

class EditInspecaoScreenState extends State<EditInspecaoScreen> {
  late TextEditingController _tipoController;
  late TextEditingController _localController;
  late TextEditingController _descricaoController;
  late TextEditingController _pontoDescricaoController;
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _pontos = [];
  File? _imagemPonto;
  bool _conformePonto = true;
  String? _inconformidadePonto;

  @override
  void initState() {
    super.initState();
    _tipoController =
        TextEditingController(text: widget.initialData.tipoInspecao);
    _localController = TextEditingController(text: widget.initialData.local);
    _descricaoController =
        TextEditingController(text: widget.initialData.descricao);
    _pontoDescricaoController = TextEditingController();
    _selectedDate = widget.initialData.data;
    _pontos = List<Map<String, dynamic>>.from(widget.initialData.pontos);
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

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagemPonto = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao selecionar imagem: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _adicionarPonto() {
    if (_pontoDescricaoController.text.isEmpty) {
      _showSnackBar('A descrição do ponto é obrigatória.');
      return;
    }

    setState(() {
      _pontos.add({
        'descricao': _pontoDescricaoController.text,
        'imagem': _imagemPonto?.path,
        'conforme': _conformePonto,
        'inconformidade': _inconformidadePonto,
      });
      _pontoDescricaoController.clear();
      _imagemPonto = null;
      _conformePonto = true;
      _inconformidadePonto = null;
    });
  }

  void _visualizarImagem(String? imagemPath) {
    if (imagemPath == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(File(imagemPath)),
        );
      },
    );
  }

  Future<void> _submitInspecao() async {
    if (_tipoController.text.isEmpty ||
        _localController.text.isEmpty ||
        _descricaoController.text.isEmpty ||
        _selectedDate == null) {
      _showSnackBar('Todos os campos são obrigatórios.');
      return;
    }

    if (_pontos.isEmpty) {
      _showSnackBar('Adicione pelo menos um ponto de verificação.');
      return;
    }

    final inspecaoProvider =
        Provider.of<InspecaoProvider>(context, listen: false);
    final updatedInspecao = Inspecao(
      id: widget.initialData.id,
      tipoInspecao: _tipoController.text,
      local: _localController.text,
      descricao: _descricaoController.text,
      data: _selectedDate!,
      pontos: _pontos,
      anexos: _imagemPonto != null
          ? [_imagemPonto!.path]
          : widget.initialData.anexos,
    );

    await inspecaoProvider.updateInspecao(widget.index, updatedInspecao);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspeção atualizada')),
    );

    Navigator.of(context).pop(updatedInspecao);
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
            'Editar Inspeção'.toUpperCase(),
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
            image: AssetImage('assets/images/inspecao.jpg'),
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
                  OutlinedTextField3(
                    controller: _tipoController,
                    labelText: 'Tipo de Inspeção',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedTextField3(
                    controller: _localController,
                    labelText: 'Local',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedTextField3(
                    controller: _descricaoController,
                    labelText: 'Descrição',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {},
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
                  const Text(
                    'Adicionar Ponto de Verificação:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  OutlinedTextField3(
                    controller: _pontoDescricaoController,
                    labelText: 'Descrição do Ponto',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {},
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: _pickImage,
                      ),
                      if (_imagemPonto != null)
                        GestureDetector(
                          onTap: () => _visualizarImagem(_imagemPonto?.path),
                          child: Image.file(
                            _imagemPonto!,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      Checkbox(
                        value: _conformePonto,
                        onChanged: (value) {
                          setState(() {
                            _conformePonto = value ?? true;
                          });
                        },
                      ),
                      if (!_conformePonto)
                        Expanded(
                          child: OutlinedTextField3(
                            controller: TextEditingController(
                                text: _inconformidadePonto),
                            labelText: 'Inconformidade',
                            obscureText: false,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              _inconformidadePonto = value;
                            },
                          ),
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _adicionarPonto,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Segoe Bold'),
                    ),
                    child: Text('Adicionar Ponto'.toUpperCase()),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Pontos Adicionados:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pontos.length,
                    itemBuilder: (ctx, index) {
                      final ponto = _pontos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(ponto['descricao']),
                          subtitle: Text(ponto['conforme']
                              ? 'Conforme'
                              : 'Inconforme: ${ponto['inconformidade']}'),
                          leading: ponto['imagem'] != null
                              ? GestureDetector(
                                  onTap: () =>
                                      _visualizarImagem(ponto['imagem']),
                                  child: Image.file(
                                    File(ponto['imagem']),
                                    width: 50,
                                    height: 50,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _pontos.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
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
                onPressed: _submitInspecao,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle:
                      const TextStyle(fontSize: 16, fontFamily: 'Segoe Bold'),
                ),
                icon: const Icon(Icons.save),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
