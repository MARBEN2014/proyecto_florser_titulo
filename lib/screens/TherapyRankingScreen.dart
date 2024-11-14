// Importamos los paquetes necesarios
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/utils/firestore_service.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
import 'package:paraflorseer/widgets/refresh.dart';

class TherapyRankingScreen extends StatefulWidget {
  const TherapyRankingScreen({super.key});

  @override
  _TherapyRankingScreenState createState() => _TherapyRankingScreenState();
}

class _TherapyRankingScreenState extends State<TherapyRankingScreen> {
  Future<Map<String, Map<String, int>>>? _rankingFuture;
  Map<String, int> therapiesWithoutReservations = {};
  Map<String, int> therapistsWithoutReservations = {};

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
      appBar: const CustomAppBar(),
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
          // FutureBuilder para cargar datos
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
            final therapyData = _getTherapyData(ranking);
            final therapistData = _getTherapistData(ranking);

            // Identificamos terapias y terapeutas sin reservas
            _identifyTherapiesWithoutReservations(ranking);
            _identifyTherapistsWithoutReservations(ranking);

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildTherapyChart(therapyData),
                  const SizedBox(height: 60),
                  _buildTherapistChart(therapistData),
                  const SizedBox(height: 60),
                  _buildSummaryBox(therapyData, therapistData),
                  //_buildTherapiesWithoutReservations(),
                  _buildTherapistsWithoutReservations(),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // Función para manejar errores al cargar los datos
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

  // Función para mostrar mensaje cuando no hay datos disponibles
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
          child: const Text('Refrescar'),
        ),
      ],
    );
  }

  // Obtiene los datos del ranking de las terapias (total de reservas por terapia)

  Map<String, int> _getTherapyData(Map<String, Map<String, int>> ranking) {
    Map<String, int> therapyData = {};
    ranking.forEach((therapy, therapists) {
      int totalReservations =
          therapists.values.fold(0, (sum, count) => sum + count);
      // Solo se agregan terapias con al menos 1 cita
      if (totalReservations > 0) {
        therapyData[therapy] = totalReservations;
      }
    });
    return therapyData;
  }

  // Obtiene los datos del ranking de los terapeutas (total de reservas por terapeuta)
  Map<String, int> _getTherapistData(Map<String, Map<String, int>> ranking) {
    Map<String, int> therapistData = {};
    ranking.forEach((therapy, therapists) {
      therapists.forEach((therapist, count) {
        // Solo se agregan terapeutas con al menos 1 cita
        if (count > 0) {
          therapistData[therapist] = (therapistData[therapist] ?? 0) + count;
        }
      });
    });
    return therapistData;
  }

  // Función para identificar las terapias que no tienen reservas
  void _identifyTherapiesWithoutReservations(
      Map<String, Map<String, int>> ranking) {
    therapiesWithoutReservations.clear();
    ranking.forEach((therapy, therapists) {
      int totalReservations =
          therapists.values.fold(0, (sum, count) => sum + count);
      // Solo agregamos terapias con 0 reservas
      if (totalReservations == 0) {
        therapiesWithoutReservations[therapy] = 0;
      }
    });
  }

// Función para identificar los terapeutas que no tienen reservas
  void _identifyTherapistsWithoutReservations(
      Map<String, Map<String, int>> ranking) {
    therapistsWithoutReservations.clear();
    ranking.forEach((therapy, therapists) {
      therapists.forEach((therapist, count) {
        // Solo agregamos terapeutas con 0 reservas
        if (count == 0) {
          therapistsWithoutReservations[therapist] = 0;
        }
      });
    });
  }

  // Función para construir la gráfica de terapias
  Widget _buildTherapyChart(Map<String, int> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estadísticas de Terapias',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          data.isEmpty
              ? _buildEmptyList('No hay terapias con citas agendadas.')
              : _buildBarChart(data),
        ],
      ),
    );
  }

  // Función para construir la gráfica de terapeutas
  Widget _buildTherapistChart(Map<String, int> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estadísticas de Terapeutas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          data.isEmpty
              ? _buildEmptyList('No hay terapeutas con citas agendadas.')
              : _buildBarChart(data),
        ],
      ),
    );
  }

  // Muestra el cuadro de texto vacío cuando no hay datos en las listas de terapias o terapeutas
  Widget _buildEmptyList(String message) {
    return Column(
      children: [
        const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _handleRefresh,
          child: const Text('Refrescar'),
        ),
      ],
    );
  }

  // Función para construir el gráfico de barras
  Widget _buildBarChart(Map<String, int> data) {
    List<BarChartGroupData> barGroups = [];
    int index = 0;

    data.forEach((label, count) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.green,
              width: 15,
              borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
            ),
          ],
        ),
      );
      index++;
    });

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    String label = data.keys.elementAt(value.toInt());
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 30.0,
                        top: 8.0,
                      ), //
                      child: Transform.rotate(
                        angle: -0.4854, // Rotación de 45 grados en radianes
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  // Función para mostrar el cuadro resumen de las terapias y terapeutas
  Widget _buildSummaryBox(
      Map<String, int> therapyData, Map<String, int> therapistData) {
    int totalTherapiesWithReservations = therapyData.length;
    int totalTherapistsWithReservations = therapistData.length;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen General',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total de terapias con reservas: $totalTherapiesWithReservations',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              'Total de terapeutas con reservas: $totalTherapistsWithReservations',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Text(
            //   'Terapias sin reservas: ${therapiesWithoutReservations.keys.length}',
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //     color: Colors.redAccent,
            //   ),
            // ),

            Text(
              'Terapeutas sin reservas: ${therapistsWithoutReservations.keys.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // Función para mostrar las terapias sin reservas
  // Widget _buildTherapiesWithoutReservations() {
  //   return therapiesWithoutReservations.isEmpty
  //       ? Container()
  //       : Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: ExpansionTile(
  //             title: const Text(
  //               'Terapias sin reservas:',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //             ),
  //             children: therapiesWithoutReservations.keys
  //                 .map((therapy) => ListTile(
  //                       leading: const Icon(Icons.circle,
  //                           size: 10, color: Colors.red),
  //                       title: Text(therapy),
  //                     ))
  //                 .toList(),
  //           ),
  //         );
  // }

  // Función para mostrar los terapeutas sin reservas
  Widget _buildTherapistsWithoutReservations() {
    return therapistsWithoutReservations.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: ExpansionTile(
              title: const Text(
                'Terapeutas sin reservas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              children: therapistsWithoutReservations.keys
                  .map((therapist) => ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(therapist),
                      ))
                  .toList(),
            ),
          );
  }
}
