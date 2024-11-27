import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_therapist.dart';
import 'package:paraflorseer/widgets/custom_appbar_logo.dart';
import 'package:paraflorseer/widgets/refresh.dart'; // Import del widget de refresco

class TherapistScreen extends StatelessWidget {
  const TherapistScreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un retraso en el refresco
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
                    // Texto "Página de Terapeuta"
                    const Text(
                      'Página de Terapeuta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Color negro para el texto
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Espaciado entre el texto y el primer botón

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la página de horas agendadas
                        Navigator.pushNamed(context, '/horas_terapeuta');
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
                        'Horas Agendadas',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado uniforme

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la página de datos importantes
                        Navigator.pushNamed(context, '/datos_terapeutas');
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
                        'Datos importantes',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        // Navega a la página de datos importantes
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
                        'Historial del usuario',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),

                    // Espaciado uniforme
                  ],
                ),
              ),
              const SizedBox(height: 150), // Espacio final
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarTherapist(), // Uso del Bottom Navigation Bar
    );
  }
}
