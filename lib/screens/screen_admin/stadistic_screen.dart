import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
//import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart'; // Import del Bottom Navigation Bar
//import 'package:paraflorseer/widgets/custom_appbar_back.dart';
import 'package:paraflorseer/widgets/custom_appbar_logo.dart';
import 'package:paraflorseer/widgets/refresh.dart'; // Import del widget de refresco

class EstadisticasScreen extends StatelessWidget {
  const EstadisticasScreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un retraso en el refresco
  }

  // Función para manejar la acción de los botones
  void _onButtonPressed(String buttonText) {
    print('Botón "$buttonText" presionado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarLoggedOut(), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60), // Espacio inicial
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Texto "Página de administrador"
                    const Text(
                      'Página de administrador',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Color negro para el texto
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Espaciado entre el texto y el botón

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la página de ranking
                        Navigator.pushNamed(context, '/indexCruduser');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Gestión de Usuario',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado uniforme

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la página de estadísticas
                        Navigator.pushNamed(context, '/ranking');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Estadísticas',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado uniforme

                    ElevatedButton(
                      onPressed: () {
                        // Navega al historial de citas
                        Navigator.pushNamed(context, '/gestion_roles');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Gestión de roles',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado uniforme
                  ],
                ),
              ),
              const SizedBox(height: 150), // Espacio final
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarUser(), // Uso del Bottom Navigation Bar
    );
  }
}
