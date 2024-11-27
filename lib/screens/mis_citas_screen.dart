import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paraflorseer/utils/obtenerUserandNAme.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
import 'package:intl/intl.dart';

// Pantalla de "Mis Citas"
class MisCitasScreen extends StatefulWidget {
  const MisCitasScreen({super.key});

  @override
  _MisCitasScreenState createState() => _MisCitasScreenState();
}

class _MisCitasScreenState extends State<MisCitasScreen> {
  String? userName; // Nombre de usuario que se mostrará en la pantalla
  bool isLoading = true; // Indica si los datos están cargando
  bool citasMostradas = false; // Indica si las citas están mostradas
  List<Map<String, dynamic>> citas =
      []; // Lista para almacenar las citas obtenidas

  // Método que se ejecuta al iniciar la pantalla
  @override
  void initState() {
    super.initState();
    _getUserDetails(); // Obtener detalles del usuario
    _fetchReservas(); // Obtener las reservas desde Firestore
  }

  // Método para obtener el nombre de usuario de Firestore
  Future<void> _getUserDetails() async {
    String? fetchedUserName =
        await fetchUserName(); // Llamada a función externa
    setState(() {
      userName = fetchedUserName ?? ''; // Establecer el nombre de usuario
    });
  }

  // Método para obtener las reservas desde Firestore
  Future<void> _fetchReservas() async {
    setState(() {
      isLoading = true; // Activar el indicador de carga
    });
    try {
      final user =
          FirebaseAuth.instance.currentUser; // Obtener el usuario actual
      if (user != null) {
        // Obtener las reservas del usuario desde Firestore
        final reservasSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .get();

        // Lista para almacenar las nuevas citas
        List<Map<String, dynamic>> nuevasCitas = [];
        for (var doc in reservasSnapshot.docs) {
          final data = doc.data();
          if (data['service_name'] != null &&
              data['therapist'] != null &&
              data['day'] != null &&
              data['time'] != null &&
              data['created_at'] != null) {
            nuevasCitas.add({
              ...data, // Agregar todos los datos de la cita
              'docId': doc.id, // Agregar el ID del documento
            });
          }
        }

        setState(() {
          citas = nuevasCitas; // Actualizar la lista de citas
          citasMostradas = citas.isNotEmpty; // Comprobar si hay citas
        });
      }
    } catch (e) {
      print("Error al obtener las reservas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("No se pudieron cargar las citas. Intente nuevamente.")),
      );
    } finally {
      setState(() {
        isLoading = false; // Desactivar el indicador de carga
      });
    }
  }

  // Mostrar un cuadro de diálogo para confirmar la cancelación de una cita
  Future<bool?> _showCancelDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar Cita'),
          content:
              const Text('¿Estás seguro de que deseas cancelar esta cita?'),
          actions: <Widget>[
            // Botón para cancelar la acción
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            // Botón para confirmar la cancelación
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  // Cancelar una cita en Firestore
  Future<void> _cancelCita(String docId, String therapist) async {
    try {
      final user =
          FirebaseAuth.instance.currentUser; // Obtener el usuario actual
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .doc(docId)
            .delete(); // Eliminar la cita de Firestore

        // Eliminar la cita de la colección principal "reservations"
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(therapist) // Nombre del terapeuta
            .collection('appointments')
            .doc(docId) // Mismo ID de la cita
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cita cancelada exitosamente.")),
        );

        // Actualizar las citas
        _fetchReservas();
      }
    } catch (e) {
      print("Error al cancelar la cita: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No se pudo cancelar la cita. Intente nuevamente.")),
      );
    }
  }

  // Método para construir la interfaz de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary, // Fondo de la pantalla
      appBar: CustomAppBar(
        showNotificationButton: false,
        title: '',
      ), // Barra de navegación personalizada
      body: Padding(
        padding:
            const EdgeInsets.all(16.0), // Espaciado alrededor de la pantalla
        child: Column(
          children: <Widget>[
            // Si las citas están cargando, mostrar el indicador de carga
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            // Si no hay citas, mostrar un mensaje
            else if (citas.isEmpty)
              const Center(
                child: Text('No tienes citas agendadas en este momento.'),
              )
            // Si hay citas, mostrar la lista de citas
            else
              Expanded(
                child: ListView.builder(
                  itemCount: citas.length, // Número de citas a mostrar
                  itemBuilder: (context, index) {
                    final cita = citas[index]; // Obtener una cita de la lista
                    DateTime createdAt = (cita['created_at'] as Timestamp)
                        .toDate(); // Convertir timestamp
                    String formattedDate = DateFormat('dd/MM/yyyy')
                        .format(createdAt); // Formatear fecha

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8), // Margen entre las tarjetas
                      child: ListTile(
                        title: Text(
                            'Servicio: ${cita['service_name']}'), // Nombre del servicio
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Terapeuta: ${cita['therapist']}'),
                            Text('Fecha de agendamineto: $formattedDate'),
                            Text('Fecha de la cita: ${cita['day']}'),
                            Text('Hora: ${cita['time']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.highlight_off,
                              color: Color.fromARGB(
                                  255, 207, 76, 36)), // Botón de cancelación
                          onPressed: () async {
                            bool? confirm = await _showCancelDialog();
                            if (confirm == true) {
                              await _cancelCita(
                                  cita['docId'], cita['therapist']);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            // Botón para agendar cita o mostrar las citas
            Center(
              child: ElevatedButton(
                onPressed: citasMostradas
                    ? () {
                        // Si las citas están mostradas, navegar a la pantalla de bienvenida
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );
                      }
                    : _fetchReservas, // Si no, cargar las citas
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      AppColors.secondary, // Color del texto dentro del botón
                  backgroundColor:
                      AppColors.primary, // Color de fondo del botón
                ),
                child: Text(
                  citasMostradas
                      ? 'Agendar cita'
                      : 'Mostrar las citas', // Texto dinámico
                  style: TextStyle(
                    fontSize: 16, // Tamaño de la fuente
                    fontWeight: FontWeight.bold, // Peso de la fuente
                    color: Colors.white, // Color del texto
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar:
          const BottomNavBarUser(), // Barra de navegación inferior
    );
  }
}
