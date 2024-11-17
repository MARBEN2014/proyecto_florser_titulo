import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getReservationsForTherapist(
      String therapistName) async {
    try {
      // Obtener las reservas del terapeuta
      final querySnapshot = await _firestore
          .collection('reservations')
          .doc(therapistName)
          .collection('appointments')
          .get();

      // Procesar las reservas
      List<Map<String, dynamic>> reservations = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final userId =
            data['user_id']; // Asumiendo que tienes el user_id en cada reserva

        // Obtener el nombre del usuario usando el userId
        String userName = 'Usuario desconocido';
        if (userId != null && userId.isNotEmpty) {
          DocumentSnapshot userDoc =
              await _firestore.collection('user').doc(userId).get();
          if (userDoc.exists) {
            userName = userDoc['name'] ?? 'Usuario desconocido';
          }
        }

        // Añadir la reserva con el nombre del usuario
        reservations.add({
          'id': doc.id,
          'service_name': data['service_name'],
          'date': data['date'],
          'time': data['time'],
          'user_name': userName, // Incluir el nombre del usuario
        });
      }

      return reservations;
    } catch (e) {
      print('Error fetching reservations for therapist: $e');
      return [];
    }
  }
}
