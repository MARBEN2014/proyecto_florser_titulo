import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';

class CustomAppBarWelcome extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Padding(
          padding: EdgeInsets.only(left: 20.0), // Aplica padding solo al icono
          child: Icon(
            Icons.arrow_back,
            size: 35,
          ),
        ),
        color: AppColors.primary, // Ajusta el color del icono
        onPressed: () {
          Navigator.pop(context); // Navegar atrás
        },
      ),
      title: Image.asset(
        'assets/logo.png',
        height: 90,
      ),
      centerTitle: true,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      toolbarHeight: 90,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
