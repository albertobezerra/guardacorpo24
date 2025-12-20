import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:guarda_corpo_2024/theme/app_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class IncendioReco extends StatefulWidget {
  const IncendioReco({super.key});

  @override
  State<IncendioReco> createState() => _IncendioRecoState();
}

class _IncendioRecoState extends State<IncendioReco> {
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
          'RECOMENDAÇÕES',
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
                    'assets/recomendacoes.pdf',
                    key: _pdfViewerKey,
                  ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
