import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';
import 'package:paraflorseer/2%20VISTA/widgets/refresh.dart'; // Import del widget de refresco

class MenuEstadisticasScreen extends StatelessWidget {
  const MenuEstadisticasScreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un retraso en el refresco
  }

  @override
  Widget build(BuildContext context) {
    // Lista de datos para los botones
    final List<Map<String, String>> botones = [
      {
        'texto': 'Terapias más Requeridas',
        'ruta': '/masSolicitadas',
      },
      {
        'texto': 'Terapias menos Requeridas',
        'ruta': '/menosSolicitadas',
      },
      {
        'texto': 'Estadísticas de Terapeutas',
        'ruta': '/EstadisticasTerapeuta',
      },
      {
        'texto': 'Estadísticas Completas',
        'ruta': '/ranking',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBarWelcome(), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60), // Espacio inicial
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Página de Estadísticas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Color negro para el texto
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // GridView para mostrar los botones en dos columnas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    crossAxisSpacing: 20.0, // Espaciado horizontal
                    mainAxisSpacing: 20.0, // Espaciado vertical
                    childAspectRatio:
                        1.5, // Relación de aspecto para los botones
                  ),
                  itemCount: botones.length, // Número de botones
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, botones[index]['ruta']!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        botones[index]['texto']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 150), // Espacio final
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarAdmin(), // Uso del Bottom Navigation Bar
    );
  }
}
