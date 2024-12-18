import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Importa la clase LocalNotification

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, required bool showNotificationButton, required String title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remueve el icono de back por defecto
      backgroundColor: AppColors.secondary,
      elevation: 0,
      toolbarHeight: 90,

      // Titulo centrado
      title: Image.asset(
        'assets/logo.png',
        height: 90,
      ),
      centerTitle: true,

      // Icono izquierdo con padding en el Icon, no en el IconButton
      leading: IconButton(
        icon: const Padding(
          padding:
              EdgeInsets.only(left: 20.0), // Solo aplicamos padding al ícono
          child: Icon(Icons.arrow_back, size: 35),
        ),
        color: AppColors.primary,
        onPressed: () {
          Navigator.pop(context); // Navegar atrás
        },
      ),
      actions: [
        IconButton(
          icon: const Padding(
            padding: EdgeInsets.only(
                right: 20.0), // Padding solo al ícono de la derecha
            child: Icon(Icons.notifications, size: 35),
          ),
          color: AppColors.primary,
          onPressed: () {
            // Llamas a la función de notificación desde la clase LocalNotification
            //LocalNotification.showLocalNotification(id: 1);

            Navigator.pushNamed(context,
                '/notifications'); // Navegar a la pantalla de notificaciones
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
