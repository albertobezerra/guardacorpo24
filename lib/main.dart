import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav.dart';
import 'package:guarda_corpo_2024/components/firebase_messaging_service.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/components/onboarding/onboarding.dart';
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

  // Inicializa serviços adicionais
  FirebaseMessagingService messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();

  MobileAds.instance.initialize(); // Inicializa anúncios
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

  static Future<List<bool>> checkOnboardingAndSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasCompletedOnboarding =
        prefs.getBool('hasCompletedOnboarding') ?? false;
    final bool hasShownSplash = prefs.getBool('hasShownSplash') ?? false;
    return [hasCompletedOnboarding, hasShownSplash];
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
    checkForUpdate(); // Verifica se há atualizações disponíveis
  }

  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          InAppUpdate.completeFlexibleUpdate().then((_) {
            debugPrint("Atualização concluída!");
          }).catchError((e) {
            debugPrint("Erro ao finalizar atualização flexível: $e");
          });
        }
      }

      // Define que o splash já foi mostrado após a atualização
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasShownSplash', true);
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
        home: FutureBuilder<List<bool>>(
          future: Preferences.checkOnboardingAndSplash(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SplashScreen(); // Loader temporário
            }

            final hasCompletedOnboarding = snapshot.data![0];
            final hasShownSplash = snapshot.data![1];

            if (!hasCompletedOnboarding) {
              // Usuário não viu o onboarding, exibe-o
              return const OnboardingPage();
            }

            // Verifica se o usuário está logado
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen(); // Carregamento inicial
                }

                if (userSnapshot.hasData) {
                  // Usuário logado, verifica o status da assinatura
                  final User? user = userSnapshot.data;
                  if (user != null) {
                    return FutureBuilder<Map<String, dynamic>>(
                      future: SubscriptionService()
                          .getUserSubscriptionInfo(user.uid),
                      builder: (context, subscriptionSnapshot) {
                        if (subscriptionSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SplashScreen(); // Continua na tela de carregamento
                        }

                        if (subscriptionSnapshot.hasError) {
                          return const AuthPage(); // Redireciona para login em caso de erro
                        }

                        final isPremium =
                            subscriptionSnapshot.data!['isPremium'] ?? false;
                        final planType =
                            subscriptionSnapshot.data!['planType'] ?? '';

                        // Feedback visual sobre o plano
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (isPremium) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Você é premium!')),
                            );
                          } else if (planType == 'ad_free') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Você está livre de publicidade!')),
                            );
                          }
                        });

                        // Redireciona para a tela principal
                        return const UserStatusWrapper(child: NavBarPage());
                      },
                    );
                  }
                }

                // Usuário não logado e splash já foi mostrado
                if (hasShownSplash) {
                  return const AuthPage();
                }

                // Splash ainda não foi mostrado
                return const SplashScreen();
              },
            );
          },
        ),
      ),
    );
  }
}

extension PreferencesCheck on Preferences {
  static Future<List<bool>> checkOnboardingAndSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasCompletedOnboarding =
        prefs.getBool('hasCompletedOnboarding') ?? false;
    final bool hasShownSplash = prefs.getBool('hasShownSplash') ?? false;

    return [hasCompletedOnboarding, hasShownSplash];
  }
}
