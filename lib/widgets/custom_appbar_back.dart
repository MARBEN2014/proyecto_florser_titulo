import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class CustomAppbarBack extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbarBack({super.key});

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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
