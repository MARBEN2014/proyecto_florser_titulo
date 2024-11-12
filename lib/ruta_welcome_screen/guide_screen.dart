import 'package:flutter/material.dart';
import 'package:paraflorseer/body_service/custom_body_guide.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/themes/app_colors.dart';

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
      appBar: const CustomAppBar(), // AppBar personalizado
      body: RefreshIndicator(
        onRefresh: _refreshGuideScreen, // Función de actualización
        child: const CustomBodyGuide(), // Cuerpo de la pantalla
      ),
      bottomNavigationBar: const BottomNavBar(), // Bottom Navigation Bar
    );
  }
}
