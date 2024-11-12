import 'package:flutter/material.dart';

class RefreshableWidget extends StatelessWidget {
  final Widget child; // El contenido de la pantalla que se puede refrescar
  final Future<void> Function() onRefresh; // Función de refresco

  const RefreshableWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Para habilitar el scroll en caso de que no haya suficiente contenido
        child: child,
      ),
    );
  }
}
