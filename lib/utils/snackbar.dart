import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String mensaje, {
  Color backgroundColor = const Color.fromARGB(255, 26, 221, 101),
  Duration duration = const Duration(seconds: 3), // Reduce la duración
  SnackBarBehavior behavior = SnackBarBehavior.fixed,
  EdgeInsetsGeometry margin =
      const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
  BorderRadiusGeometry borderRadius =
      const BorderRadius.all(Radius.circular(15)),
  TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  double? width, // Puedes especificar un ancho fijo
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: behavior,
      width: width, // Solo funciona con `SnackBarBehavior.floating`
      margin: behavior == SnackBarBehavior.floating ? margin : null,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      action: SnackBarAction(
        label: 'Cerrar',
        textColor: Colors.white,
        onPressed: () {
          // Acción para cerrar el SnackBar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
