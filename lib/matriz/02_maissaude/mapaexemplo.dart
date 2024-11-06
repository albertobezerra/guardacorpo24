import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../admob/banner_ad_widget.dart';

class Mapaexemplo extends StatelessWidget {
  const Mapaexemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Exemplo do mapa de risco'.toUpperCase(),
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
            image: AssetImage('assets/images/mapa.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.asset(
              'assets/mapaderisco.pdf',
              key: GlobalKey<SfPdfViewerState>(),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
