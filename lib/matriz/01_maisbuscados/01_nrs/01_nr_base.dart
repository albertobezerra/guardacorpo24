import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importe Google Fonts
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Reduzi para 1s para ser mais ágil
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // APP BAR MODERNA
      appBar: AppBar(
        title: Text(
          // Tenta extrair apenas "NR XX" se o título for muito longo, senão mostra tudo
          widget.title.length > 20
              ? "${widget.title.substring(0, 15)}..."
              : widget.title,
          style: GoogleFonts.poppins(
              color: const Color(0xFF2D3436),
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Leve sombra para separar do PDF
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CustomLoadingIndicator())
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
