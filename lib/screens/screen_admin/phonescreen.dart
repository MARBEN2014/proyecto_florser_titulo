import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/custom_appbar_welcome.dart';
// Import del Bottom Navigation Bar
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
    // Lista de contactos de la empresa con nombre, teléfono y correo electrónico
    final List<Map<String, String>> contacts = [
      {
        'name': 'Pedro Santivañez',
        'role': 'Gerente General',
        'phone': '+56 9 1234 5678',
        'email': 'p.santivanez@florser.cl'
      },
      {
        'name': 'María López',
        'role': 'Administrador de Local',
        'phone': '+56 9 2345 6789',
        'email': 'm.lopez@florser.cl'
      },
      {
        'name': 'Claudia Pérez',
        'role': 'Secretaria Administrativa',
        'phone': '+56 9 3456 7890',
        'email': 'c.perez@florser.cl'
      },
      {
        'name': 'Juan Torres',
        'role': 'Jefe de Local',
        'phone': '+56 9 4567 8901',
        'email': 'j.torres@florser.cl'
      },
      {
        'name': 'Carla Soto',
        'role': 'Personal de Aseo',
        'phone': '+56 9 5678 9012',
        'email': 'c.soto@florser.cl'
      },
      {
        'name': 'Luis Castro',
        'role': 'Estafeta',
        'phone': '+56 9 6789 0123',
        'email': 'l.castro@florser.cl'
      },
      {
        'name': 'Fernando Rojas',
        'role': 'Guardia de Seguridad',
        'phone': '+56 9 7890 1234',
        'email': 'f.rojas@florser.cl'
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWelcome(), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Título de la sección
              Text(
                'Contactos Importantes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // Columna con Cards personalizadas para cada contacto
              Column(
                children: contacts.map((contact) {
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      height: 140, // Altura ampliada para mayor espacio
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone, // Ícono de teléfono
                            size: 40,
                            color: Colors.blueAccent, // Color llamativo
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  contact['role']!, // Rol del contacto
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            18, // Tamaño de fuente ajustado
                                        color: Colors.black87,
                                      ),
                                ),
                                Text(
                                  contact['name']!, // Nombre del contacto
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 16, // Tamaño ajustado
                                        color: Colors.black54,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  contact['phone']!, // Teléfono
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 16, // Tamaño ajustado
                                        color: AppColors.primary,
                                      ),
                                ),
                                Text(
                                  contact['email']!, // Correo electrónico
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 14, // Tamaño ajustado
                                        color: AppColors.text,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40), // Espaciado adicional
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarAdmin(), // Uso del Bottom Navigation Bar
    );
  }
}
