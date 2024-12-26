import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/serviciosdeFIreestore.dart';

import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';

class HorasTerapeutasScreen extends StatefulWidget {
  const HorasTerapeutasScreen({super.key});

  @override
  _HorasTerapeutasScreenState createState() => _HorasTerapeutasScreenState();
}

class _HorasTerapeutasScreenState extends State<HorasTerapeutasScreen> {
  final reservationsService =
      ReservationsService(); // Servicio para manejar reservas
  final TextEditingController _searchController =
      TextEditingController(); // Controlador para el campo de búsqueda
  Future<List<Map<String, dynamic>>>? _searchResults; // Resultados de búsqueda

  // Método para buscar reservas de un terapeuta específico
  void _searchTherapist(String therapistName) {
    setState(() {
      _searchResults =
          reservationsService.getReservationsForTherapist(therapistName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWelcome(), // Barra de aplicación personalizada
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda para ingresar el nombre del terapeuta
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar terapeuta',
                hintText: 'Ingrese el nombre del terapeuta',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchTherapist(value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Resultados de la búsqueda
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para construir los resultados de la búsqueda
  Widget _buildSearchResults() {
    if (_searchResults == null) {
      return const Center(
        child: Text(
          'Ingrese un nombre para buscar reservas.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error al cargar las reservas.',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron reservas para este terapeuta.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final reservations = snapshot.data!;
        final now = DateTime.now();

        // Filtrar citas pasadas y futuras
        final pastReservations = reservations
            .where((reservation) => reservation['date'].toDate().isBefore(now))
            .toList();
        final upcomingReservations = reservations
            .where((reservation) => reservation['date'].toDate().isAfter(now))
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mostrar citas futuras
              const Text(
                'Citas Futuras:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._buildReservationList(
                  upcomingReservations, Colors.greenAccent),

              const SizedBox(height: 16),

              // Mostrar citas pasadas
              const Text(
                'Citas Pasadas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._buildReservationList(pastReservations, Colors.redAccent),
            ],
          ),
        );
      },
    );
  }

  // Construir la lista de reservas con color personalizado
  List<Widget> _buildReservationList(
      List<Map<String, dynamic>> reservations, Color cardColor) {
    if (reservations.isEmpty) {
      return [
        const Center(
          child: Text(
            'No hay reservas en esta categoría.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
      ];
    }

    return reservations.map((reservation) {
      final serviceName = reservation['service_name'] ?? 'Servicio desconocido';
      final userName = reservation['user_name'] ?? 'Usuario desconocido';
      final timestamp = reservation['date'];
      final time = reservation['time'] ?? 'Hora no disponible';

      DateTime dateTime = timestamp.toDate();
      String formattedDate =
          '${dateTime.day} de ${_getMonthName(dateTime.month)} ${dateTime.year}';
      String formattedTime = '${time.substring(0, 5)}';

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: cardColor,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(serviceName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Usuario: $userName', style: const TextStyle(fontSize: 14)),
              Text('Fecha: $formattedDate',
                  style: const TextStyle(fontSize: 14)),
              Text('Hora: $formattedTime',
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      );
    }).toList();
  }

  // Método auxiliar para obtener el nombre del mes
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
