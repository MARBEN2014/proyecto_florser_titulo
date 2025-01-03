import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Map<String, dynamic>>>? _searchResults;
  bool _isSearching = false; // Variable para saber si estamos buscando

  // Método para iniciar la búsqueda de reservas e historial
  void _searchUserReservations(String userName) {
    setState(() {
      _searchResults = _fetchUserReservations(userName);
      _isSearching = true; // Activar la búsqueda cuando se presiona el botón
    });
  }

  // Método para obtener datos desde Firestore
  Future<List<Map<String, dynamic>>> _fetchUserReservations(
      String userName) async {
    final List<Map<String, dynamic>> results = [];

    try {
      final userCollection = FirebaseFirestore.instance.collection('user');

      // Obtener todos los usuarios y verificar coincidencias de nombre
      final userSnapshot = await userCollection.get();

      for (var userDoc in userSnapshot.docs) {
        final userData = userDoc.data();
        final userId = userDoc.id;
        final name = userData['name'] ?? '';

        // Verificar coincidencias a partir de la segunda letra del nombre
        if (name.toLowerCase().contains(userName.toLowerCase().substring(1))) {
          // Obtener subcolección de Reservas
          final reservationsSnapshot =
              await userCollection.doc(userId).collection('Reservas').get();

          for (var reservationDoc in reservationsSnapshot.docs) {
            results.add({
              'service_name': reservationDoc['service_name'],
              'date': reservationDoc['day'],
              'time': reservationDoc['time'],
              'user_name': name,
              'type': 'Reserva'
            });
          }

          // Obtener subcolección de Historial
          final historySnapshot =
              await userCollection.doc(userId).collection('history').get();

          for (var historyDoc in historySnapshot.docs) {
            results.add({
              'service_name': historyDoc['service_name'],
              'date': historyDoc['day'],
              'time': historyDoc['time'],
              'user_name': name,
              'type': 'Historial'
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error al obtener datos: $e');
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? const CustomAppBarWelcome() // Mostrar AppBar solo en orientación vertical
          : null, // No mostrar AppBar en orientación horizontal
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar usuario',
                hintText: 'Ingrese el nombre del usuario',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botón para activar la búsqueda
            ElevatedButton(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  _searchUserReservations(_searchController.text);
                }
              },
              child: const Text('Buscar'),
            ),

            const SizedBox(height: 16),

            // Resultados de búsqueda
            _isSearching
                ? Expanded(
                    child: _buildSearchResults(),
                  )
                : const Center(
                    child: Text(
                      'Presione buscar para ver los resultados.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Construir los resultados de búsqueda
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
              'Error al cargar los datos.',
              style: TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron datos para este usuario.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final data = snapshot.data!;
        final reservas =
            data.where((entry) => entry['type'] == 'Reserva').toList();
        final historial =
            data.where((entry) => entry['type'] == 'Historial').toList();

        return ListView(
          children: [
            if (reservas.isNotEmpty) ...[
              _buildSectionTitle('Reservas'),
              ...reservas
                  .map((entry) => _buildCard(entry, Colors.greenAccent))
                  .toList(),
            ],
            if (historial.isNotEmpty) ...[
              _buildSectionTitle('Historial'),
              ...historial
                  .map((entry) => _buildCard(entry, Colors.amber))
                  .toList(),
            ],
          ],
        );
      },
    );
  }

  // Construir el título de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Construir las tarjetas de información
  Widget _buildCard(Map<String, dynamic> entry, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: color,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          entry['service_name'] ?? 'Servicio desconocido',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: ${entry['user_name'] ?? 'Desconocido'}',
                style: const TextStyle(fontSize: 14)),
            Text('Fecha: ${entry['date'] ?? 'Fecha no disponible'}',
                style: const TextStyle(fontSize: 14)),
            Text('Hora: ${entry['time'] ?? 'Hora no disponible'}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
