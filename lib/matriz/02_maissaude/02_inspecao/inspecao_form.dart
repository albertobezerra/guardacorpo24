import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';

class InspecaoForm extends StatefulWidget {
  final int? index; // Índice da inspeção (opcional, usado apenas para edição)
  final Inspecao? initialData; // Dados iniciais da inspeção (opcional)

  const InspecaoForm({
    super.key,
    this.index,
    this.initialData,
  });

  @override
  InspecaoFormState createState() => InspecaoFormState();
}

class InspecaoFormState extends State<InspecaoForm> {
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
    final initialData = widget.initialData;

    _tipoController = TextEditingController(
        text: initialData?.tipoInspecao ?? ''); // Preenche se estiver editando
    _localController = TextEditingController(
        text: initialData?.local ?? ''); // Preenche se estiver editando
    _pontoDescricaoController = TextEditingController();

    _selectedDate = initialData?.data ?? DateTime.now(); // Define data inicial

    if (initialData != null) {
      _pontos = List<Map<String, dynamic>>.from(initialData.pontos);
    }
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
    final ImageSource? source = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        );
      },
    );

    if (source != null) {
      try {
        if (source == ImageSource.gallery) {
          final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
          if (pickedFiles.isNotEmpty) {
            setState(() {
              _imagensPonto.addAll(pickedFiles.map((file) => File(file.path)));
            });
          }
        } else {
          final XFile? pickedFile =
              await ImagePicker().pickImage(source: source);
          if (pickedFile != null) {
            setState(() {
              _imagensPonto.add(File(pickedFile.path));
            });
          }
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
    // Verifica se os campos principais estão preenchidos
    if (_tipoController.text.isEmpty ||
        _localController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos os campos são obrigatórios.')),
      );
      return;
    }

    // Verifica se há pelo menos um ponto de verificação
    if (_pontos.isEmpty && _pontoDescricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Adicione pelo menos um ponto de verificação.')),
      );
      return;
    }

    // Verifica se há um ponto em andamento
    bool hasUnfinishedPoint = false;

    // Verifica se há um ponto sendo adicionado/editado
    if (_pontoDescricaoController.text.isNotEmpty || _imagensPonto.isNotEmpty) {
      hasUnfinishedPoint = true;
    }

    // Verifica se algum ponto na lista está incompleto
    for (var ponto in _pontos) {
      if (ponto['descricao'].toString().isEmpty) {
        hasUnfinishedPoint = true;
        break;
      }
    }

    // Exibe aviso se houver ponto em andamento
    if (hasUnfinishedPoint) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Há pontos de verificação em andamento. Por favor, finalize-os antes de salvar.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final inspecao = Inspecao(
      id: widget.index != null
          ? widget.initialData!.id
          : DateTime.now().toString(),
      tipoInspecao: _tipoController.text,
      local: _localController.text,
      data: _selectedDate!,
      pontos: _pontos,
      anexos: [],
    );

    final inspecaoProvider =
        Provider.of<InspecaoProvider>(context, listen: false);

    if (widget.index == null) {
      // Modo de criação
      await inspecaoProvider.saveInspecao(inspecao);
    } else {
      // Modo de edição
      await inspecaoProvider.updateInspecao(widget.index!, inspecao);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspeção salva com sucesso!')),
    );

    // Retorna a inspeção atualizada para a tela anterior
    Navigator.of(context).pop(inspecao);
  }

  void _visualizarImagem(String? imagemPath) {
    if (imagemPath == null) return;
    // Remove o foco imediatamente antes de abrir o diálogo
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(File(imagemPath)),
        );
      },
    ).then((_) {
      // Garante que o foco continua removido após fechar o diálogo
      if (!mounted) return;
      FocusScope.of(context).requestFocus(FocusNode());
    });
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
                ? 'Nova Inspeção'.toUpperCase()
                : 'Editar Inspeção'.toUpperCase(),
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
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                    .toUpperCase()
                                : DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!)
                                    .toUpperCase(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Pontos de Verificação
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Pontos de Verificação',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),

                  // Linha com Descrição e Ícone da Câmera
                  Center(
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: OutlinedTextField3(
                              controller: _pontoDescricaoController,
                              labelText: 'Descrição do Ponto',
                              obscureText: false,
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (value) {},
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          // Botão da Câmera (25%)
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const SizedBox.expand(
                                child: Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Exibição das Imagens Selecionadas
                  if (_imagensPonto.isNotEmpty)
                    Container(
                      height: 120,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imagensPonto.length,
                        itemBuilder: (context, index) {
                          final imagem = _imagensPonto[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            width: 100,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: buttonColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: GestureDetector(
                                      onTap: () =>
                                          _visualizarImagem(imagem.path),
                                      child: Image.file(
                                        imagem,
                                        fit: BoxFit.cover,
                                      ),
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
                                        onTap: () =>
                                            _confirmDeleteImage(imagem),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: Colors.white,
                                          ),
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

                  // Conforme/Inconforme
                  Row(
                    children: [
                      const Text(
                        'Conforme:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Checkbox(
                        activeColor: buttonColor,
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pontos.length,
                    itemBuilder: (ctx, index) {
                      final ponto = _pontos[index];
                      final List<String> imagensPonto = ponto['imagens'] != null
                          ? List<String>.from(ponto['imagens'])
                          : [];

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 30),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 30),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            _editarPonto(index);
                            return false; // Impede a remoção ao editar
                          } else {
                            final shouldDelete =
                                await _confirmDeletePonto(index);
                            return shouldDelete;
                          }
                        },
                        onDismissed: (direction) {
                          setState(() {
                            _pontos.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              color: buttonColor,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ponto['descricao'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      ponto['conforme']
                                          ? 'Conforme'
                                          : 'Inconforme: ${ponto['inconformidade']}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    if (imagensPonto.isNotEmpty)
                                      const SizedBox(height: 16.0),
                                    if (imagensPonto.isNotEmpty)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                              imagensPonto.map((imagemPath) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: GestureDetector(
                                                onTap: () => _visualizarImagem(
                                                    imagemPath),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                          File(imagemPath)),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Botão Flutuante Circular para Salvar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitInspecao,
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
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
