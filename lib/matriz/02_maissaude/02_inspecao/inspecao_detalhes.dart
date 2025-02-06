import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_form.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dados_inspecao.dart';

class InspecaoDetailScreen extends StatefulWidget {
  final Inspecao inspecao;
  final int index;

  const InspecaoDetailScreen({
    super.key,
    required this.inspecao,
    required this.index,
  });

  @override
  InspecaoDetailScreenState createState() => InspecaoDetailScreenState();
}

class InspecaoDetailScreenState extends State<InspecaoDetailScreen> {
  late Inspecao _inspecao;

  @override
  void initState() {
    super.initState();
    _inspecao = widget.inspecao;
  }

  void _visualizarImagem(BuildContext context, String? imagemPath) {
    if (imagemPath == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: Image.file(File(imagemPath)));
      },
    );
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
            'Detalhes da Inspeção'.toUpperCase(),
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
          actions: [
            Container(
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 0, 104, 55)),
                onPressed: () async {
                  // Abre o InspecaoForm no modo de edição
                  final updatedInspecao = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InspecaoForm(
                        index: widget.index, // Índice da inspeção
                        initialData: _inspecao, // Dados atuais da inspeção
                      ),
                    ),
                  );

                  // Atualiza a inspeção na tela de detalhes se houver mudanças
                  if (updatedInspecao != null && mounted) {
                    setState(() {
                      _inspecao = updatedInspecao;
                    });
                  }
                },
              ),
            ),
          ],
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tipo de Inspeção:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_inspecao.tipoInspecao),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Local:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(_inspecao.local),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data ocupando 50% da largura
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_inspecao.data),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const Divider(height: 32, thickness: 1, color: Colors.grey),
                  const SizedBox(height: 16),
                  // Pontos de Verificação
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Pontos de Verificação:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _inspecao.pontos.length,
                    itemBuilder: (ctx, index) {
                      final ponto = _inspecao.pontos[index];
                      final List<String> imagensPonto = ponto['imagens'] != null
                          ? List<String>.from(ponto['imagens'])
                          : [];

                      return Card(
                        color: buttonColor,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
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
                                style: const TextStyle(color: Colors.white),
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
                                          onTap: () => _visualizarImagem(
                                              context, imagemPath),
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

          // Botão Excluir Inspeção
          // Botão Excluir Inspeção
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (!mounted) return;
                // Dialogo de confirmação
                final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Excluir Inspeção'),
                          content: const Text(
                              'Você tem certeza que deseja excluir esta inspeção? Esta ação não pode ser desfeita.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: const Text('Excluir',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    ) ??
                    false;

                if (!shouldDelete || !context.mounted) return;

                // Lógica de exclusão
                final inspecaoProvider =
                    Provider.of<InspecaoProvider>(context, listen: false);
                await inspecaoProvider.deleteInspecao(widget.index);

                if (!context.mounted) return;

                // Mostrar SnackBar de sucesso
                Future.microtask(() {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Inspeção excluída com sucesso')),
                    );
                  }
                });

                // Fechar a tela
                Future.microtask(() {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor de fundo do botão
                shape: const CircleBorder(), // Forma circular
                padding: const EdgeInsets.all(12), // Espaçamento interno
                minimumSize: const Size(48, 48), // Tamanho mínimo do botão
              ),
              child: const Icon(
                Icons.delete, // Ícone de exclusão
                color: Colors.white, // Cor do ícone
                size: 24, // Tamanho do ícone
              ),
            ),
          ),
        ],
      ),
    );
  }
}
