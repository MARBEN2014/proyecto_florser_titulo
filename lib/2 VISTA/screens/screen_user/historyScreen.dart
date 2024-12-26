import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';

class HistorialCitasScreen extends StatefulWidget {
  const HistorialCitasScreen({super.key});

  @override
  _HistorialCitasScreenState createState() => _HistorialCitasScreenState();
}

class _HistorialCitasScreenState extends State<HistorialCitasScreen> {
  bool isLoading = true; // Indica si los datos están cargándose
  List<Map<String, dynamic>> historialCitas =
      []; // Lista de citas en el historial
  String userName = ''; // Variable para almacenar el nombre del usuario

  @override
  void initState() {
    super.initState();
    _fetchHistorialCitas(); // Carga el historial de citas desde Firestore
  }

  // Recupera el historial de citas del usuario desde Firestore
  Future<void> _fetchHistorialCitas() async {
    setState(() {
      isLoading = true; // Muestra el indicador de carga
    });

    try {
      final user =
          FirebaseAuth.instance.currentUser; // Usuario autenticado actual
      if (user != null) {
        // Obtiene el nombre del usuario
        final userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data()?['name'] ??
                'Usuario'; // Actualiza el nombre del usuario
          });
        }

        // Obtiene todas las citas del historial del usuario
        final historialSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('history')
            .get();

        List<Map<String, dynamic>> citas = historialSnapshot.docs
            .map((doc) => {
                  ...doc.data(), // Agrega los datos de la cita
                  'docId': doc.id // Incluye el ID del documento
                })
            .toList();

        setState(() {
          historialCitas = citas; // Actualiza la lista de citas
        });
      }
    } catch (e) {
      print("Error al obtener el historial de citas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "No se pudieron cargar las citas del historial. Intente nuevamente.")),
      );
    } finally {
      setState(() {
        isLoading = false; // Oculta el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.secondary, // Color de fondo definido en el tema
      appBar: CustomAppBar(
        showNotificationButton: false, // Oculta el botón de notificaciones
        title: 'Historial de Citas',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (isLoading)
              const Center(
                  child:
                      CircularProgressIndicator()) // Muestra indicador mientras carga
            else ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hola, $userName',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (historialCitas.isEmpty)
                const Center(
                  child: Text(
                    'No tienes citas en el historial.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ), // Mensaje si no hay citas
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: historialCitas.length, // Número de citas
                    itemBuilder: (context, index) {
                      final cita = historialCitas[index];
                      DateTime createdAt = (cita['created_at'] as Timestamp)
                          .toDate(); // Fecha de creación
                      String formattedDate = DateFormat('dd/MM/yyyy')
                          .format(createdAt); // Formatea la fecha

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            'Servicio: ${cita['service_name']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Terapeuta: ${cita['therapist']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                Text('Fecha de creación: $formattedDate',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                Text('Fecha de la cita: ${cita['day']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                                Text('Hora: ${cita['time']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black87)),
                              ],
                            ),
                          ),
                          trailing: Icon(
                            Icons.event_available,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
