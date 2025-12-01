import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Make it singleton (optional but recommended)
  static final NotificationService instance = NotificationService._internal();

  
  // public factory constructor
  factory NotificationService() => instance;

  // Private constructor
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localFlutterPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Request permission — CRITICAL for Android 13+ (API 33+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,     // needed for critical alerts (if you ever use them)
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("Permission declined");
      return;
    }

    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("Provisional permission granted");
    }

    // 2. Android: Create high-importance channel (required on Android 8.0+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // must match what you use later
      'High Importance Notifications',
      description: 'Used for prayer alerts and important messages',
      importance: Importance.max, // This makes it show heads-up + sound
      playSound: true,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localFlutterPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(channel);

    // 3. Initialize flutter_local_notifications
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // must exist!

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localFlutterPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // This handles tap when app is in foreground or terminated
        if (response.payload != null) {
          _handleMessageNavigation(response.payload!);
        }
      },
    );

    // 4. Foreground message handler (app open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });


    // background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   

    // background message handler
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      _showForegroundNotification(message);
    });

    // 5. When user taps notification and app opens from background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message.data['route'] ?? '/');
    });

    // Optional: Handle when app was terminated and opened from notification
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage.data['route'] ?? '/');
    }
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final androidDetails = message.notification?.android;

    // Don't show local notification if FCM already showed one (data-only messages)
    if (notification == null) {
      print("Data-only message, skipping local notification");
      return;
    }

    _localFlutterPlugin.show(
      notification.hashCode,
      notification.title ?? 'No Title',
      notification.body ?? 'No Body',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher', // small icon (required!)
          largeIcon: androidDetails?.imageUrl != null
              ? const DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
              : null,
          styleInformation: notification.body != null
              ? BigTextStyleInformation(notification.body!)
              : null,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default.wav',
        ),
      ),
      payload: message.data['route'] ?? '/', // pass route or any data
    );
  }
   
  @pragma('vm:entry-point')    
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      
      // 2. Re-create the notification channel (in case it was cleared)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important scholarship alerts',
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // 3. Show the notification using the exact same look as foreground
      final notification = message.notification;
      if (notification != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'Used for important scholarship alerts',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data['route'],
        );
      }
    }

  void _handleMessageNavigation(String route) {
    // Use Navigator, GoRouter, AutoRoute, etc. here
    // Example with Navigator 2.0:
    // Navigator.of(context).pushNamed(route);
    print("Navigate to: $route");
    // You can use a stream or GetX or any state management to trigger navigation
  }

  // Helper: get FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}