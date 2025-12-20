import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_form.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_provider.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dados_inspecao.dart';
import 'image_gallery.dart';

class InspecaoDetailScreen extends StatefulWidget {
  final Inspecao inspecao;
  final int index;

  const InspecaoDetailScreen({
    super.key,
    required this.inspecao,
    required this.index,
  });

  @override
  State<InspecaoDetailScreen> createState() => _InspecaoDetailScreenState();
}

class _InspecaoDetailScreenState extends State<InspecaoDetailScreen> {
  late Inspecao _inspecao;

  @override
  void initState() {
    super.initState();
    _inspecao = widget.inspecao;
  }

  void _abrirGaleria(List<String> imagens, int index) {
    if (imagens.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGallery(
          imagePaths: imagens,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color.fromARGB(255, 0, 104, 55);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'DETALHES DA INSPEÇÃO',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black87),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InspecaoForm(
                    index: widget.index,
                    initialData: _inspecao,
                  ),
                ),
              );
              if (updated is Inspecao && mounted) {
                setState(() => _inspecao = updated);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Cabeçalho
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _infoField(
                        'Tipo de Inspeção:',
                        _inspecao.tipoInspecao,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _infoField('Local:', _inspecao.local),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _infoField(
                  'Data:',
                  DateFormat('dd/MM/yyyy').format(_inspecao.data),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pontos de Verificação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Lista de pontos
          Expanded(
            child: _inspecao.pontos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum ponto de verificação adicionado.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _inspecao.pontos.length,
                    itemBuilder: (ctx, i) {
                      final ponto = _inspecao.pontos[i];
                      final imagens = List<String>.from(ponto['imagens'] ?? []);

                      final bool conforme = ponto['conforme'] == true;
                      final String statusText = conforme
                          ? 'Conforme'
                          : 'Inconforme: ${ponto['inconformidade'] ?? ''}';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ponto['descricao'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: conforme
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (imagens.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        imagens.asMap().entries.map((entry) {
                                      final idx = entry.key;
                                      final path = entry.value;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: () =>
                                              _abrirGaleria(imagens, idx),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: primary,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Image.file(
                                                File(path),
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
                      );
                    },
                  ),
          ),

          // Botão excluir + banner
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _confirmarExclusao,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                minimumSize: const Size(48, 48),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 24),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmarExclusao() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Inspeção'),
        content: const Text('Esta ação não pode ser desfeita.'),
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

    if (confirm != true || !mounted) return;

    await Provider.of<InspecaoProvider>(context, listen: false)
        .deleteInspecao(widget.index);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspeção excluída')),
    );
    Navigator.pop(context);
  }
}
