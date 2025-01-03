import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:paraflorseer/1%20MODELO/routes/app_routes.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_theme.dart';
import 'package:paraflorseer/3%20CONTROLADOR/firebase_options.dart';
import 'package:paraflorseer/3%20CONTROLADOR/preferencias/pref_usuarios.dart';
import 'package:paraflorseer/3%20CONTROLADOR/services/bloc/localNotification/local_notification.dart';
import 'package:paraflorseer/3%20CONTROLADOR/services/bloc/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuarios.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// manejar la inicializacion de las notificaiones en segundo plano
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// manejar la inicualizacion de las  notificaciones
  await LocalNotification.initializeLocalNotifications(
      onNotificationTap: () {});

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => NotificationsBloc()),
    ],
    child: MyApp(), // llamar una vez vez a ala app
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final prefs = PreferenciasUsuarios();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlorSer App',
      theme: AppTheme.lightTheme, // Aplicamos el tema
      //home: const IndexScreen(), // Pantalla inicial
      initialRoute: PreferenciasUsuarios().ultimaPagina.isNotEmpty
          ? prefs.ultimaPagina
          : '/index', // Establece la ruta inicial
      routes:
          AppRoutes.getRoutes(), // Cargamos las rutas desde el archivo separado
      debugShowCheckedModeBanner: false,
    );
  }
}
