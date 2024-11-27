import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/body_service/custom_body_cleansing.dart'; // Asegúrate de importar el custom body de cleansing

class CleansingScreen extends StatefulWidget {
  const CleansingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CleansingScreenState createState() => _CleansingScreenState();
}

class _CleansingScreenState extends State<CleansingScreen> {
  // Función para manejar la actualización
  Future<void> _refreshCleansingScreen() async {
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
        title: '',
      ), // AppBar personalizado
      body: RefreshIndicator(
        onRefresh: _refreshCleansingScreen, // Función de actualización
        child:
            const CustomBodyCleansing(), // Cuerpo de la pantalla de Cleansing
      ),
      bottomNavigationBar: const BottomNavBarUser(), // Bottom Navigation Bar
    );
  }
}
