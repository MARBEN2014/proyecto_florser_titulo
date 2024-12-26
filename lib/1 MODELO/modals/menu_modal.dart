import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
//import 'package:paraflorseer/utils/auth.dart'; // Import de los colores de la app

class MenuModal {
  // Función para mostrar el menú modal flotante
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 0.9, // Ajusta el ancho del menú flotante
          alignment: Alignment
              .centerLeft, // Ubica el menú en la esquina inferior derecha
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ajusta el menú para que se muestre completo
              children: [
                const Text(
                  'Menú',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Terminos y condiciones'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notificaciones'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesion'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, '/login');
                    // Cierra el menú (si es un Drawer, por ejemplo)
                    //Navigator.pop(context);

                    // Llama a la función de cierre de sesión
                    // AuthService authService = AuthService();
                    // await authService.signOut();

                    // Navega a la pantalla de inicio de sesión
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
