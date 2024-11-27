import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_therapist.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de importar el paquete

class SoporteScreen extends StatelessWidget {
  const SoporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          showNotificationButton: false,
          title: '',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Soporte',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),
              const Text('Correo: contacto@florser.cl',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text('Teléfono: +56 9 1234 5678',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text('Dirección: Calle Ejemplo 123, Santiago',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _launchWhatsApp, // Al presionar, llama a _launchWhatsApp
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/whatsapp_icon.png',
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Contactar por WhatsApp',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarUser());
  }

  // Método para abrir WhatsApp
  void _launchWhatsApp() async {
    final String phoneNumber =
        '+56931383006'; // Número de teléfono del centro de soporte
    final String message = 'Hola, necesito ayuda con el servicio de FlorSer';
    final Uri whatsappUrl = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');

    // Verifica si se puede abrir la URL
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl); // Abre la URL en WhatsApp o navegador
    } else {
      throw 'No se pudo abrir $whatsappUrl'; // Manejo de error si no se puede abrir
    }
  }
}
