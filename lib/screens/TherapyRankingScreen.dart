import 'package:flutter/material.dart';
import 'package:paraflorseer/utils/firestore_service.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar.dart'; // Bottom Navigation Bar
import 'package:paraflorseer/widgets/refresh.dart'; // Widget de refresco

class TherapyRankingScreen extends StatefulWidget {
  const TherapyRankingScreen({super.key});

  @override
  _TherapyRankingScreenState createState() => _TherapyRankingScreenState();
}

class _TherapyRankingScreenState extends State<TherapyRankingScreen> {
  Future<Map<String, Map<String, int>>>? _rankingFuture;

  @override
  void initState() {
    super.initState();
    // Instanciar el servicio y obtener los datos
    _rankingFuture = FirestoreService().getTherapyAndTherapistRanking();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _rankingFuture = FirestoreService().getTherapyAndTherapistRanking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(), // Uso del AppBar personalizado
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
          future: _rankingFuture,
          builder: (context, snapshot) {
            // Estado de espera de la carga
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // En caso de error
            else if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar el ranking'));
            }
            // Si no hay datos
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay datos disponibles'));
            }

            print(
                'Datos de ranking recibidos: ${snapshot.data}'); // Log de los datos recibidos

            final ranking = snapshot.data!; // Obtener los datos del ranking

            return SingleChildScrollView(
              child: Column(
                children: ranking.keys.map((therapy) {
                  final therapistCounts = ranking[therapy]!;
                  return ExpansionTile(
                    title: Text(therapy),
                    children: therapistCounts.keys.map((therapist) {
                      int count = therapistCounts[therapist] ??
                          0; // Asegurarse que no haya valores nulos
                      return ListTile(
                        title: Text(therapist),
                        trailing: Text('$count reservas'),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          const BottomNavBar(), // Uso del Bottom Navigation Bar personalizado
    );
  }
}
