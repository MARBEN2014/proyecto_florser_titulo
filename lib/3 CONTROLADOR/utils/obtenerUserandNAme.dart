import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Función para obtener el ID del usuario
Future<String?> getUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid; // Retorna el ID del usuario
  }
  return null; // Si no hay usuario logueado
}

// Función para obtener solo el nombre del usuario
Future<String?> fetchUserName() async {
  final userId = await getUserId();
  if (userId != null) {
    final userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    if (userDoc.exists) {
      final userData = userDoc.data(); // Obtiene los datos del usuario
      return userData?['name'] ??
          'Usuario'; // Retorna el nombre del usuario o 'Usuario' si no existe
    }
  }
  return null; // Si no se encuentra el usuario o el documento
}
