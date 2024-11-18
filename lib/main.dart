import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/matriz/00_raizes/raiz_mestra.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Upgrader.clearSavedSettings();

  // Verificar se é a primeira vez que o app é aberto
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  // Configurando a barra de status
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Colors.transparent, // Define a barra de status como transparente
    statusBarIconBrightness:
        Brightness.light, // Define os ícones da barra de status como brancos
    statusBarBrightness:
        Brightness.dark, // Define o brilho da barra de status para iOS
    systemNavigationBarColor:
        Colors.white, // Define a cor da barra de navegação
    systemNavigationBarIconBrightness:
        Brightness.dark, // Define os ícones da barra de navegação como escuros
  ));

  runApp(MyApp(isFirstTime: isFirstTime));

  if (isFirstTime) {
    prefs.setBool('isFirstTime', false);
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Segoe'),
      home: UpgradeAlert(
        upgrader: Upgrader(languageCode: 'pt'),
        dialogStyle: UpgradeDialogStyle.material,
        child: isFirstTime ? const SplashScreen() : const Raiz(),
      ),
    );
  }
}
