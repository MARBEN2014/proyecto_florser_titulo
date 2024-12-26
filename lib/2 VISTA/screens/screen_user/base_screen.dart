import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_user.dart'; // Import del Bottom Navigation Bar
import 'package:paraflorseer/2%20VISTA/widgets/refresh.dart';
// Import del widget de refresco

class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});

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
        title: '',
      ), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh, // Asigna la función de refresco
        child: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              // Aquí iría el contenido principal de la pantalla
              SizedBox(height: 150),
              SizedBox(height: 40),
              SizedBox(height: 20),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarUser(), // Uso del Bottom Navigation Bar
    );
  }
}
