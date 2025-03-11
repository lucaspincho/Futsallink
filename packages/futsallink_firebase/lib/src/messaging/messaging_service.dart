import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../firebase_service.dart';

// Esta função precisa ser definida no nível de arquivo (fora da classe)
// pois precisa ser estática para o Firebase Messaging
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Não é necessário inicializar o Firebase aqui, pois já deve estar inicializado
  print('Handling a background message: ${message.messageId}');
}

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseService().messaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Inicializar serviço de notificações
  Future<void> initialize() async {
    // Solicitar permissão para notificações
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');
    
    // Configurar canal de notificação para Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );
      
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
    
    // Inicializar configurações de notificação local
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // O parâmetro onDidReceiveLocalNotification foi removido em versões recentes
    );
    
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    
    // Configurar handlers para mensagens em diferentes estados
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Registrar o handler de background (já definido como função no nível do arquivo)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Verificar se o app foi aberto a partir de uma notificação em background
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }
  
  // Handler para notificações recebidas com o app em primeiro plano
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showLocalNotification(message);
    }
  }
  
  // Handler para quando o app é aberto a partir de uma notificação
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.data}');
    // Aqui você pode adicionar navegação baseada em dados da notificação
  }
  
  // Handler para quando o app foi iniciado a partir de uma notificação em background
  void _handleInitialMessage(RemoteMessage message) {
    print('App started from notification: ${message.data}');
    // Aqui você pode adicionar navegação baseada em dados da notificação
  }
  
  // Exibir notificação local
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    
    if (notification != null && Platform.isAndroid && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['payload'],
      );
    } else if (notification != null && Platform.isIOS) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['payload'],
      );
    }
  }
  
  // Este método não é mais usado nas versões recentes do flutter_local_notifications
  // Ele foi mantido apenas para referência histórica
  /*
  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('iOS notification received: $id, $title, $body, $payload');
    // Aqui você pode mostrar um diálogo no iOS para versões anteriores ao iOS 10
  }
  */
  
  // Callback para quando usuário toca em uma notificação
  void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped with payload: ${response.payload}');
    // Aqui você pode adicionar navegação baseada no payload
  }
  
  // Obter token FCM
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
  
  // Salvar token no Firestore
  Future<void> saveToken(String uid) async {
    String? token = await getToken();
    if (token != null) {
      // Implementar a lógica para salvar o token no Firestore
      // Por exemplo:
      // await FirebaseFirestore.instance.collection('users').doc(uid).update({
      //   'deviceTokens': FieldValue.arrayUnion([token])
      // });
    }
  }
  
  // Assinar tópico para notificações segmentadas
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }
  
  // Cancelar assinatura de tópico
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}