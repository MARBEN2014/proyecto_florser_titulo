import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
// Import del Bottom Navigation Bar
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_logo.dart';
import 'package:paraflorseer/2%20VISTA/widgets/refresh.dart'; // Import del widget de refresco

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
    return WillPopScope(
      onWillPop: () async => false, // Impide la navegación hacia atrás
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBarLoggedOut(), // Uso del AppBar personalizado
        body: RefreshableWidget(
          onRefresh: _handleRefresh, // Asigna la función de refresco
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 60), // Espacio inicial
                  const Text(
                    'Página de Administrador',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Color negro para el texto
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Espaciado entre el texto y los botones

                  // GridView con dos columnas para los botones
                  GridView.builder(
                    shrinkWrap: true, // Para que no ocupe espacio innecesario
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dos columnas
                      crossAxisSpacing:
                          20.0, // Espacio horizontal entre botones
                      mainAxisSpacing: 20.0, // Espacio vertical entre botones
                      childAspectRatio: 2.5, // Ajuste el tamaño de los botones
                    ),
                    itemCount: 4, // Número total de botones
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          // Navegar a la página correspondiente según el botón
                          switch (index) {
                            case 0:
                              Navigator.pushNamed(context, '/indexCruduser');
                              break;
                            case 1:
                              Navigator.pushNamed(context, '/menuEstadisticas');
                              break;
                            case 2:
                              Navigator.pushNamed(context, '/gestion_roles');
                              break;
                            case 3:
                              Navigator.pushNamed(
                                  context, '/Progreso de citas');
                              break;
                            // case 4:
                            //   Navigator.pushNamed(context, '/agendamiento');
                            //   break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        child: Text(
                          [
                            'Gestión de Usuario',
                            'Estadísticas',
                            'Gestión de roles',
                            'Información de citas',
                            'Horas Agendadas'
                          ][index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),

                  // Sección que centra el último botón "Horas Agendadas"
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/agendamiento');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Horas Agendadas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 150), // Espacio final
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
            const BottomNavBarAdmin(), // Uso del Bottom Navigation Bar
      ),
    );
  }
}
