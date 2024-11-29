import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalnotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationsSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await flutterLocalnotificationsPlugin.initialize(initializationsSettings);
  }

  // await flutterLocalNotificationsPlugin.initialize(
  //     initializationsSettings,
  //     onSelectNotification: (String? payload) async {
  //       // Manejar la selección de la notificación aquí
  //       if (payload != null) {
  //         // Realiza la acción que deseas al seleccionar la notificación
  //         print('Notification payload: $payload');
  //       }
  //     },
  //   );
  // }

  static void iosShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void showLocalNotification(
      {required int id, String? title, String? body, String? data}) {
    const androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName',
        playSound: true, importance: Importance.max, priority: Priority.high);

    const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(presentSound: true, presentAlert: true));

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }
}
