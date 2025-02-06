import 'dart:io';

import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';
import 'inspecao_detalhes.dart'; // Importe a tela consolidada

class ViewInspecoes extends StatefulWidget {
  const ViewInspecoes({super.key});

  @override
  ViewInspecoesState createState() => ViewInspecoesState();
}

class ViewInspecoesState extends State<ViewInspecoes> {
  @override
  void initState() {
    super.initState();
    _loadInspecoes();
  }

  Future<void> _loadInspecoes() async {
    final inspecaoProvider =
        Provider.of<InspecaoProvider>(context, listen: false);
    await inspecaoProvider.loadInspecoes();
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
            'INSPEÇÕES'.toUpperCase(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<InspecaoProvider>(
                builder: (context, inspecaoProvider, child) {
                  if (inspecaoProvider.inspecoes.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Nenhuma inspeção encontrada.\nVamos criar sua primeira inspeção?',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    return DefaultTextStyle(
                      style: const TextStyle(fontFamily: 'Segoe'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'SUAS INSPEÇÕES',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Segoe Bold',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: inspecaoProvider.inspecoes.length,
                              itemBuilder: (context, index) {
                                final inspecao =
                                    inspecaoProvider.inspecoes[index];
                                final imagePaths =
                                    List<String>.from(inspecao.anexos);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    elevation: 3,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8.0),
                                      title: Text(
                                        inspecao.tipoInspecao,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DateFormat('dd/MM/yyyy').format(inspecao.data)} - ${inspecao.local}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          if (imagePaths.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Image.file(
                                                File(imagePaths[0]),
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        onSelected: (String result) async {
                                          if (result == 'edit') {
                                            // Redireciona para InspecaoForm no modo de edição
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InspecaoForm(
                                                  index: index,
                                                  initialData: inspecao,
                                                ),
                                              ),
                                            );
                                          } else if (result == 'delete') {
                                            final bool shouldDelete =
                                                await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Excluir Inspeção'),
                                                          content: const Text(
                                                              'Você tem certeza que deseja excluir esta inspeção?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                              child: const Text(
                                                                  'Cancelar'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true),
                                                              child: const Text(
                                                                  'Excluir'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ) ??
                                                    false;

                                            if (shouldDelete) {
                                              inspecaoProvider
                                                  .deleteInspecao(index);
                                            }
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Editar'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        // Redireciona para InspecaoDetailScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                InspecaoDetailScreen(
                                              inspecao: inspecao,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const InspecaoForm(), // Nova inspeção
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 0, 104, 55), // Cor verde
                  shape: const CircleBorder(), // Forma circular
                  padding: const EdgeInsets.all(16), // Espaçamento interno
                  minimumSize: const Size(56, 56), // Tamanho mínimo do botão
                ),
                child: const Icon(
                  Icons.add, // Ícone de adição
                  color: Colors.white, // Cor do ícone
                  size: 28, // Tamanho do ícone
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
