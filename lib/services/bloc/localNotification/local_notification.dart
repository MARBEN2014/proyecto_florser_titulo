import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  // Solicitar permisos de notificaciones locales
  static Future<void> requestPermissionLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  // Método de inicialización de notificaciones locales
  static Future<void> initializeLocalNotifications(
      {required void Function() onNotificationTap}) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings(
        'logoapp'); // Este es el icono que se quiere mostrar cuando llegue la notificación local

    // Para inicializar con iOS
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Método para inicializar iOS
  static void iosShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  // Crear y mostrar la notificación
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

    // Mostrar la notificación con el id único
    flutterLocalNotificationsPlugin.show(
        id, // Usamos id dinámico para mostrar diferentes notificaciones
        title ?? 'Notificación desde FlorSer',
        body ??
            'Tu cita fue agendada con éxito, visita la sección "Mis citas" para más detalles.',
        notificationDetails);
  }

  // Ejemplo de cómo usar múltiples mensajes
  static void showAppointmentNotification() {
    showLocalNotification(
      id: 1, // Este es un id único para la notificación de cita
      title: '¡Cita confirmada!',
      body:
          'Tu cita con el terapeuta ha sido confirmada. Visita "Mis citas" para más detalles.',
    );
  }

  static void showReminderNotification() {
    showLocalNotification(
      id: 2, // Otro id único para recordatorios
      title: 'Recordatorio de cita',
      body: 'No olvides tu cita mañana a las 10:00 AM. ¡Te esperamos!',
    );
  }

  static void showPromoNotification() {
    showLocalNotification(
      id: 3, // Id para una notificación de promoción
      title: '¡Promoción Especial!',
      body: '¡Descuento del 20% en tu próxima terapia! Solo por esta semana.',
    );
  }
}
