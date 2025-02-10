import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/components/onboarding/onboarding.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/firebase_options.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_02_relatorios/report_provider.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class Preferences {
  static Future<bool> get hasCompletedOnboarding async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasCompletedOnboarding') ?? false;
  }

  static Future<bool> get hasShownSplash async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasShownSplash') ?? false;
  }

  static Future<void> setHasCompletedOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', value);
  }

  static Future<void> setHasShownSplash(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShownSplash', value);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  /// Verifica se há atualizações disponíveis.
  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          // Executa a atualização imediata
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          // Executa a atualização flexível
          await InAppUpdate.startFlexibleUpdate();
        } else {
          debugPrint(
              'Atualização disponível, mas não permitida de forma imediata.');
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar atualizações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReportProvider()..loadReports()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Segoe'),
        supportedLocales: const [
          Locale('en', 'US'), // Inglês
          Locale('pt', 'BR'), // Português do Brasil
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FutureBuilder(
          future: Future.wait([
            Preferences.hasCompletedOnboarding,
            Preferences.hasShownSplash,
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(); // Loader temporário
            }
            final hasCompletedOnboarding = snapshot.data![0];
            final hasShownSplash = snapshot.data![1];

            return hasCompletedOnboarding
                ? (hasShownSplash ? const AuthPage() : const SplashScreen())
                : const OnboardingPage();
          },
        ),
      ),
    );
  }
}
