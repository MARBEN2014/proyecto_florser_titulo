import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Función para guardar los datos del gráfico
  Future<void> saveGraphData(
      Map<String, int> therapyData, String monthYear) async {
    try {
      // Guardar los datos en la colección 'graficos' con un documento basado en el mes y año
      await _db.collection('graficos').doc(monthYear).set({
        'month_year': monthYear,
        'therapy_data': therapyData,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Datos del gráfico guardados con éxito");
    } catch (e) {
      print("Error al guardar los datos del gráfico: $e");
    }
  }
}
