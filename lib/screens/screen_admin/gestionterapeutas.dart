import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/screen_admin/userlistscreen.dart';
import 'package:paraflorseer/widgets/bottom_nav_bra_admin.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
// Import del Bottom Navigation Bar
import 'package:paraflorseer/widgets/refresh.dart'; // Import del widget de refresco
//import 'package:firebase_core/firebase_core.dart';
//import 'user_list_screen.dart'; // Importa la nueva pantalla de usuarios

class GestionTerapeutasScreen extends StatelessWidget {
  const GestionTerapeutasScreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simula un retraso en el refresco
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showNotificationButton: true,
        title: 'Gestión de Terapeutas',
      ), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            }

            // Inicializamos los contadores de roles y las listas de IDs
            int userCount = 0;
            int adminCount = 0;
            int therapistCount = 0;

            List<String> userIds = [];
            List<String> adminIds = [];
            List<String> therapistIds = [];

            // Recorremos los documentos y contamos los roles
            for (var doc in snapshot.data!.docs) {
              String role = doc['role'];
              //String name = doc['name'];
              String id = doc.id; // Se obtiene el ID del documento

              if (role == 'user') {
                userCount++;
                userIds.add(id); // Añadimos el ID del usuario
              } else if (role == 'admin') {
                adminCount++;
                adminIds.add(id); // Añadimos el ID del administrador
              } else if (role == 'therapist') {
                therapistCount++;
                therapistIds.add(id); // Añadimos el ID del terapeuta
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  _buildStatCard(
                    context,
                    'Usuarios',
                    userCount,
                    Icons.person,
                    userIds, // Pasamos los IDs de los usuarios
                  ),
                  const SizedBox(height: 20),
                  _buildStatCard(
                    context,
                    'Administradores',
                    adminCount,
                    Icons.admin_panel_settings,
                    adminIds, // Pasamos los IDs de los administradores
                  ),
                  const SizedBox(height: 20),
                  _buildStatCard(
                    context,
                    'Terapeutas',
                    therapistCount,
                    Icons.healing,
                    therapistIds, // Pasamos los IDs de los terapeutas
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarAdmin(), // Uso del Bottom Navigation Bar
    );
  }

  // Widget para crear una tarjeta estilizada con los datos
  Widget _buildStatCard(BuildContext context, String title, int count,
      IconData icon, List<String> userIds) {
    return GestureDetector(
      onTap: () {
        // Al hacer clic, navega a una nueva pantalla que muestra los usuarios
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserListScreen(
              title: title,
              userIds: userIds,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.blueAccent.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: Colors.blueAccent),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
              Text(
                '$count',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
