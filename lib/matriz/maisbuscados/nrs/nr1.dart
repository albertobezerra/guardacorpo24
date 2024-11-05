import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:logger/logger.dart'; // Adicione esta linha

class Nr1 extends StatefulWidget {
  const Nr1({super.key});

  @override
  Nr1State createState() => Nr1State();
}

class Nr1State extends State<Nr1> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  BannerAd? _bannerAd;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    // Crie e carregue o banner ad
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7979689703488774/4117286099',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          logger.i('Ad loaded.'); // Use logger em vez de print
          setState(() {
            // Atualize a UI quando o anúncio for carregado
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          logger.e('Ad failed to load: $error'); // Use logger em vez de print
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff0C5422),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60, left: 30),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 26,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 12,
            child: SfPdfViewer.asset(
              'assets/pdf_nr/nr1.pdf',
              key: _pdfViewerKey,
            ),
          ),
          Flexible(
            flex: 1,
            child: _bannerAd !=
                    null // Adicione este bloco de código para exibir o banner ad
                ? Container(
                    alignment: Alignment.center,
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : const SizedBox(), // Adicione um SizedBox vazio quando o anúncio não está carregado
          ),
        ],
      ),
    );
  }
}
