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
        return Dialog(
          child: Image.file(File(imagemPath)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        initialData: _inspecao,
                      ),
                    ),
                  );

                  if (updatedInspecao != null) {
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
                  const Text(
                    'Tipo de Inspeção:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_inspecao.tipoInspecao),
                  const SizedBox(height: 16),
                  const Text(
                    'Local:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_inspecao.local),
                  const SizedBox(height: 16),
                  const Text(
                    'Data:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(DateFormat('dd/MM/yyyy').format(_inspecao.data)),
                  const SizedBox(height: 16),
                  const Text(
                    'Pontos de Verificação:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(ponto['descricao']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ponto['conforme']
                                  ? 'Conforme'
                                  : 'Inconforme: ${ponto['inconformidade']}'),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: imagensPonto.map((imagemPath) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _visualizarImagem(context, imagemPath),
                                    child: Image.file(
                                      File(imagemPath),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
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
    );
  }
}
