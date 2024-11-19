import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:paraflorseer/screens/user_profile_screen.dart';
import 'package:paraflorseer/themes/app_colors.dart';

class BottomNavBarTherapist extends StatelessWidget {
  const BottomNavBarTherapist({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomIcon(
            context,
            icon: Icons.home,
            label: 'Home',
          ),
          _buildBottomIcon(context,
              icon: Icons.calendar_today, label: 'Mis Citas'),
          _buildBottomIcon(context,
              icon: Icons.medical_services, label: 'Ficha Médica'),
          _buildBottomIcon(context,
              icon: Icons.chat,
              label: 'Soporte',
              routeName: '/soporte_terapeuta'),
          _buildBottomIcon(context, icon: Icons.menu, label: 'Menú', onTap: () {
            _showMenuModal(context);
          }),
        ],
      ),
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
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 8.7)),
        ],
      ),
    );
  }

  void _showMenuModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          widthFactor: 0.9,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Menú',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/user_terapeuta'); // Ruta actualizada aquí
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_document),
                  title: const Text('Terminos y condiciones'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/condiciones _terapeuta');
                  },
                ),

                // ListTile(
                //   leading: const Icon(Icons.notifications),
                //   title: const Text('Notificaciones'),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.pushNamed(context, '');
                //   },
                // ),

                ListTile(
                  leading: const Icon(Icons.insert_chart),
                  title: const Text('Estadisticas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/therapist');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesion'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, '/login');
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