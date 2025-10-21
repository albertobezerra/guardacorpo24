// lib/matriz/02_maissaude/02_inspecao/view_inspecoes.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_detalhes.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_form.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'inspecao_provider.dart';

class ViewInspecoes extends StatefulWidget {
  const ViewInspecoes({super.key});

  @override
  State<ViewInspecoes> createState() => _ViewInspecoesState();
}

class _ViewInspecoesState extends State<ViewInspecoes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InspecaoProvider>(context, listen: false).loadInspecoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text('INSPEÇÕES',
              style: TextStyle(
                  fontFamily: 'Segoe Bold', color: Colors.white, fontSize: 16)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
          flexibleSpace: const Image(
              image: AssetImage('assets/images/inspecao.jpg'),
              fit: BoxFit.cover),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                            fontFamily: 'Segoe',
                            fontSize: 14,
                            color: Colors.black),
                        children: [
                          TextSpan(
                              text:
                                  'Esta seção permite que você visualize e gerencie suas inspeções. As inspeções ajudam a identificar e avaliar problemas, promovendo a saúde e a segurança no local de trabalho.\n\n'),
                          TextSpan(
                              text: 'Funções das Inspeções:\n\n',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  '• Visualizar Inspeções\n• Editar Inspeções\n• Excluir Inspeções\n\n'),
                        ],
                      ),
                    ),
                  ),
                  Consumer<InspecaoProvider>(
                    builder: (context, provider, child) {
                      if (provider.inspecoes.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                                'Nenhuma inspeção encontrada.\nVamos criar sua primeira inspeção?',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                                textAlign: TextAlign.center),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text('SUAS INSPEÇÕES',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Segoe Bold',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 104, 55))),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.inspecoes.length,
                              itemBuilder: (context, index) {
                                final inspecao = provider.inspecoes[index];
                                String? primeiraFoto;
                                if (inspecao.pontos.isNotEmpty) {
                                  final imagens =
                                      inspecao.pontos[0]['imagens'] as List?;
                                  if (imagens != null && imagens.isNotEmpty) {
                                    primeiraFoto = imagens[0] as String;
                                  }
                                }

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 0, 104, 55),
                                          width: 2)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(inspecao.tipoInspecao,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 0, 104, 55))),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${DateFormat('dd/MM/yyyy').format(inspecao.data)} - ${inspecao.local}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 0, 104, 55))),
                                        if (primeiraFoto != null) ...[
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                                File(primeiraFoto),
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                        height: 100,
                                                        color: Colors.grey[300],
                                                        child: const Icon(
                                                            Icons.broken_image,
                                                            color:
                                                                Colors.grey))),
                                          ),
                                        ],
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                InspecaoDetailScreen(
                                                    inspecao: inspecao,
                                                    index: index))),
                                  ),
                                );
                              },
                            ),
                          ],
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
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const InspecaoForm())),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 104, 55),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(56, 56)),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
