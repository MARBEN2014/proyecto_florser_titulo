import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paraflorseer/utils/obtenerUserandNAme.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/screens/welcome_screen.dart';
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
            nuevasCitas.add(data);
          }
        }

        setState(() {
          citas = nuevasCitas;
          citasMostradas = citas.isNotEmpty;
        });
      }
    } catch (e) {
      print("Error al obtener las reservas: $e");
      // Considera mostrar un mensaje al usuario
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: Text(
                  'Hola: $userName Tus citas',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            if (citas.isEmpty) ...[
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/calendario.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  "Usted no tiene citas agendadas",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              Center(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/citas.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Usted tiene ${citas.length} citas agendadas",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // ListView sin necesidad de envolver en SingleChildScrollView
              Expanded(
                child: ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];

                    // Formatear el campo 'created_at' si es un Timestamp
                    DateTime createdAt =
                        (cita['created_at'] as Timestamp).toDate();
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(createdAt);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Servicio: ${cita['service_name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Terapeuta: ${cita['therapist']}'),
                            Text('Fecha de agendamineto: $formattedDate'),
                            Text('Fecha de la cita: ${cita['day']}'),
                            Text('Hora: ${cita['time']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: citasMostradas
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                        );
                      }
                    : _fetchReservas,
                child:
                    Text(citasMostradas ? 'Agendar cita' : 'Mostrar las citas'),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
