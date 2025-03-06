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
            'Inspeções'.toUpperCase(),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30.0, top: 30.0, right: 30.0),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Segoe',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Esta seção permite que você visualize e gerencie suas inspeções. As inspeções ajudam a identificar e avaliar problemas, promovendo a saúde e a segurança no local de trabalho.\n\n',
                          ),
                          TextSpan(
                            text: 'Funções das Inspeções:\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                '• Visualizar Inspeções: Veja a descrição, data e local das inspeções realizadas.\n'
                                '• Editar Inspeções: Atualize as informações das inspeções existentes.\n'
                                '• Excluir Inspeções: Remova inspeções desatualizadas ou incorretas.\n\n',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Consumer<InspecaoProvider>(
                    builder: (context, inspecaoProvider, child) {
                      if (inspecaoProvider.inspecoes.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Nenhuma inspeção encontrada.\nVamos criar sua primeira inspeção?',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return DefaultTextStyle(
                          style: const TextStyle(
                            fontFamily: 'Segoe',
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'SUAS INSPEÇÕES',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Segoe Bold',
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 104, 55),
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
                                        List.from(inspecao.anexos);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        elevation: 0,
                                        color: const Color.fromARGB(
                                            0, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 0, 104, 55),
                                              width: 2.0,
                                            )),
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(16.0),
                                          title: Text(
                                            inspecao.tipoInspecao,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 0, 104, 55),
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
                                                  color: Color.fromARGB(
                                                      255, 0, 104, 55),
                                                ),
                                              ),
                                              if (imagePaths.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Image.file(
                                                    File(imagePaths[0]),
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
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
                ],
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
                      builder: (context) => const InspecaoForm(
                        index: null,
                        initialData: null,
                      ),
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
          const Center(child: ConditionalBannerAdWidget()),
        ],
      ),
    );
  }
}
