import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class CustomAppBarWelcome extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remueve el icono de back
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
