import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OrdemExemplo extends StatefulWidget {
  const OrdemExemplo({super.key});

  @override
  State<OrdemExemplo> createState() => OrdemExemploState();
}

class OrdemExemploState extends State<OrdemExemplo> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
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
            'Exemplo de ordem de Serviço'.toUpperCase(),
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
            image: AssetImage('assets/images/menu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CustomLoadingIndicator())
                : SfPdfViewer.asset(
                    'assets/os.pdf',
                    key: _pdfViewerKey,
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
