import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/components/firebase_messaging_service.dart';
import 'package:guarda_corpo_2024/components/onboarding/onboarding.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/firebase_options.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_provider.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/UserStatusWrapper.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
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
  FirebaseMessagingService messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();

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

  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          // Após o download, solicita ao usuário que reinicie o app
          InAppUpdate.completeFlexibleUpdate().then((_) {
            debugPrint("Atualização concluída!");
          }).catchError((e) {
            debugPrint("Erro ao finalizar atualização flexível: $e");
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao verificar/atualizar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InspecaoProvider()),
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

            return UserStatusWrapper(
              child: hasCompletedOnboarding
                  ? (hasShownSplash ? const AuthPage() : const SplashScreen())
                  : const OnboardingPage(),
            );
          },
        ),
      ),
    );
  }
}
