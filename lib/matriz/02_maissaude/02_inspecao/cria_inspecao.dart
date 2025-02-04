import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';

class CreateInspecao extends StatefulWidget {
  const CreateInspecao({super.key});

  @override
  CreateInspecaoState createState() => CreateInspecaoState();
}

class CreateInspecaoState extends State<CreateInspecao> {
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _pontoDescricaoController =
      TextEditingController();
  DateTime? _selectedDate;
  final List<Map<String, dynamic>> _pontos = [];
  final List<File> _imagensPonto = [];
  bool _isLoading = false;
  bool _conformePonto = true;
  String? _inconformidadePonto;
  int? _editingIndex;

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

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
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
          // Permitir múltiplas imagens
          final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
          if (pickedFiles.isNotEmpty) {
            setState(() {
              _imagensPonto.addAll(pickedFiles.map((file) => File(file.path)));
            });
          }
        } else {
          // Capturar imagem única da câmera
          final XFile? pickedFile =
              await ImagePicker().pickImage(source: source);
          if (pickedFile != null) {
            setState(() {
              _imagensPonto.add(File(pickedFile.path));
            });
          }
        }
      } catch (e) {
        _showSnackBar('Erro ao selecionar imagem: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearForm() {
    _tipoController.clear();
    _localController.clear();
    _pontoDescricaoController.clear();
    setState(() {
      _selectedDate = null;
      _pontos.clear();
      _imagensPonto.clear();
      _conformePonto = true;
      _inconformidadePonto = null;
      _editingIndex = null;
    });
  }

  void _adicionarPonto() {
    if (_pontoDescricaoController.text.isEmpty) {
      _showSnackBar('A descrição do ponto é obrigatória.');
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
        // Adicionar novo ponto
        _pontos.add(novoPonto);
      } else {
        // Atualizar ponto existente
        _pontos[_editingIndex!] = novoPonto;
        _editingIndex = null; // Limpar índice de edição
      }

      // Limpar campos após adicionar/atualizar
      _pontoDescricaoController.clear();
      _imagensPonto.clear();
      _conformePonto = true;
      _inconformidadePonto = null;
    });
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

  Future<void> _confirmDeleteImage(File image) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Excluir Imagem'),
              content: const Text(
                  'Você tem certeza que deseja excluir esta imagem?'),
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
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _imagensPonto.remove(image);
      });
    }
  }

  Future<void> _confirmDeletePonto(int index) async {
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
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _pontos.removeAt(index);
      });
    }
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

  Future<void> _submitInspecao() async {
    if (_tipoController.text.isEmpty ||
        _localController.text.isEmpty ||
        _selectedDate == null) {
      _showSnackBar('Todos os campos são obrigatórios.');
      return;
    }

    if (_pontoDescricaoController.text.isNotEmpty || _imagensPonto.isNotEmpty) {
      _showSnackBar(
          'Há um ponto de verificação em andamento. Por favor, finalize-o antes de salvar.');
      return;
    }

    if (_pontos.isEmpty) {
      _showSnackBar('Adicione pelo menos um ponto de verificação.');
      return;
    }

    setState(() {
      _isLoading = true; // Ativar estado de carregamento
    });

    final inspecao = Inspecao(
      id: DateTime.now().toString(),
      tipoInspecao: _tipoController.text,
      local: _localController.text,
      data: _selectedDate!,
      pontos: _pontos,
      anexos: [], // Limpar anexos não utilizados
    );

    final inspecaoProvider =
        Provider.of<InspecaoProvider>(context, listen: false);
    await inspecaoProvider.saveInspecao(inspecao);

    if (!mounted) return;

    setState(() {
      _isLoading = false; // Desativar estado de carregamento
    });

    _clearForm();
    _showSnackBar('Inspeção salva com sucesso!');
    Navigator.of(context).pop();
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
            'Nova Inspeção'.toUpperCase(),
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
                                vertical: 12.0, horizontal: 8.0),
                            textStyle: const TextStyle(
                                fontSize: 14, fontFamily: 'Segoe Bold'),
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
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, // Estica os widgets para a mesma altura
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
                          // Botão de Câmera (25%)
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
                                padding:
                                    EdgeInsets.zero, // Remove padding extra
                              ),
                              child: const SizedBox.expand(
                                // Faz o botão ocupar todo o espaço disponível
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

                  // Exibição das Imagens Selecionadas
                  if (_imagensPonto.isNotEmpty)
                    Container(
                      height: 120, // Altura fixa para o scroll horizontal
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      12), // Bordas arredondadas
                                  child: GestureDetector(
                                    onTap: () => _visualizarImagem(imagem.path),
                                    child: Image.file(
                                      imagem,
                                      fit: BoxFit
                                          .cover, // Ajusta a imagem ao container
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.red.withValues(
                                          alpha: 0.7), // Cor do botão
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
                    )
                  else
                    const SizedBox.shrink(),

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
                    onPressed: () {
                      _adicionarPonto();
                      FocusScope.of(context).unfocus(); // Fechar teclado
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                          fontSize: 16, fontFamily: 'Segoe Bold'),
                    ),
                    child: Text(
                      _editingIndex == null
                          ? 'Adicionar Ponto'.toUpperCase()
                          : 'Atualizar Ponto'.toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pontos.length,
                    itemBuilder: (ctx, index) {
                      final ponto = _pontos[index];
                      final List<String> imagensPonto = ponto['imagens'] != null
                          ? List<String>.from(ponto['imagens'])
                          : [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Alinha os elementos no topo
                          children: [
                            // Card com Detalhes do Ponto (75%)
                            Expanded(
                              flex: 3,
                              child: Card(
                                color: buttonColor,
                                margin: const EdgeInsets.only(left: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      if (imagensPonto.isNotEmpty) ...[
                                        const SizedBox(height: 16.0),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                imagensPonto.map((imagemPath) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _visualizarImagem(
                                                          imagemPath),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
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
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Botões Editar e Excluir (25%)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Botão Editar
                                SizedBox(
                                  height:
                                      50, // Define uma altura fixa para evitar erro de layout
                                  width:
                                      50, // Garante que o botão fique quadrado
                                  child: ElevatedButton(
                                    onPressed: () => _editarPonto(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: buttonColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                    child: const Icon(Icons.edit,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                    height: 8.0), // Espaçamento entre os botões

                                // Botão Excluir
                                SizedBox(
                                  height:
                                      50, // Define uma altura fixa para evitar erro de layout
                                  width:
                                      50, // Garante que o botão fique quadrado
                                  child: ElevatedButton(
                                    onPressed: () => _confirmDeletePonto(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                    child: const Icon(Icons.delete,
                                        size: 20, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Botão Finalizar Inspeção
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitInspecao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(56, 56),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 28,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
