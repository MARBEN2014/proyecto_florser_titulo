import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Para la manipulación de fechas
import 'dart:async';
import 'package:paraflorseer/themes/app_colors.dart'; // Colores personalizados de la app
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart'; // Barra de navegación inferior
import 'package:paraflorseer/widgets/custom_appbar_back.dart'; // Barra superior personalizada con botón de retroceso
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP

// Pantalla principal de notificaciones
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> citas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCitas();
  }

  Future<void> _fetchCitas() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final reservasSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .get();

        List<Map<String, dynamic>> nuevasCitas = [];
        for (var doc in reservasSnapshot.docs) {
          final data = doc.data();
          if (data['day'] != null && data['time'] != null) {
            nuevasCitas.add({
              ...data,
              'docId': doc.id,
              'daysRemaining': _calculateDaysRemaining(data['day']),
            });
          }
        }

        setState(() {
          citas = nuevasCitas;
        });

        _scheduleNotifications();
      }
    } catch (e) {
      print("Error al obtener las citas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("No se pudieron cargar las citas. Intente nuevamente.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int _calculateDaysRemaining(String dateString) {
    DateTime citaDate = DateFormat('dd/MM/yyyy').parse(dateString);
    DateTime today = DateTime.now();
    return citaDate.difference(today).inDays;
  }

  // Función para programar notificaciones
  void _scheduleNotifications() {
    for (var cita in citas) {
      int daysRemaining = cita['daysRemaining'];
      if (daysRemaining == 7 || daysRemaining == 2) {
        Future.delayed(Duration(seconds: 1), () {
          _showNotification(cita, daysRemaining);
          _sendEmailReminder(cita); // Enviar recordatorio por correo
        });
      }
    }
  }

  // Función para mostrar la notificación en pantalla
  void _showNotification(Map<String, dynamic> cita, int daysRemaining) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recordatorio de Cita'),
          content: Text(
              'Faltan $daysRemaining días para tu cita de ${cita['service_name']} con ${cita['therapist']}'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  // Función para enviar el recordatorio por correo electrónico
  Future<void> _sendEmailReminder(Map<String, dynamic> cita) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final email = user.email;
      final url = Uri.parse(
          'https://your-backend-url/send-email'); // URL del backend para enviar el correo

      try {
        final response = await http.post(url, body: {
          'email': email,
          'subject': 'Recordatorio de Cita',
          'message':
              'Faltan 7 días para tu cita de ${cita['service_name']} con ${cita['therapist']} en la fecha ${cita['day']}.',
        });

        if (response.statusCode == 200) {
          print('Correo enviado con éxito');
        } else {
          print('Error al enviar el correo');
        }
      } catch (e) {
        print('Error en la solicitud HTTP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: CustomAppbarBack(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : citas.isEmpty
              ? const Center(child: Text('Usted No tiene citas próximas.'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notificaciones',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(height: 20),
                        ...citas
                            .asMap()
                            .map((index, cita) {
                              // Alternar colores entre primario y secundario
                              Color backgroundColor = index.isEven
                                  ? AppColors.primary
                                  : Colors.white;
                              Color textColor = backgroundColor == Colors.white
                                  ? Colors.black
                                  : Colors.white;
                              return MapEntry(
                                index,
                                NotificationTile(
                                  backgroundColor: backgroundColor,
                                  textColor: textColor,
                                  title: 'Cita confirmada',
                                  serviceName: cita['service_name'],
                                  message:
                                      'Tu cita de ${cita['service_name']} con ${cita['therapist']} es el ${cita['day']} a las ${cita['time']}.',
                                  onTap: () {
                                    _showNotification(
                                        cita, cita['daysRemaining']);
                                  },
                                ),
                              );
                            })
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBarUser(),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final String serviceName; // Para el nombre de la terapia
  final String message;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.serviceName, // Recibimos el nombre de la terapia
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.notifications_active,
            color: Colors.black), // Cambié el color a negro
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        subtitle: Text(serviceName, style: TextStyle(color: textColor)),
        onTap: onTap,
      ),
    );
  }
}
