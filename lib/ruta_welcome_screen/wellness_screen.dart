import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/body_service/custom_body_wellness.dart'; // Asegúrate de importar el custom body de wellness

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WellnessScreenState createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  // Función para manejar la actualización
  Future<void> _refreshWellnessScreen() async {
    // Simular un retraso
    await Future.delayed(const Duration(seconds: 2));
    // Aquí puedes realizar cualquier acción de actualización, como recargar datos
    setState(() {
      // Actualizar el estado de la pantalla si es necesario
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary, // Color de fondo
      appBar: const CustomAppBar(
        showNotificationButton: true,
      ), // AppBar personalizado
      body: RefreshIndicator(
        onRefresh: _refreshWellnessScreen, // Función de actualización
        child: const CustomBodyWellness(), // Cuerpo de la pantalla de Wellness
      ),
      bottomNavigationBar: const BottomNavBar(), // Bottom Navigation Bar
    );
  }
}
