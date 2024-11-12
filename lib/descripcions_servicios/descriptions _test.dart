import 'package:cloud_firestore/cloud_firestore.dart';

class TerapiasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener los campos del documento específico
  Future<Map<String, dynamic>> fetchTerapiasDescripcion() async {
    try {
      // Referencia al documento en Firestore
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firestore
          .collection('descripcion de terapias de belleza')
          .doc('Pue9a9HPn4Fifb7QLuMQ')
          .get();

      if (documentSnapshot.exists) {
        // Obtenemos los datos del documento
        Map<String, dynamic>? data = documentSnapshot.data();
        if (data != null) {
          // Retornamos los datos
          return data;
        } else {
          throw Exception('El documento no tiene datos.');
        }
      } else {
        throw Exception('El documento no existe.');
      }
    } catch (e) {
      print('Error al obtener la descripción de terapias: $e');
      throw Exception('Error al obtener la descripción de terapias.');
    }
  }
}
