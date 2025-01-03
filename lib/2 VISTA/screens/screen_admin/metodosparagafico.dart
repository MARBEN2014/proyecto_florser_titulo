// therapy_helpers.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';

class TherapyHelpers {
  // Función para manejar errores al cargar los datos
  static Widget buildErrorUI() {
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
  static Widget buildNoDataUI(Function refresh) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('No hay datos disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => refresh(),
          child: const Text('Refrescar'),
        ),
      ],
    );
  }

  // Método para abreviar nombres
  static String abbreviateName(String name) {
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0]} ${parts[1][0]}.';
    }
    return name; // Devuelve el nombre original si no se puede abreviar
  }

  // Método para construir la gráfica de barras de las terapias
  static Widget buildBarChart(Map<String, int> data) {
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
                  String abbreviatedLabel = TherapyHelpers.abbreviateName(
                      label); // Usar nombre abreviado
                  int count =
                      data[label]!; // Obtener la cantidad correspondiente
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 30.0, top: 8.0),
                    child: Transform.rotate(
                      angle: -0.4854, // Rotación de 45 grados en radianes
                      child: GestureDetector(
                        onTap: () {
                          showDetails(
                              label, count); // Mostrar detalles al hacer click
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
  static void showDetails(String label, int count) {
    // Mostrar detalles del gráfico en un cuadro de diálogo
  }

  // Método para obtener los datos del ranking de las terapias (total de reservas por terapia)
  static Map<String, int> getTherapyData(
      Map<String, Map<String, int>> ranking) {
    Map<String, int> therapyData = {};
    ranking.forEach((therapy, therapists) {
      int totalReservations =
          therapists.values.fold(0, (sum, count) => sum + count);
      // Solo se agregan terapias con al menos 1 cita
      if (totalReservations > 9) {
        therapyData[therapy] = totalReservations;
      }
    });
    return therapyData;
  }
}
