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
    const Color primary = Color.fromARGB(255, 0, 104, 55);

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
        title: const Text(
          'INSPEÇÕES',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<InspecaoProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Texto introdutório
                      const Text(
                        'Gerencie suas inspeções',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aqui você pode criar, visualizar, editar e excluir inspeções realizadas no ambiente de trabalho.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (provider.inspecoes.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 32),
                            child: Text(
                              'Nenhuma inspeção encontrada.\nVamos criar sua primeira inspeção?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else ...[
                        const Text(
                          'Suas inspeções',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
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

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  inspecao.tipoInspecao,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('dd/MM/yyyy').format(inspecao.data)} • ${inspecao.local}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (primeiraFoto != null) ...[
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(primeiraFoto),
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            height: 110,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => InspecaoDetailScreen(
                                      inspecao: inspecao,
                                      index: index,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Botão adicionar + banner
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InspecaoForm(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(56, 56),
                ),
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
