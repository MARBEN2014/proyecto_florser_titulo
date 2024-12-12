import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart'; // Import del AppBar personalizado

class IndexRolesAdmin extends StatelessWidget {
  const IndexRolesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbarBack(), // Usamos el AppBar con la flecha atrás
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .start, // Cambiado a 'start' para mover hacia arriba
          children: [
            // Espacio superior para mover los botones hacia arriba
            const SizedBox(height: 50),

            // Botón para Gestión de Terapeutas
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón Gestión de Terapeutas
                Navigator.pushNamed(context, '/gestion_terapeutas');
              },
              child: const Text('Cantidad de usarios por rol'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor:
                    AppColors.secondary, // Color de fondo del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40), // Espacio aumentado entre los botones

            // Botón para Gestión de Usuarios
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón Gestión de Usuarios
                Navigator.pushNamed(context, '/telefonos');
              },
              child: const Text('Número telefónicos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor:
                    AppColors.secondary, // Color de fondo del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarAdmin(), // Uso del Bottom Navigation Bar
    );
  }
}
