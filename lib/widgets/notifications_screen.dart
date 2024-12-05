import 'package:flutter/material.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart';
//import 'package:paraflorseer/widgets/custom_app_bar.dart';
//import 'package:paraflorseer/widgets/custom_appbar_logo.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbarBack(), // Uso del AppBar personalizado
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
              16.0), // Ajuste de padding para margen de contenido
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20), // Espacio debajo del título

              // Lista de notificaciones
              NotificationTile(
                title: 'Cita confirmada',
                message:
                    'Tu cita de Reiki ha sido confirmada para el 10 de octubre a las 10:00 AM.',
              ),
              NotificationTile(
                title: 'Promoción de octubre',
                message:
                    '¡Aprovecha nuestra promoción de masaje craneal con 20% de descuento!',
              ),
              NotificationTile(
                title: 'Recordatorio',
                message:
                    'Tu sesión de Yoga está programada para mañana a las 9:00 AM.',
              ),
              NotificationTile(
                title: 'Nueva terapia disponible',
                message:
                    'Hemos agregado la terapia de Reflexología en nuestro catálogo.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarUser(),
    );
  }

  Widget _buildBottomIcon(BuildContext context,
      {required IconData icon,
      required String label,
      String? routeName,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ??
          () {
            if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 8.7),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el menú modal flotante
  void _showMenuModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 0.9, // Ajusta el ancho del menú flotante
          alignment: Alignment
              .centerLeft, // Ubica el menú en la esquina inferior derecha
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Esto ajusta el menú para que se muestre completo
              children: [
                const Text(
                  'Menú',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notificaciones'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget para representar una notificación individual
class NotificationTile extends StatelessWidget {
  final String title;
  final String message;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.symmetric(vertical: 10), // Espacio entre tarjetas
      child: ListTile(
        leading:
            const Icon(Icons.notifications_active, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(message),
      ),
    );
  }
}
