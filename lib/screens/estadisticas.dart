// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart'; // Paquete para gráficos
// import 'package:paraflorseer/widgets/custom_app_bar.dart';
// import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
// import 'package:paraflorseer/themes/app_colors.dart';

// class DemandStatsScreen extends StatefulWidget {
//   const DemandStatsScreen({super.key});

//   @override
//   _DemandStatsScreenState createState() => _DemandStatsScreenState();
// }

// class _DemandStatsScreenState extends State<DemandStatsScreen> {
//   Map<String, int> therapyCount = {};
//   Map<String, int> therapistCount = {};
//   Map<String, int> dayCount = {};
//   Map<String, int> timeCount = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchStats();
//   }

//   Future<void> _fetchStats() async {
//     final DateTime now = DateTime.now();
//     final DateTime lastDay = now.add(const Duration(days: 28));

//     try {
//       QuerySnapshot reservations = await FirebaseFirestore.instance
//           .collectionGroup('Reservas')
//           .where('day', isGreaterThanOrEqualTo: now.toIso8601String())
//           .where('day', isLessThanOrEqualTo: lastDay.toIso8601String())
//           .get();

//       Map<String, int> therapies = {};
//       Map<String, int> therapists = {};
//       Map<String, int> days = {};
//       Map<String, int> times = {};

//       for (var doc in reservations.docs) {
//         final data = doc.data() as Map<String, dynamic>;

//         String therapy = data['service_name'] ?? 'Desconocido';
//         String therapist = data['therapist'] ?? 'Desconocido';
//         String day = data['day'] ?? 'Desconocido';
//         String time = data['time'] ?? 'Desconocido';

//         therapies[therapy] = (therapies[therapy] ?? 0) + 1;
//         therapists[therapist] = (therapists[therapist] ?? 0) + 1;
//         days[day] = (days[day] ?? 0) + 1;
//         times[time] = (times[time] ?? 0) + 1;
//       }

//       setState(() {
//         therapyCount = therapies;
//         therapistCount = therapists;
//         dayCount = days;
//         timeCount = times;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al obtener datos: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       appBar: const CustomAppBar(),
//       body: RefreshIndicator(
//         onRefresh: _fetchStats,
//         child: therapyCount.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   Text(
//                     'Terapias más demandadas',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                   _buildBarChart(therapyCount, 'Terapias'),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Terapeutas más demandados',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                   _buildBarChart(therapistCount, 'Terapeutas'),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Días más demandados',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                   _buildBarChart(dayCount, 'Días'),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Horarios más demandados',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                   _buildBarChart(timeCount, 'Horarios'),
//                 ],
//               ),
//       ),
//       bottomNavigationBar: const BottomNavBar(),
//     );
//   }

//   Widget _buildBarChart(Map<String, int> data, String label) {
//     final List<BarChartGroupData> barGroups = data.entries
//         .map(
//           (entry) => BarChartGroupData(
//             x: data.keys.toList().indexOf(entry.key),
//             barRods: [
//               BarChartRodData(
//                 y: entry.value.toDouble(),
//                 color: [AppColors.primary],
//                 width: 16, 
//               ),
//             ],
//             showingTooltipIndicators: [0],
//           ),
//         )
//         .toList();

//     return SizedBox(
//       height: 300,
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           titlesData: FlTitlesData(
//             leftTitles: SideTitles(showTitles: true),
//             bottomTitles: SideTitles(
//               showTitles: true,
//               getTitles: (value) {
//                 final index = value.toInt();
//                 if (index < data.keys.length) {
//                   return data.keys.toList()[index];
//                 }
//                 return ''; // Devuelve una cadena vacía si el índice no es válido
//               },
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           barGroups: barGroups,
//         ),
//       ),
//     );
//   }
// }
