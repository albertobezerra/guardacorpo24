import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guarda_corpo_2024/firebase_options.dart';
import 'package:guarda_corpo_2024/services/notifications/notification_router.dart';

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

    // 4) Pega token para testes
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // 5) Ouve mensagens com app em foreground
    FirebaseMessaging.onMessage.listen(_onMessage);

    // 6) Ouve quando usuário toca na notificação (app em background)
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // 7) Verifica se o app foi aberto via notificação (app estava fechado)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App aberto via notificação: ${initialMessage.messageId}');
      // Aguarda um frame para garantir que o navigator está pronto
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationNavigation(initialMessage.data);
      });
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Quando usuário toca na notificação local (foreground)
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(details.payload!) as Map<String, dynamic>;
            debugPrint('Notification tapped with payload: $data');
            handleNotificationNavigation(data);
          } catch (e) {
            debugPrint('Erro ao processar payload: $e');
          }
        }
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

    debugPrint('Notificação recebida em foreground: ${message.messageId}');

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
      payload: jsonEncode(message.data), // passa dados como JSON
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint(
        'Usuário clicou na notificação (app em background): ${message.messageId}');
    handleNotificationNavigation(message.data);
  }
}
