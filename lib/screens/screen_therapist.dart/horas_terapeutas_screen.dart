import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/screen_therapist.dart/serviciosdeFIreestore.dart';
import 'package:paraflorseer/utils/firestore_service.dart';

import 'package:paraflorseer/widgets/custom_appbar_welcome.dart';
import 'package:paraflorseer/widgets/refresh.dart';

class HorasTerapeutasScreen extends StatefulWidget {
  const HorasTerapeutasScreen({super.key});

  @override
  _TherapyRankingScreenState createState() => _TherapyRankingScreenState();
}

class _TherapyRankingScreenState extends State<HorasTerapeutasScreen> {
  Future<Map<String, Map<String, int>>>? _rankingFuture;
  final reservationsService = ReservationsService();

  @override
  void initState() {
    super.initState();
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
      appBar: const CustomAppBarWelcome(),
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
          // Aqui se maneja la consulta a Firestore
          future: _rankingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              return _buildErrorUI();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildNoDataUI();
            }

            final ranking = snapshot.data!;
            return _buildExpandableLists(ranking);
          },
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'Ocurrió un error al cargar los datos.\nIntente nuevamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('No hay datos disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _handleRefresh,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          ),
          child: const Text('Refrescar', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildExpandableLists(Map<String, Map<String, int>> ranking) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTherapyList(ranking),
          const SizedBox(height: 16),
          _buildTherapistList(ranking),
        ],
      ),
    );
  }

  // Definicion del metodo _buildTherapyList
  Widget _buildTherapyList(Map<String, Map<String, int>> ranking) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(
          'Reservas por Terapia',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor),
        ),
        children: ranking.entries.map((entry) {
          final therapyName = entry.key;
          final therapists = entry.value;
          final totalReservations =
              therapists.values.fold(0, (sum, count) => sum + count);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text('$therapyName ($totalReservations reservas)',
                  style: TextStyle(fontSize: 16)),
              subtitle: Text('Total de reservas: $totalReservations',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTherapistList(Map<String, Map<String, int>> ranking) {
    Map<String, int> therapistData = {};
    ranking.forEach((_, therapists) {
      therapists.forEach((therapist, count) {
        therapistData[therapist] = (therapistData[therapist] ?? 0) + count;
      });
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(
          'Reservas por Terapeuta',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor),
        ),
        children: therapistData.entries.map((entry) {
          final therapistName = entry.key;
          final reservationCount = entry.value;

          return ExpansionTile(
            title: Text('$therapistName ($reservationCount reservas)',
                style: TextStyle(fontSize: 16)),
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                // Consulta de reservas para cada terapeuta
                future: reservationsService
                    .getReservationsForTherapist(therapistName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const ListTile(
                      title: Text('No se pudieron cargar las reservas.'),
                    );
                  }
                  final reservations = snapshot.data!;
                  if (reservations.isEmpty) {
                    return const ListTile(
                      title: Text('No hay reservas para este terapeuta.'),
                    );
                  }
                  return Column(
                    children: reservations.map((reservation) {
                      final serviceName =
                          reservation['service_name'] ?? 'Servicio desconocido';
                      final userName =
                          reservation['user_name'] ?? 'Usuario desconocido';
                      final timestamp = reservation['date'];
                      final time = reservation['time'] ?? 'Hora no disponible';

                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          '${dateTime.day} de ${_getMonthName(dateTime.month)} ${dateTime.year}';
                      String formattedTime = '${time.substring(0, 5)}';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(serviceName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Usuario: $userName',
                                  style: const TextStyle(fontSize: 14)),
                              Text('Fecha: $formattedDate',
                                  style: const TextStyle(fontSize: 14)),
                              Text('Hora: $formattedTime',
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }
}
