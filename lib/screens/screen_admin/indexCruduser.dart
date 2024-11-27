import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart'; // Import del Bottom Navigation Bar

class IndexCrudUser extends StatelessWidget {
  const IndexCrudUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppbarBack(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alineación al principio
          children: [
            // Reducimos el espacio superior para acercar los botones al AppBar
            const SizedBox(
                height: 30), // Ajusta el valor para moverlo más cerca

            // Botón para Crear Usuario
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón Crear Usuario
                Navigator.pushNamed(context, '/create_user');
              },
              child: const Text('Crear Usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor:
                    AppColors.secondary, // Color de fondo del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30), // Espacio mayor entre botones

            // Botón para Modificar Usuario
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón Modificar Usuario
                Navigator.pushNamed(context, '/modifyUser');
              },
              child: const Text('Modificar Usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor:
                    AppColors.secondary, // Color de fondo del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30), // Espacio mayor entre botones

            // Botón para Eliminar Usuario
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón Eliminar Usuario
                Navigator.pushNamed(context, '/deleteUser');
              },
              child: const Text('Eliminar Usuario'),
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
          const BottomNavBarUser(), // Uso del Bottom Navigation Bar
    );
  }
}
