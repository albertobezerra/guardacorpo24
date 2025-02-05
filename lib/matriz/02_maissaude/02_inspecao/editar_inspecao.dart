import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';

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
  late TextEditingController _pontoDescricaoController;
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _pontos = [];
  final List<File> _imagensPonto = [];
  bool _conformePonto = true;
  String? _inconformidadePonto;
  int? _editingIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tipoController =
        TextEditingController(text: widget.initialData.tipoInspecao);
    _localController = TextEditingController(text: widget.initialData.local);
    _pontoDescricaoController = TextEditingController();
    _selectedDate = widget.initialData.data;
    _pontos = List<Map<String, dynamic>>.from(widget.initialData.pontos);
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _localController.dispose();
    _pontoDescricaoController.dispose();
    super.dispose();
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
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha uma opção'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Galeria'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      try {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _imagensPonto.add(File(pickedFile.path));
          });
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  void _adicionarPonto() {
    if (_pontoDescricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A descrição do ponto é obrigatória.')),
      );
      return;
    }

    final novoPonto = {
      'descricao': _pontoDescricaoController.text,
      'imagens': _imagensPonto.map((file) => file.path).toList(),
      'conforme': _conformePonto,
      'inconformidade': _inconformidadePonto,
    };

    setState(() {
      if (_editingIndex == null) {
        _pontos.add(novoPonto);
      } else {
        _pontos[_editingIndex!] = novoPonto;
        _editingIndex = null;
      }

      _pontoDescricaoController.clear();
      _imagensPonto.clear();
      _conformePonto = true;
      _inconformidadePonto = null;
    });
  }

  Future<void> _submitInspecao() async {
    if (_tipoController.text.isEmpty ||
        _localController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios.')),
      );
      return;
    }

    if (_pontos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Adicione pelo menos um ponto de verificação.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedInspecao = Inspecao(
      id: widget.initialData.id,
      tipoInspecao: _tipoController.text,
      local: _localController.text,
      data: _selectedDate!,
      pontos: _pontos,
      anexos: [],
    );

    final inspecaoProvider =
        Provider.of<InspecaoProvider>(context, listen: false);
    await inspecaoProvider.updateInspecao(widget.index, updatedInspecao);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspeção atualizada.')),
    );

    Navigator.of(context).pop(updatedInspecao);
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color.fromARGB(255, 0, 104, 55); // Verde padrão

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
                  // Tipo de Inspeção e Local na mesma linha
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _tipoController,
                          labelText: 'Tipo de Inspeção',
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {},
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _localController,
                          labelText: 'Local',
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {},
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Data ocupando 50% da largura
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: _pickDate,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Segoe Bold',
                            ),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'Selecionar Data'.toUpperCase()
                                : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!)
                                    .toUpperCase(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Descrição do Ponto (2 linhas)
                  Row(
                    children: [
                      Expanded(
                        flex: 3, // Proporção menor para o campo de texto
                        child: OutlinedTextField3(
                          controller: _pontoDescricaoController,
                          labelText: 'Descrição do Ponto',
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {},
                          maxLines: 2, // Apenas 2 linhas
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Botão da Câmera (Tamanho Maior)
                      Expanded(
                        flex: 1, // Proporção maior para o botão
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: buttonColor,
                            padding: const EdgeInsets.all(16.0),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            size: 32, // Tamanho maior
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Exibição de Imagens Selecionadas
                  if (_imagensPonto.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _imagensPonto.map((imagem) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _visualizarImagem(imagem.path),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: buttonColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(imagem),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDeleteImage(imagem),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16.0),

                  // Conforme/Inconforme
                  Row(
                    children: [
                      const Text(
                        'Conforme:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Checkbox(
                        value: _conformePonto,
                        onChanged: (value) {
                          setState(() {
                            _conformePonto = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                  if (!_conformePonto)
                    OutlinedTextField3(
                      controller:
                          TextEditingController(text: _inconformidadePonto),
                      labelText: 'Inconformidade',
                      obscureText: false,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        _inconformidadePonto = value;
                      },
                      maxLines: 1,
                    ),
                  const SizedBox(height: 16.0),

                  // Botão para adicionar/atualizar ponto
                  ElevatedButton(
                    onPressed: _adicionarPonto,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text(
                      _editingIndex == null
                          ? 'Adicionar Ponto'.toUpperCase()
                          : 'Atualizar Ponto'.toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Lista de Pontos Adicionados
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
                      final List<String> imagensPonto = ponto['imagens'] != null
                          ? List<String>.from(ponto['imagens'])
                          : [];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.white, // Mesma cor de fundo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: buttonColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ponto['descricao'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: buttonColor,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                ponto['conforme']
                                    ? 'Conforme'
                                    : 'Inconforme: ${ponto['inconformidade']}',
                                style: const TextStyle(color: Colors.black54),
                              ),
                              if (imagensPonto.isNotEmpty)
                                const SizedBox(height: 16.0),
                              if (imagensPonto.isNotEmpty)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: imagensPonto.map((imagemPath) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _visualizarImagem(imagemPath),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: buttonColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image:
                                                    FileImage(File(imagemPath)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              const SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _editarPonto(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _confirmDeletePonto(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Botão Flutuante Circular para Salvar
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _submitInspecao,
        backgroundColor: buttonColor,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }

  void _visualizarImagem(String? imagemPath) {
    if (imagemPath == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: Image.file(File(imagemPath)));
      },
    );
  }

  Future<bool?> _confirmDeleteImage(File image) async {
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
        _imagensPonto.remove(image);
      });
    }
    return shouldDelete;
  }

  Future<bool?> _confirmDeletePonto(int index) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Ponto de Verificação'),
          content: const Text(
              'Você tem certeza que deseja excluir este ponto de verificação?'),
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
        _pontos.removeAt(index);
      });
    }
    return shouldDelete;
  }

  void _editarPonto(int index) {
    final ponto = _pontos[index];
    setState(() {
      _pontoDescricaoController.text = ponto['descricao'];
      _imagensPonto.clear();
      for (var path in ponto['imagens']) {
        _imagensPonto.add(File(path));
      }
      _conformePonto = ponto['conforme'];
      _inconformidadePonto = ponto['inconformidade'];
      _editingIndex = index;
    });
  }
}
