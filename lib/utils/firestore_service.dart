import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Función para obtener ranking por terapia y terapeuta
  Future<Map<String, Map<String, int>>> getTherapyAndTherapistRanking() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      // Mapa para almacenar el conteo por terapia y terapeuta
      Map<String, Map<String, int>> therapyTherapistCounts = {};

      for (var doc in snapshot.docs) {
        String therapy = doc['therapy'];
        String therapist = doc['therapist'];

        if (!therapyTherapistCounts.containsKey(therapy)) {
          therapyTherapistCounts[therapy] = {};
        }

        if (therapyTherapistCounts[therapy]!.containsKey(therapist)) {
          therapyTherapistCounts[therapy]![therapist] =
              therapyTherapistCounts[therapy]![therapist]! + 1;
        } else {
          therapyTherapistCounts[therapy]![therapist] = 1;
        }
      }

      return therapyTherapistCounts;
    } catch (e) {
      print('Error al obtener ranking: $e');
      return {};
    }
  }
}
