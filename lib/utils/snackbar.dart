import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String mensaje,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        textAlign: TextAlign.center, // Centra el texto sin usar Center
        style: const TextStyle(
            color: Colors.white), // Asegura visibilidad del texto
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 26, 221, 101),
    ),
  );
}
