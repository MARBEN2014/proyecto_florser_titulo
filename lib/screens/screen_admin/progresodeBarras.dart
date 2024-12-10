// Importaciones necesarias para el funcionamiento del archivo
import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/screen_therapist.dart/serviciosdeFIreestore.dart';
import 'package:paraflorseer/utils/firestore_service.dart';
import 'package:paraflorseer/widgets/custom_appbar_back.dart';
import 'package:paraflorseer/widgets/refresh.dart';

/// Pantalla que muestra el progreso de citas (estadísticas de terapias y terapeutas)
class ProgresoDeCitasScreen extends StatefulWidget {
  const ProgresoDeCitasScreen({super.key});

  @override
  _ProgresoDeCitasScreenState createState() => _ProgresoDeCitasScreenState();
}

class _ProgresoDeCitasScreenState extends State<ProgresoDeCitasScreen> {
  // Variable que almacena el futuro con las estadísticas de terapias y terapeutas
  Future<Map<String, Map<String, int>>>? _rankingFuture;
  final reservationsService = ReservationsService();

  @override
  void initState() {
    super.initState();
    // Inicializa la carga de datos desde Firestore
    _rankingFuture = FirestoreService().getTherapyAndTherapistRanking();
  }

  /// Método para manejar la acción de refrescar los datos
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
      appBar:
          const CustomAppbarBack(), // Barra de navegación personalizada con botón de regreso
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
          future: _rankingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtienen los datos
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              // Muestra un mensaje de error si ocurre un problema durante la carga
              return _buildErrorUI();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Muestra un mensaje si no hay datos disponibles
              return _buildNoDataUI();
            }

            // Si los datos están disponibles, construye el contenido
            final ranking = snapshot.data!;
            return _buildContent(ranking);
          },
        ),
      ),
    );
  }

  /// Método que construye la interfaz cuando ocurre un error
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

  /// Método que construye la interfaz cuando no hay datos disponibles
  Widget _buildNoDataUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No hay datos disponibles',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleRefresh,
            child: const Text('Refrescar'),
          ),
        ],
      ),
    );
  }

  /// Método que construye el contenido principal basado en los datos
  Widget _buildContent(Map<String, Map<String, int>> ranking) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTherapyStats(ranking),
            const SizedBox(height: 16),
            _buildTherapistStats(ranking),
          ],
        ),
      ),
    );
  }

  /// Encabezado de la pantalla
  Widget _buildHeader() {
    return Center(
      child: Text(
        'Progreso de Citas',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  /// Sección que muestra estadísticas de reservas por terapia
  Widget _buildTherapyStats(Map<String, Map<String, int>> ranking) {
    return _buildStatSection(
      title: 'Reservas por Terapia',
      data: ranking.map((key, value) {
        final total = value.values.fold(0, (sum, count) => sum + count);
        return MapEntry(key, total);
      }),
    );
  }

  /// Sección que muestra estadísticas de reservas por terapeuta
  Widget _buildTherapistStats(Map<String, Map<String, int>> ranking) {
    final therapistData = <String, int>{};
    ranking.forEach((_, therapists) {
      therapists.forEach((therapist, count) {
        therapistData[therapist] = (therapistData[therapist] ?? 0) + count;
      });
    });

    return _buildStatSection(
      title: 'Reservas por Terapeuta',
      data: therapistData,
    );
  }

  /// Construcción genérica de una sección de estadísticas
  Widget _buildStatSection(
      {required String title, required Map<String, int> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...data.entries.map((entry) {
          final percentage =
              (entry.value / data.values.reduce((a, b) => a + b) * 100).toInt();
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircularProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                color: Theme.of(context).primaryColor,
              ),
              title: Text(entry.key),
              subtitle: Text('${entry.value} reservas ($percentage%)'),
            ),
          );
        }),
      ],
    );
  }
}
