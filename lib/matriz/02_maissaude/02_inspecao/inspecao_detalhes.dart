import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dados_inspecao.dart';

class InspecaoDetailScreen extends StatelessWidget {
  final Inspecao inspecao;

  const InspecaoDetailScreen(
      {super.key, required this.inspecao, required int index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Inspeção'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${inspecao.tipoInspecao}'),
            Text('Data: ${DateFormat('dd/MM/yyyy').format(inspecao.data)}'),
            Text('Local: ${inspecao.local}'),
            Text('Descrição: ${inspecao.descricao}'),
            if (inspecao.pontos.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pontos Verificados:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...inspecao.pontos.map(
                    (ponto) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descrição: ${ponto['descricao']}'),
                          Text(
                              'Conforme: ${ponto['conforme'] ? 'Sim' : 'Não'}'),
                          if (!ponto['conforme'])
                            Text('Inconformidade: ${ponto['inconformidade']}'),
                          if (ponto['imagem'] != null)
                            Image.file(
                              File(ponto['imagem']),
                              width: 100,
                              height: 100,
                            ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            if (inspecao.anexos.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Anexos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...inspecao.anexos.map(
                    (anexo) {
                      return Image.file(File(anexo));
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
