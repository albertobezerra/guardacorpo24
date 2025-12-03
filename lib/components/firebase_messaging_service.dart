// lib/components/firebase_messaging_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';

// Handler em background PRECISA ser top-level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Mensagem FCM em background: ${message.messageId}');
}

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1) Configura handler de background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2) Inicializa notificações locais (para foreground)
    await _initLocalNotifications();

    // 3) Solicita permissão (Android 13+ / iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Permissão FCM: ${settings.authorizationStatus}');

    // 4) (Opcional) pega token para testes
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // 5) Ouve mensagens com app em foreground
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 6) Ouve quando usuário toca na notificação
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Aqui você pode navegar para uma tela específica, se quiser
        // final context = navigatorKey.currentContext;
        // if (context != null) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (_) => const AlgumaTela(),
        //   ));
        // }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'sst_channel',
      'Segurança do Trabalho',
      description: 'Notificações do app Segurança do Trabalho',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _onMessage(RemoteMessage message) {
    // Mostra notificação local quando app está aberto
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'sst_channel',
      'Segurança do Trabalho',
      channelDescription: 'Notificações do app Segurança do Trabalho',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['route'], // se quiser passar rota
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Usuário clicou na notificação: ${message.messageId}');
    // Exemplo: navegar para alguma tela baseada em "route" vinda nos dados
    // final route = message.data['route'];
    // final context = navigatorKey.currentContext;
    // if (route != null && context != null) {
    //   Navigator.of(context).pushNamed(route);
    // }
  }
}
