import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/admob/banner_ad_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class NhoBase extends StatefulWidget {
  final String title;
  final String pdfPath;
  const NhoBase({
    super.key,
    required this.title,
    required this.pdfPath,
  });
  @override
  State<NhoBase> createState() => _NhoBaseState();
}

class _NhoBaseState extends State<NhoBase> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

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
              fontFamily: 'Segoe',
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
            child: SfPdfViewer.asset(
              widget.pdfPath, // Use o caminho do PDF passado
              key: _pdfViewerKey,
            ),
          ),
          const BannerAdWidget(), // Mantém o BannerAdWidget fixo na parte inferior
        ],
      ),
    );
  }
}
