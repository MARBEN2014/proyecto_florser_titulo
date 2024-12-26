import 'package:flutter/material.dart';
import 'package:paraflorseer/1%20MODELO/body_service/custom_body_guide.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  // Función para manejar la actualización
  Future<void> _refreshGuideScreen() async {
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
        onRefresh: _refreshGuideScreen, // Función de actualización
        child: const CustomBodyGuide(), // Cuerpo de la pantalla
      ),
      bottomNavigationBar: const BottomNavBarUser(), // Bottom Navigation Bar
    );
  }
}
