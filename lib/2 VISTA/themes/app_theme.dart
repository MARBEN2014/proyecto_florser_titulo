import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(color: AppColors.text, fontSize: 20),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.text, fontSize: 16),
    ),
    colorScheme: ColorScheme.light(
      // Utiliza ColorScheme.light o ColorScheme.dark
      primary: AppColors.primary,
      surface: AppColors.background,
    ),
  );
}
