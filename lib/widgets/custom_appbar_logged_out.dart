import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class CustomAppBarLoggedOut extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarLoggedOut({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding:
            const EdgeInsets.only(left: 20.0), // Controla la separación aquí
        child: SizedBox(
          width: 50, // Ajusta el ancho del botón aquí
          height: 50, // Ajusta la altura del botón aquí
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: AppColors.primary,
                size: 40), // Ajusta el tamaño del icono aquí
            onPressed: () {
              Navigator.pop(
                  context); // Función para ir hacia la pantalla anterior
            },
          ),
        ),
      ),
      title: Image.asset(
        'assets/logo.png',
        height: 90,
      ),
      centerTitle: true,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      toolbarHeight: 90,
      // Sin icono de campanilla, ya que el usuario no está logeado
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
