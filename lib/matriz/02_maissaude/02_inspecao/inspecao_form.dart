import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'dados_inspecao.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';
import 'image_gallery.dart';

class InspecaoForm extends StatefulWidget {
  final int? index;
  final Inspecao? initialData;

  const InspecaoForm({super.key, this.index, this.initialData});

  @override
  State<InspecaoForm> createState() => _InspecaoFormState();
}

class _InspecaoFormState extends State<InspecaoForm> {
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
    final data = widget.initialData;
    _tipoController = TextEditingController(text: data?.tipoInspecao ?? '');
    _localController = TextEditingController(text: data?.local ?? '');
    _pontoDescricaoController = TextEditingController();
    _selectedDate = data?.data ?? DateTime.now();
    if (data != null) _pontos = List.from(data.pontos);
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _localController.dispose();
    _pontoDescricaoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && mounted) setState(() => _selectedDate = picked);
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tirar foto'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Escolher da galeria'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return;

    try {
      if (source == ImageSource.gallery) {
        final files = await ImagePicker().pickMultiImage();
        if (files.isNotEmpty && mounted) {
          setState(() => _imagensPonto.addAll(files.map((f) => File(f.path))));
        }
      } else {
        final file = await ImagePicker().pickImage(source: source);
        if (file != null && mounted) {
          setState(() => _imagensPonto.add(File(file.path)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  void _abrirGaleriaTemporaria(int index) {
    final paths = _imagensPonto.map((f) => f.path).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGallery(imagePaths: paths, initialIndex: index),
      ),
    );
  }

  void _abrirGaleriaPonto(int pontoIndex, int imagemIndex) {
    final imagens = List<String>.from(_pontos[pontoIndex]['imagens']);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGallery(
          imagePaths: imagens,
          initialIndex: imagemIndex,
        ),
      ),
    );
  }

  void _adicionarPonto() {
    if (_pontoDescricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descrição obrigatória')),
      );
      return;
    }

    final ponto = {
      'descricao': _pontoDescricaoController.text,
      'imagens': _imagensPonto.map((f) => f.path).toList(),
      'conforme': _conformePonto,
      'inconformidade': _inconformidadePonto,
    };

    setState(() {
      if (_editingIndex == null) {
        _pontos.add(ponto);
      } else {
        _pontos[_editingIndex!] = ponto;
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
        const SnackBar(content: Text('Campos obrigatórios')),
      );
      return;
    }
    if (_pontos.isEmpty && _pontoDescricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um ponto')),
      );
      return;
    }
    if (_pontoDescricaoController.text.isNotEmpty || _imagensPonto.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finalize o ponto em andamento')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final inspecao = Inspecao(
      id: widget.index != null
          ? widget.initialData!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      tipoInspecao: _tipoController.text,
      local: _localController.text,
      data: _selectedDate!,
      pontos: _pontos,
      anexos: const [],
    );

    final provider = Provider.of<InspecaoProvider>(context, listen: false);
    if (widget.index == null) {
      await provider.saveInspecao(inspecao);
    } else {
      await provider.updateInspecao(widget.index!, inspecao);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salvo com sucesso!')),
    );
    Navigator.pop(context, inspecao);
  }

  Future<bool?> _confirmDeleteImage(File img) async {
    final del = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Imagem'),
        content: const Text('Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (del == true && mounted) {
      setState(() => _imagensPonto.remove(img));
    }
    return del;
  }

  Future<bool?> _confirmDeletePonto(int i) async {
    final del = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Ponto'),
        content: const Text('Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (del == true && mounted) {
      setState(() => _pontos.removeAt(i));
    }
    return del;
  }

  void _editarPonto(int i) {
    final p = _pontos[i];
    setState(() {
      _pontoDescricaoController.text = p['descricao'];
      _imagensPonto.clear();
      _imagensPonto.addAll((p['imagens'] as List).map((path) => File(path)));
      _conformePonto = p['conforme'];
      _inconformidadePonto = p['inconformidade'];
      _editingIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color.fromARGB(255, 0, 104, 55);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (widget.index == null ? 'NOVA INSPEÇÃO' : 'EDITAR INSPEÇÃO'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _tipoController,
                          labelText: 'Tipo de Inspeção',
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) {},
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _localController,
                          labelText: 'Local',
                          obscureText: false,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (_) {},
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy')
                          .format(_selectedDate ?? DateTime.now())
                          .toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pontos de Verificação',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: OutlinedTextField3(
                            controller: _pontoDescricaoController,
                            labelText: 'Descrição do Ponto',
                            obscureText: false,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (_) {},
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_imagensPonto.isNotEmpty)
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imagensPonto.length,
                        itemBuilder: (context, i) {
                          final img = _imagensPonto[i];
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => _abrirGaleriaTemporaria(i),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: buttonColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        img,
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
                                        onTap: () => _confirmDeleteImage(img),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4),
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
                  Row(
                    children: [
                      const Text('Conforme:', style: TextStyle(fontSize: 16)),
                      Checkbox(
                        activeColor: buttonColor,
                        value: _conformePonto,
                        onChanged: (v) =>
                            setState(() => _conformePonto = v ?? true),
                      ),
                    ],
                  ),
                  if (!_conformePonto)
                    OutlinedTextField3(
                      controller: TextEditingController(
                        text: _inconformidadePonto,
                      ),
                      labelText: 'Inconformidade',
                      obscureText: false,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (v) => _inconformidadePonto = v,
                      maxLines: 1,
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _adicionarPonto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      (_editingIndex == null
                              ? 'ADICIONAR PONTO'
                              : 'ATUALIZAR PONTO')
                          .toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pontos.length,
                    itemBuilder: (ctx, i) {
                      final p = _pontos[i];
                      final imagens = List<String>.from(p['imagens'] ?? []);
                      final conforme = p['conforme'] == true;

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        confirmDismiss: (dir) async {
                          if (dir == DismissDirection.startToEnd) {
                            _editarPonto(i);
                            return false;
                          }
                          return _confirmDeletePonto(i);
                        },
                        child: Card(
                          color: buttonColor,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['descricao'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  conforme
                                      ? 'Conforme'
                                      : 'Inconforme: ${p['inconformidade']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                if (imagens.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          imagens.asMap().entries.map((e) {
                                        final idx = e.key;
                                        final path = e.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => _abrirGaleriaPonto(
                                              i,
                                              idx,
                                            ),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    File(path),
                                                  ),
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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
