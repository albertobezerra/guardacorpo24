import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/carregamento/barradecarregamento.dart';

class NrBase extends StatefulWidget {
  final String title;
  final String pdfPath;
  const NrBase({
    super.key,
    required this.title,
    required this.pdfPath,
  });

  @override
  NrBaseState createState() => NrBaseState();
}

class NrBaseState extends State<NrBase> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true; // Declaração de Variável de Estado

  @override
  void initState() {
    super.initState();
    _loadPDF(); // Método chamado na inicialização
  }

  Future<void> _loadPDF() async {
    // Simula um atraso para carregar
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false; // Atualiza o estado após o carregamento
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
          title: Text(
            widget.title.toUpperCase(),
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
            image: AssetImage('assets/images/normas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CustomLoadingIndicator(),
                  )
                : SfPdfViewer.asset(
                    widget.pdfPath,
                    key: _pdfViewerKey,
                  ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
