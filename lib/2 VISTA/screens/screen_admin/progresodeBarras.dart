// Importaciones necesarias para el funcionamiento del archivo
import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/serviciosdeFIreestore.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/3%20CONTROLADOR/utils/firestore_service.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart';
import 'package:paraflorseer/2%20VISTA/widgets/refresh.dart';

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
      backgroundColor: AppColors.secondary,
      appBar: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? const CustomAppBarWelcome() // Mostrar AppBar solo en orientación vertical
          : null, // No mostrar AppBar en orientación horizontal // Barra de navegación personalizada
      body: RefreshableWidget(
        onRefresh: _handleRefresh,
        child: FutureBuilder<Map<String, Map<String, int>>>(
          // Construcción de FutureBuilder para la carga de datos
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
            // Primer gráfico: Reservas por Terapia
            _buildStatGrid(
              title: 'Reservas por Terapias',
              data: ranking.map((key, value) {
                final total = value.values.fold(0, (sum, count) => sum + count);
                return MapEntry(key, total);
              }),
              color: AppColors.text, // Color para terapias
              backgroundColor:
                  AppColors.therapyBackground, // Fondo específico para terapias
            ),
            const SizedBox(height: 16),
            // Segundo gráfico: Reservas por Terapeuta
            _buildStatGrid(
              title: 'Reservas por Terapeutas',
              data: _aggregateTherapistData(ranking),
              color: AppColors.text, // Color para terapeutas
              backgroundColor: AppColors
                  .therapistBackground, // Fondo específico para terapeutas
            ),
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

  /// Construcción de una cuadrícula de estadísticas con título
  Widget _buildStatGrid({
    required String title,
    required Map<String, int> data,
    required Color color, // Nuevo parámetro para especificar color
    required Color backgroundColor, // Fondo específico para las tarjetas
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final entry = data.entries.elementAt(index);
            final percentage =
                (entry.value / data.values.reduce((a, b) => a + b) * 100)
                    .toInt();
            return Card(
              elevation: 8, // Reducido para un estilo más sutil
              color: backgroundColor, // Color de fondo de la tarjeta específico
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12), // Bordes redondeados para una apariencia más suave
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CircularProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: AppColors.primary,
                      color: color, // Color aplicado aquí
                    ),
                    const SizedBox(height: 8),
                    Text('$percentage%', style: TextStyle(color: color)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Agrega los datos de reservas por terapeuta en una sola estructura
  Map<String, int> _aggregateTherapistData(
      Map<String, Map<String, int>> ranking) {
    final therapistData = <String, int>{};
    ranking.forEach((_, therapists) {
      therapists.forEach((therapist, count) {
        therapistData[therapist] = (therapistData[therapist] ?? 0) + count;
      });
    });
    return therapistData;
  }
}
