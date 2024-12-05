import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar para interactuar con Firestore
import 'package:paraflorseer/preferencias/pref_usuarios.dart';
import 'package:paraflorseer/services/bloc/localNotification/local_notification.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

// para mostrar las notificaciones en segundo plano se debe poner en el main
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var mensaje = message.data;
  var title = mensaje['title'];
  var body = mensaje['body'];
  // Crear un valor superior a 1 para que entregue valores aleatorios sobre 1
  Random random = Random();
  var id = random.nextInt(100000);

  LocalNotification.showLocalNotification(id: id, title: title, body: body);
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  // Crear la instancia de FirebaseMessaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(NotificationsInitial()) {
    _onForegroundMessage(); // Estar al pendiente de las notificaciones push
  }

  // Primero se debe aceptar los permisos de las notificaciones desde el usuario de notificaciones push
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);
    // Permiso para utilizar notificaciones locales
    await LocalNotification.requestPermissionLocalNotifications();

    // Saber si fue aceptada o no la autorización de las notificaciones
    settings.authorizationStatus;
    _getToken(); // Privada para que solo se pueda llamar desde acá
  }

  // Método para obtener el token con una nueva
  void _getToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    // Si no está autorizado para recibir notificaciones no se devuelve el token

    // Si tengo un token lo guardo en prefs de usuarios
    final token = await messaging.getToken();
    if (token != null) {
      final prefs = PreferenciasUsuarios();
      prefs.token =
          token; // Guardará este valor en la base de datos en un arreglo [array], desde el comienzo

      // Obtener el UID del usuario
      final String uid = prefs
          .ultimouid; // Asumiendo que tienes un método para obtener el UID del usuario desde preferencias.

      // Guardar el token en Firestore, en la colección 'user' bajo el documento del usuario.
      await _saveTokenToFirestore(uid, token);
    }
  }

  // Método para guardar el token en Firestore
  Future<void> _saveTokenToFirestore(String uid, String token) async {
    try {
      // Obtener la referencia del documento del usuario
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('user').doc(uid);

      // Actualizar el array `tokens` añadiendo el nuevo token
      await userDocRef.update({
        'tokens': FieldValue.arrayUnion([token]) // Agrega solo si no existe
      });

      print("Token guardado correctamente para el usuario $uid");
    } catch (e) {
      if (e.toString().contains("NOT_FOUND")) {
        // Si el documento no existe, lo creamos con el token inicial
        try {
          await FirebaseFirestore.instance.collection('user').doc(uid).set({
            'tokens': [token],
          });
          print("Documento creado para el usuario $uid con el token inicial.");
        } catch (e) {
          print("Error al crear el documento en Firestore: $e");
        }
      } else {
        print("Error al guardar el token en Firestore: $e");
      }
    }
  }

  // Cuando la aplicación está en primer plano
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  // Método para gestionar los mensajes
  void handleRemoteMessage(RemoteMessage message) {
    // Aquí se hace la unión con la localNotification
    var mensaje = message.data;
    var title = mensaje['title'];
    var body = mensaje['body'];
    // Crear un valor aleatorio para el ID
    Random random = Random();
    var id = random.nextInt(100000);

    LocalNotification.showLocalNotification(id: id, title: title, body: body);
    // Estos print son para ver si la información está llegando y visualizarla por consola
    print(message); // Esta es la instancia del mensaje
    print(message.data); // Aquí va la información del mensaje
    print(title);
    print(body);
    // Hasta este punto ya se está recibiendo data desde Firebase Messaging, pero se debe mostrar en la local notifications
  }
}
