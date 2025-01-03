import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_user/welcomeScreenLogin.dart';
import 'package:paraflorseer/3%20CONTROLADOR/utils/obtenerUserandNAme.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
//import 'package:paraflorseer/2%20VISTA/screens/screen_user/welcome_screen.dart';
import 'package:intl/intl.dart';

class MisCitasScreen extends StatefulWidget {
  const MisCitasScreen({super.key});

  @override
  _MisCitasScreenState createState() => _MisCitasScreenState();
}

class _MisCitasScreenState extends State<MisCitasScreen> {
  String? userName;
  bool isLoading = true;
  bool citasMostradas = false;
  List<Map<String, dynamic>> citas = [];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _fetchReservas();
  }

  Future<void> _getUserDetails() async {
    String? fetchedUserName = await fetchUserName();
    setState(() {
      userName = fetchedUserName ?? '';
    });
  }

  Future<void> _fetchReservas() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final now = DateTime.now();
        final reservasSnapshot = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .get();

        List<Map<String, dynamic>> nuevasCitas = [];

        for (var doc in reservasSnapshot.docs) {
          final data = doc.data();
          if (data['service_name'] != null &&
              data['therapist'] != null &&
              data['day'] != null &&
              data['time'] != null &&
              data['created_at'] != null) {
            DateTime citaDate = DateFormat('dd/MM/yyyy').parse(data['day']);

            if (citaDate.isBefore(now)) {
              // Mover la cita al historial
              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(user.uid)
                  .collection('history')
                  .doc(doc.id)
                  .set(data);

              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(user.uid)
                  .collection('Reservas')
                  .doc(doc.id)
                  .delete();
            } else {
              nuevasCitas.add({
                ...data,
                'docId': doc.id,
              });
            }
          }
        }

        setState(() {
          citas = nuevasCitas;
          citasMostradas = citas.isNotEmpty;
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
        isLoading = false;
      });
    }
  }

  Future<bool?> _showCancelDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar Cita',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('¿Estás seguro de que deseas cancelar esta cita?',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelCita(String docId, String therapist) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .collection('Reservas')
            .doc(docId)
            .delete();

        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(therapist)
            .collection('appointments')
            .doc(docId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cita cancelada exitosamente.")),
        );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: CustomAppBar(
        showNotificationButton: false,
        title: '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (citas.isEmpty)
              const Center(
                child: Text('No tienes citas agendadas en este momento.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    DateTime createdAt =
                        (cita['created_at'] as Timestamp).toDate();
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(createdAt);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text('Servicio: ${cita['service_name']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Terapeuta: ${cita['therapist']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Fecha de agendamiento: $formattedDate',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Fecha de la cita: ${cita['day']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Hora: ${cita['time']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.highlight_off,
                              color: Color.fromARGB(255, 207, 76, 36)),
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
            Center(
              child: ElevatedButton(
                onPressed: citasMostradas
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreenLogin()),
                        );
                      }
                    : _fetchReservas,
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Text(
                  citasMostradas ? 'Agendar cita' : 'Mostrar las citas',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarUser(),
    );
  }
}
