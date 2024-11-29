import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  //solicitar permisos de notificaiones locales
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  //metodo de inicializacion de notificaiones locales
  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings(
        'logoapp'); // este es el icono que se quieremostrar cuando llegue la notificaio local

    // // para inicualizar con Ios
    // const initializationSettingsDarwin = DarwinInitializationSettings(
    //   onDidReceiveLocalNotification: iosShowNotification);

    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

// Metodo para inicilaizar IOs
  static void iosShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  // crear mostrar la notificaion
  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
        'ChannelID', 'channelName',
        playSound: true, importance: Importance.max, priority: Priority.high);

    const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(presentSound: true, presentAlert: true));

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // esto es lo que pide el local notifications y el metodo que permite mostrarla estos pararmetros se crean en
    // static void showLocalNotification
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }
}
