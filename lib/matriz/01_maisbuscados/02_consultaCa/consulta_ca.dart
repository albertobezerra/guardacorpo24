import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ConsultaCa extends StatefulWidget {
  const ConsultaCa({super.key});

  @override
  State<ConsultaCa> createState() => _ConsultaCaState();
}

class _ConsultaCaState extends State<ConsultaCa> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // Cor principal do tema
  final Color primaryColor = const Color(0xFF006837);

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://meuca.com.br'));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo Clean
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'CONSULTA DE C.A',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          // Botão de Refresh útil para WebViews
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de progresso linear opcional no topo (estilo navegador)
          if (_isLoading)
            LinearProgressIndicator(
              color: primaryColor,
              backgroundColor: Colors.white,
              minHeight: 2,
            ),

          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading) const Center(child: CustomLoadingIndicator()),
              ],
            ),
          ),

          // Anúncio Fixo na base
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }
}
