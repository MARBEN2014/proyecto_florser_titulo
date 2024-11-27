import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart'; // Import del Bottom Navigation Bar
import 'package:paraflorseer/widgets/refresh.dart'; // Import del widget de refresco

class Phonescreen extends StatelessWidget {
  const Phonescreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un retraso en el refresco
  }

  @override
  Widget build(BuildContext context) {
    // Lista de textos para cada rectángulo
    final List<String> rectangleTexts = [
      'Contacto 1: John Doe',
      'Contacto 2: Jane Smith',
      'Contacto 3: Michael Johnson',
      'Contacto 4: Emily Davis',
      'Contacto 5: Chris Brown',
      'Contacto 6: Pat Taylor',
      'Contacto 7: Alex Lee',
      'Contacto 8: Kim Garcia',
      'Contacto 9: Sam Wilson',
      'Contacto 10: Casey White',
    ];

    // Lista de íconos para cada rectángulo
    final List<IconData> rectangleIcons = [
      Icons.phone,
      Icons.email,
      Icons.contact_page,
      Icons.location_on,
      Icons.access_time,
      Icons.favorite,
      Icons.share,
      Icons.home,
      Icons.business,
      Icons.event,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showNotificationButton: true,
        title: 'Pantalla de Contactos',
      ), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Título de la sección
              Text(
                'Lista de Contactos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // Columna con 10 Cards personalizadas
              Column(
                children: List.generate(10, (index) {
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            rectangleIcons[index], // Ícono dinámico
                            size: 40,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            rectangleTexts[index], // Texto dinámico
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40), // Espaciado adicional
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarUser(), // Uso del Bottom Navigation Bar
    );
  }
}
