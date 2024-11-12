// app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle appBarTextStyle = GoogleFonts.lato(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle bodyTextStyle = GoogleFonts.lato(
    color: Color.fromARGB(221, 7, 7, 7),
    fontSize: 18,
  );
}
