import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../services/admob/conf/banner_ad_widget.dart';

class Mapaexemplo extends StatefulWidget {
  const Mapaexemplo({super.key});

  @override
  MapaexemploState createState() => MapaexemploState();
}

class MapaexemploState extends State<Mapaexemplo> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF006837);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'EXEMPLO DE MAPA DE RISCO',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CustomLoadingIndicator())
                : SfPdfViewer.asset(
                    'assets/mapaderisco.pdf',
                    key: _pdfViewerKey,
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
