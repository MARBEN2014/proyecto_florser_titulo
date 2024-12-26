// Importaciones necesarias para la funcionalidad de la pantalla
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:paraflorseer/3%20CONTROLADOR/services/bloc/localNotification/local_notification.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';

// Pantalla de notificaciones
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Lista para almacenar las citas obtenidas de Firestore
  List<Map<String, dynamic>> citas = [];

  // Indicador de carga para mostrar un spinner mientras se cargan los datos
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Método para obtener las citas al inicializar la pantalla
    _fetchCitas();

    // Inicialización de notificaciones locales
    LocalNotification.initializeLocalNotifications(
      onNotificationTap:
          _onNotificationTap, // Acción cuando se toca una notificación
    );

    // Programar una notificación diaria a las 14:00
    _scheduleDailyNotification();
  }

  // Método para obtener citas desde Firestore
  Future<void> _fetchCitas() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user =
          FirebaseAuth.instance.currentUser; // Obtener el usuario actual
      if (user != null) {
        // Obtener las reservas desde Firestore
        final reservasSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .get();

        List<Map<String, dynamic>> nuevasCitas = [];

        // Procesar los datos obtenidos
        for (var doc in reservasSnapshot.docs) {
          final data = doc.data();
          if (data['day'] != null && data['time'] != null) {
            nuevasCitas.add({
              ...data,
              'docId': doc.id, // ID del documento para identificación única
              'daysRemaining': _calculateDaysRemaining(
                  data['day']), // Días restantes para la cita
            });
          }
        }

        setState(() {
          citas = nuevasCitas; // Actualizar la lista de citas
        });

        // Programar notificaciones basadas en las citas
        _scheduleNotifications();
      }
    } catch (e) {
      print("Error al obtener las citas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudieron cargar las citas. Intente nuevamente."),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Finalizar el indicador de carga
      });
    }
  }

  // Calcular días restantes para una fecha dada
  int _calculateDaysRemaining(String dateString) {
    DateTime citaDate = DateFormat('dd/MM/yyyy').parse(dateString);
    DateTime today = DateTime.now();
    return citaDate
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
  }

  // Programar notificaciones según los días restantes
  void _scheduleNotifications() {
    for (var cita in citas) {
      int daysRemaining = cita['daysRemaining'];
      if (daysRemaining == 7 || daysRemaining == 2 || daysRemaining == 1) {
        _scheduleLocalNotification(cita, daysRemaining);
      }
    }
  }

  // Programar una notificación local para una cita específica
  void _scheduleLocalNotification(
      Map<String, dynamic> cita, int daysRemaining) {
    String message = daysRemaining == 7
        ? 'Faltan 7 días para tu cita de ${cita['service_name']} con ${cita['therapist']}'
        : daysRemaining == 2
            ? 'Faltan 2 días para tu cita de ${cita['service_name']} con ${cita['therapist']}'
            : 'Tu cita de ${cita['service_name']} con ${cita['therapist']} es mañana';

    LocalNotification.showLocalNotification(
      id: cita['docId'].hashCode, // ID único basado en el hash del documento
      title: 'Recordatorio de Cita',
      body: message, // Mensaje de la notificación
    );
  }

  // Programar una notificación diaria a las 14:00
  void _scheduleDailyNotification() {
    final now = DateTime.now();
    final targetTime = DateTime(now.year, now.month, now.day, 14, 0);
    Duration durationUntilNotification;

    // Si la hora de la notificación ya pasó hoy, programarla para mañana
    if (targetTime.isBefore(now)) {
      durationUntilNotification =
          targetTime.add(const Duration(days: 1)).difference(now);
    } else {
      durationUntilNotification = targetTime.difference(now);
    }

    // Programar la notificación con el tiempo calculado
    Future.delayed(durationUntilNotification, () {
      _sendNotificationForNextDay();
    });
  }

  // Enviar notificaciones para citas del día siguiente
  void _sendNotificationForNextDay() {
    for (var cita in citas) {
      if (cita['daysRemaining'] == 1) {
        _scheduleLocalNotification(cita, 1);
      }
    }
  }

  // Acción al tocar una notificación
  void _onNotificationTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  // Mostrar un cuadro de diálogo con los detalles de la notificación
  void _showNotification(Map<String, dynamic> cita, int daysRemaining) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalle de la Notificación'),
        content: Text(
          daysRemaining == 0
              ? 'Tu cita de ${cita['service_name']} con ${cita['therapist']} es hoy.'
              : 'Faltan $daysRemaining días para tu cita de ${cita['service_name']} con ${cita['therapist']}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary, // Color de fondo de la pantalla
      appBar: CustomAppBarWelcome(), // Barra de navegación personalizada
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Spinner de carga
          : citas.isEmpty
              ? const Center(
                  child: Text(
                      'Usted no tiene citas próximas.')) // Mensaje si no hay citas
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Crear un listado de notificaciones
                        ...citas.map((cita) {
                          return NotificationTile(
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.text,
                            title: 'Cita confirmada',
                            serviceName: cita['service_name'],
                            message: cita['daysRemaining'] == 0
                                ? 'Tu cita es hoy'
                                : 'Faltan ${cita['daysRemaining']} días para tu cita.',
                            onTap: () =>
                                _showNotification(cita, cita['daysRemaining']),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavBarUser(), // Barra de navegación inferior
    );
  }
}

// Widget para representar cada notificación
class NotificationTile extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final String serviceName;
  final String message;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.title,
    required this.serviceName,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor, // Fondo del card
      margin: const EdgeInsets.symmetric(vertical: 10), // Margen vertical
      child: ListTile(
        leading: const Icon(Icons.notifications_active,
            color: Colors.white), // Ícono de notificación
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        subtitle: Text(serviceName, style: TextStyle(color: textColor)),
        onTap: onTap, // Acción al tocar el card
      ),
    );
  }
}
