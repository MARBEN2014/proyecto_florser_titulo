import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:paraflorseer/firebase_options.dart';
import 'package:paraflorseer/preferencias/pref_usuarios.dart';
import 'package:paraflorseer/services/bloc/localNotification/local_notification.dart';
import 'package:paraflorseer/services/bloc/notifications_bloc.dart';
//import 'package:paraflorseer/screens/index_screen.dart';
//import 'package:paraflorseer/screens/index_screen.dart';
//import 'package:paraflorseer/screens/welcome_screen.dart';

import 'package:paraflorseer/themes/app_theme.dart';
import 'package:paraflorseer/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenciasUsuarios.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// manejar la inicializacion de las notificaiones en segundo plano
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// manejar la inicualizacion de las  notificaciones
  await LocalNotification.initializeLocalNotifications();

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
