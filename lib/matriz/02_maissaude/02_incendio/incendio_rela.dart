import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class IncendioRela extends StatefulWidget {
  const IncendioRela({super.key});

  @override
  State<IncendioRela> createState() => _IncendioRelaState();
}

class _IncendioRelaState extends State<IncendioRela> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 20, color: AppTheme.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'RELATÓRIO TÉCNICO DE INCÊNDIO',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
            fontSize: 14,
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
                    'assets/relatorio.pdf',
                    key: _pdfViewerKey,
                  ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
