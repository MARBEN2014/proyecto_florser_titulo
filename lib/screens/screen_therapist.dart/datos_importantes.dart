import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_therapist.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // AppBar personalizado
//import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart'; // Bottom Navigation Bar
import 'package:paraflorseer/widgets/refresh.dart'; // Widget de refresco

class TherapistProfileScreen extends StatelessWidget {
  const TherapistProfileScreen({super.key});

  // Función de refresco simulada
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Perfil del Terapeuta",
        showNotificationButton: true,
      ),
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Imagen de perfil del terapeuta
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/therapist.jpg'),
                ),
                const SizedBox(height: 20),
                // Nombre del terapeuta
                const Text(
                  "Dr. Mariana López",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                // Especialización
                const Text(
                  "Especialista en Terapias Holísticas y Reiki",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                // Descripción del terapeuta
                const Text(
                  "Con más de 10 años de experiencia, la Dra. Mariana López se ha dedicado a ayudar a las personas a alcanzar el bienestar físico, mental y espiritual a través de terapias holísticas personalizadas.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Información adicional
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text("Email: mariana.lopez@example.com"),
                ),
                const ListTile(
                  leading: Icon(Icons.phone, color: Colors.green),
                  title: Text("Teléfono: +56 9 1234 5678"),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Colors.red),
                  title: Text("Ubicación: Santiago, Chile"),
                ),
                const Divider(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarTherapist(),
    );
  }
}
