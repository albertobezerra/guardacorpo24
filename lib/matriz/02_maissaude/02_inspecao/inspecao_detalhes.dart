import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'editar_inspecao.dart';
import 'dados_inspecao.dart';

class InspecaoDetailScreen extends StatefulWidget {
  final Inspecao inspecao;
  final int index;

  const InspecaoDetailScreen(
      {super.key, required this.inspecao, required this.index});

  @override
  InspecaoDetailScreenState createState() => InspecaoDetailScreenState();
}

class InspecaoDetailScreenState extends State<InspecaoDetailScreen> {
  late Inspecao inspecao;

  @override
  void initState() {
    super.initState();
    inspecao = widget.inspecao;
  }

  void _updateInspecao(Inspecao updatedInspecao) {
    setState(() {
      inspecao = updatedInspecao;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = List<String>.from(inspecao.anexos);

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
          actions: [
            Container(
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 104, 55),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final updatedInspecao = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditInspecaoScreen(
                        index: widget.index,
                        initialData: inspecao,
                      ),
                    ),
                  );

                  if (updatedInspecao != null) {
                    _updateInspecao(updatedInspecao);
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
                  const Text(
                    'Tipo de Inspeção:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(inspecao.tipoInspecao),
                  const SizedBox(height: 16),
                  const Text(
                    'Local:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(inspecao.local),
                  const SizedBox(height: 16),
                  const Text(
                    'Descrição:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(inspecao.descricao),
                  const SizedBox(height: 16),
                  const Text(
                    'Data:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(DateFormat('dd/MM/yyyy').format(inspecao.data)),
                  const SizedBox(height: 16),
                  const Text(
                    'Pontos de Verificação:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inspecao.pontos.length,
                    itemBuilder: (ctx, index) {
                      final ponto = inspecao.pontos[index];
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
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Imagens:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  imagePaths.isEmpty
                      ? const Text("Nenhuma imagem selecionada")
                      : Column(
                          children: imagePaths.map((path) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.file(File(path)),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
}
