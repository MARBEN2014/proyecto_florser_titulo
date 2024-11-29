import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:paraflorseer/preferencias/pref_usuarios.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  // crear la instancia cde firemessaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(NotificationsInitial()) {
    _onForegroundMessage(); // esta al pendiente de las notificaion push
    // });
  }
  // primero se debe acxeptar los permisios de las notificaiones desde el usuario de notirifcaion push
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);

    // saber si fue aceptada o no la autorizacion de las mnotificaciones
    settings.authorizationStatus;
    _getToken(); // privada para que solo se puedda llamar desde aca
  }

  // Metodo para obtener el token con una nueva

  void _getToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized)
      return; // no devueklve el token ya que la autorizacion de recivir notificaiones no fue aceptada

    // si tengo un token lo guardo en prefs de usuarios
    // el token se debe guardar por usuario en la base de datos
    final token = await messaging.getToken();
    if (token != null) {
      final prefs = PreferenciasUsuarios();
      prefs.token =
          token; //guardara este valor en la base de datos en un arraglo [array], desde el comienzo
    }
    // para guardar los token de los usarios en la base de datos y crera un aareglo con ellos
    // FirebaseFirestore.instance.doc('').update({'token':ArrayConfig.values})
  }

// cuando la aplicacion esta en primer plano
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

// metodo para gestionar los mensajes
  void handleRemoteMessage(RemoteMessage message) {
    var mensaje = message.data;
    print(message); // esta es la instancia del mensaje
    print(message.data); // aca va la imnformacion del mensaje
    var title = mensaje['title'];
    var body = mensaje['body'];

    print(title);
    print(body);
    // hasta este punto ya se sta recibiendo data desde firebase message , pero se debe mostrar en la local notifications
  }
}
