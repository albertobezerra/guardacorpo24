// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav.dart';
import 'package:guarda_corpo_2024/components/barradenav/nav_station.dart';
import 'package:guarda_corpo_2024/components/firebase_messaging_service.dart';
import 'package:guarda_corpo_2024/components/autenticacao/auth_page.dart';
import 'package:guarda_corpo_2024/components/onboarding/onboarding.dart';
import 'package:guarda_corpo_2024/firebase_options.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/inspecao_provider.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';
import 'package:guarda_corpo_2024/services/provider/userProvider.dart';
import 'package:guarda_corpo_2024/services/review/review_service.dart';
import 'package:guarda_corpo_2024/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final userProvider = UserProvider();
  await userProvider.loadFromCache();

  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();

  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();

  MobileAds.instance.initialize();

  // Configuração global da status bar e navigation bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Fundo branco
    statusBarIconBrightness: Brightness.dark, // Ícones pretos
    statusBarBrightness: Brightness.light, // Para iOS: fundo claro
    systemNavigationBarColor: Colors.white, // Navigation bar branca
    systemNavigationBarIconBrightness: Brightness.dark, // Ícones pretos
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
    // Adiciona a verificação de review após o init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestReview();
    });
  }

  Future<void> _checkAndRequestReview() async {
    try {
      // Só solicita review se o usuário completou o onboarding
      final hasCompletedOnboarding = await Preferences.hasCompletedOnboarding;
      if (hasCompletedOnboarding && await ReviewService.shouldRequestReview()) {
        await ReviewService.requestReview();
      }
    } catch (e) {
      debugPrint('Erro ao solicitar review: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InspecaoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavigationState()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Segoe',
          brightness: Brightness.light,
          primarySwatch: createMaterialColor(
              const Color(0xFF9D291A)), // Cor principal do app
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF9D291A),
            foregroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Segoe',
          brightness: Brightness.dark,
          primarySwatch: createMaterialColor(const Color(0xFF9D291A)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF9D291A),
            foregroundColor: Colors.white,
          ),
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
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Provider.of<UserProvider>(context, listen: false)
                    .startFirebaseListener(context);
              }
            });
            return FutureBuilder<List<bool>>(
              future: Preferences.checkOnboardingAndSplash(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SplashScreen();
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
                      return const SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      final user = userSnapshot.data!;
                      return FutureBuilder<Map<String, dynamic>>(
                        future: _subscriptionService
                            .getUserSubscriptionInfo(user.uid),
                        builder: (context, subscriptionSnapshot) {
                          if (subscriptionSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SplashScreen();
                          }
                          if (subscriptionSnapshot.hasError) {
                            return Scaffold(
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                        'Ocorreu um erro ao carregar suas informações.'),
                                    ElevatedButton(
                                      onPressed: () => setState(() {}),
                                      child: const Text('Tentar Novamente'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const NavBarPage();
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
            );
          },
        ),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Função para criar MaterialColor personalizado
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  // ignore: deprecated_member_use
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  // ignore: deprecated_member_use
  return MaterialColor(color.value, swatch);
}
