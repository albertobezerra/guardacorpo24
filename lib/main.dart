import 'package:flutter/material.dart';
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
        dialogStyle: UpgradeDialogStyle.material,
        child: isFirstTime ? const SplashScreen() : const Raiz(),
      ),
    );
  }
}
