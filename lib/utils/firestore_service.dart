import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Función para obtener ranking por terapia y terapeuta
  Future<Map<String, Map<String, int>>> getTherapyAndTherapistRanking() async {
    try {
      // Obtener los documentos de la colección 'reservations' (cada documento es un terapeuta)
      final reservationsSnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      print(
          'Datos obtenidos de reservations: ${reservationsSnapshot.docs.length} documentos');

      // Mapa para almacenar el conteo por terapia y terapeuta
      Map<String, Map<String, int>> therapyTherapistCounts = {};

      for (var therapistDoc in reservationsSnapshot.docs) {
        // El nombre del terapeuta está dado por el nombre del documento
        final therapistName = therapistDoc.id;
        print('Procesando terapeuta: $therapistName');

        // Obtener la subcolección 'appointments' de cada terapeuta
        final appointmentsSnapshot =
            await therapistDoc.reference.collection('appointments').get();

        print(
            'Citas obtenidas para $therapistName: ${appointmentsSnapshot.docs.length}');

        // Verificar si las citas están vacías
        if (appointmentsSnapshot.docs.isEmpty) {
          print('No se encontraron citas para el terapeuta $therapistName');
          // Agregar el terapeuta aunque no tenga citas
          if (!therapyTherapistCounts.containsKey('No Therapy')) {
            therapyTherapistCounts['No Therapy'] = {};
          }
          therapyTherapistCounts['No Therapy']![therapistName] = 0;
        } else {
          // Procesar las citas de este terapeuta
          for (var appointmentDoc in appointmentsSnapshot.docs) {
            // Extraer los campos necesarios
            String? therapy = appointmentDoc.data()['service_name'];
            String? therapist = appointmentDoc.data()['therapist'];

            print('Terapia: $therapy, Terapeuta: $therapist');

            if (therapy == null || therapist == null) {
              print('Registro incompleto para cita. Se omite este documento.');
              continue; // Ignorar registros incompletos
            }

            // Incrementar el conteo en el mapa
            if (!therapyTherapistCounts.containsKey(therapy)) {
              therapyTherapistCounts[therapy] = {};
              print('Se ha agregado nueva terapia: $therapy');
            }

            if (therapyTherapistCounts[therapy]!.containsKey(therapist)) {
              therapyTherapistCounts[therapy]![therapist] =
                  therapyTherapistCounts[therapy]![therapist]! + 1;
              print('Se ha incrementado el conteo de citas para $therapist');
            } else {
              therapyTherapistCounts[therapy]![therapist] = 1;
              print(
                  'Se ha agregado terapeuta $therapist para la terapia $therapy');
            }
          }
        }
      }

      print('Ranking final: $therapyTherapistCounts');
      return therapyTherapistCounts;
    } catch (e) {
      print('Error al obtener ranking: $e');
      return {};
    }
  }
}
