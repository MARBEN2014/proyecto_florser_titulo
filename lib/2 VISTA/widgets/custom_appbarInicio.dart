import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';

class CustomAppBarInicio extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
