import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveAppointment({
  required String serviceName,
  required String selectedTherapist,
  required String selectedTime,
  required String selectedDay,
  required String userName,
}) async {
  // Obtener el usuario actual
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print('El usuario no está autenticado');
    return;
  }

  // Mapa para determinar en qué colección guardar los datos según el servicio
  final serviceCollectionMap = {
    'bienestar': 'servicios_bienestar',
    'guia': 'servicios_guia',
    'sanacion': 'servicios_sanacion',
    'limpieza': 'servicios_limpieza',
    'belleza': 'servicios_belleza',
  };

  // Verificar que el servicio tiene una colección asociada
  final collectionName = serviceCollectionMap[serviceName.toLowerCase()];

  if (collectionName == null) {
    print('No se encontró una colección para el servicio: $serviceName');
    return;
  }

  // Crear un documento en la colección correspondiente
  await FirebaseFirestore.instance.collection(collectionName).add({
    'user_id': user.uid, // ID del usuario que hizo la reserva
    'service_name': serviceName,
    'therapist': selectedTherapist,
    'time': selectedTime,
    'day': selectedDay,
    'user_name': userName,
    'created_at': FieldValue.serverTimestamp(), // Fecha y hora de creación
  });

  print('Cita guardada en la colección: $collectionName');
}
