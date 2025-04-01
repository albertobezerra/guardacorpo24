// ignore_for_file: use_build_context_synchronously
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
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final userProvider = UserProvider();
  await userProvider.loadFromCache(); // Carrega dados do cache

  // Inicializa serviços adicionais
  final messagingService = FirebaseMessagingService();
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
    return [
      prefs.getBool('hasCompletedOnboarding') ?? false,
      prefs.getBool('hasShownSplash') ?? false,
    ];
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
  final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  void initState() {
    super.initState();
    _subscriptionService.startPurchaseListener(context, const NavBarPage());
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Atualização disponível. Baixando...')),
          );
        }
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          InAppUpdate.completeFlexibleUpdate().then((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Atualização concluída!')),
              );
            }
          }).catchError((e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao finalizar atualização: $e')),
              );
            }
          });
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasShownSplash', true);
    } catch (e) {
      debugPrint('Erro ao verificar/atualizar: $e');
    }
  }

  Widget getHomePageBasedOnPlan(String planType) {
    return const NavBarPage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InspecaoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Builder(
        builder: (context) {
          // Inicializa o listener do UserProvider após o MultiProvider
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Provider.of<UserProvider>(context, listen: false)
                  .startFirebaseListener(context);
            }
          });
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Segoe',
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              fontFamily: 'Segoe',
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
            ),
            themeMode: ThemeMode.system,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('pt', 'BR'),
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
                  return const OnboardingPage();
                }
                return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen(); // Carregamento inicial
                    }
                    if (userSnapshot.hasData) {
                      final user = userSnapshot.data!;
                      return FutureBuilder<Map<String, dynamic>>(
                        future: _subscriptionService
                            .getUserSubscriptionInfo(user.uid),
                        builder: (context, subscriptionSnapshot) {
                          if (subscriptionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SplashScreen(); // Carregamento do status premium
                          }
                          if (subscriptionSnapshot.hasError) {
                            debugPrint(
                                'Erro ao carregar informações de assinatura: ${subscriptionSnapshot.error}');
                            return Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                        'Ocorreu um erro ao carregar suas informações.'),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {}); // Tenta novamente
                                      },
                                      child: const Text('Tentar Novamente'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          subscriptionSnapshot.data?['isPremium'] ?? false;
                          final planType =
                              subscriptionSnapshot.data?['planType'] ?? '';
                          return UserStatusWrapper(
                            child: getHomePageBasedOnPlan(planType),
                          );
                        },
                      );
                    }
                    if (hasShownSplash) {
                      return const AuthPage();
                    }
                    return const SplashScreen();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
