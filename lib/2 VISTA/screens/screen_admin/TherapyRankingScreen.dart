import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';
import 'package:paraflorseer/2%20VISTA/widgets/refresh.dart';
import 'package:paraflorseer/3%20CONTROLADOR/utils/firestore_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class TherapyRankingScreen extends StatefulWidget {
  const TherapyRankingScreen({super.key});

  @override
  _TherapyRankingScreenState createState() => _TherapyRankingScreenState();
}

class _TherapyRankingScreenState extends State<TherapyRankingScreen> {
  ScreenshotController screenshotController = ScreenshotController();
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

// Función para filtrar las terapias con reservas entre 1 y 9
  Map<String, int> _getTherapiesWithReservationsBetween1And9(
      Map<String, Map<String, int>> ranking) {
    Map<String, int> therapyData = {};
    ranking.forEach((therapy, therapists) {
      int totalReservations =
          therapists.values.fold(0, (sum, count) => sum + count);
      // Solo agregamos terapias con reservas entre 1 y 9
      if (totalReservations >= 1 && totalReservations < 4) {
        therapyData[therapy] = totalReservations;
      }
    });
    return therapyData;
  }

  @override
  Widget build(BuildContext context) {
    String currentMonthYear = DateFormat('MMMM yyyy').format(DateTime.now());
    String periodText = 'Período: $currentMonthYear';

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? const CustomAppBarWelcome() // Mostrar AppBar solo en orientación vertical
          : null, // No mostrar AppBar en orientación horizontal
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
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

            // Filtramos terapias con menos de 10 reservas
            final therapiesWithLessThan10 =
                _getTherapiesWithReservationsBetween1And9(ranking);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Agregar el texto "Período" y el mes/año debajo del app bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      periodText, // Mostrar "Período" seguido de mes y año
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  _buildTherapyChart(therapyData),
                  const SizedBox(height: 60),
                  _buildTherapiesWithLessThan10Chart(therapiesWithLessThan10),
                  const SizedBox(height: 60),
                  _buildTherapistChart(therapistData),
                  const SizedBox(height: 60),
                  _buildSummaryBox(therapyData, therapistData),
                  _buildTherapistsWithoutReservations(),
                ],
              ),
            );
          },
        ),
      ),
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
      if (totalReservations > 10) {
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

  // Método para construir la gráfica de terapias con botón
  Widget _buildTherapyChart(Map<String, int> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Screenshot(
        controller: screenshotController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Terapias con más agendamientos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            data.isEmpty
                ? _buildEmptyList('No hay terapias con citas agendadas.')
                : Column(
                    children: [
                      _buildBarChart(data),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _downloadChart("therapy_chart");
                        },
                        child: const Text('Descargar'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // Método para construir la gráfica de terapias con menos de 10 reservas con botón
  Widget _buildTherapiesWithLessThan10Chart(Map<String, int> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Terapias con menos de reservas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          data.isEmpty
              ? _buildEmptyList('No hay terapias con menos de 10 reservas.')
              : Column(
                  children: [
                    _buildBarChart(data),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Acción al presionar "Descargar"
                        _downloadChart("less_than_10_chart");
                      },
                      child: const Text('Descargar'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // Método para construir la gráfica de terapeutas con botón
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
              : Column(
                  children: [
                    _buildBarChart(data),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Acción al presionar "Descargar"
                        _downloadChart("therapist_chart");
                      },
                      child: const Text('Descargar'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // Método para manejar la acción de descarga
  Future<void> _downloadChart(String chartName) async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getExternalStorageDirectory();
        final path = "${directory!.path}/$chartName.png";
        final file = File(path);
        await file.writeAsBytes(image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gráfico descargado exitosamente: $path')),
        );
      } else {
        throw "Error al capturar la imagen";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el gráfico: $e')),
      );
    }
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

  // metodo para crear el graficos

  String _abbreviateName(String name) {
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0]} ${parts[1][0]}.';
    }
    return name; // Devuelve el nombre original si no se puede abreviar
  }

  // Método para crear el gráfico con detalles expandibles
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
              color: Colors.blueAccent,
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
                      color: AppColors.text,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String label = data.keys.elementAt(value.toInt());
                  String abbreviatedLabel =
                      _abbreviateName(label); // Usar nombre abreviado
                  int count =
                      data[label]!; // Obtener la cantidad correspondiente
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 30.0, top: 8.0),
                    child: Transform.rotate(
                      angle: -0.4854, // Rotación de 45 grados en radianes
                      child: GestureDetector(
                        onTap: () {
                          _showDetails(label,
                              count); // Llama a la función para mostrar detalles
                        },
                        child: Text(
                          abbreviatedLabel, // Mostrar el texto abreviado
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  // Método para mostrar detalles de la barra seleccionada
  void _showDetails(String label, int count) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de $label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Dato seleccionado: $label: tiene: $count reservas'), // Mostrar cantidad
              // Puedes agregar más widgets aquí para mostrar información adicional
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
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
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total de terapias con reservas: $totalTherapiesWithReservations',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.secondary,
              ),
            ),
            Text(
              'Total de terapeutas con reservas: $totalTherapistsWithReservations',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
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
