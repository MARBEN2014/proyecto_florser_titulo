import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final uid = user.uid; // El ID del usuario
    return uid;
  } else {
    return null; // Si no hay usuario logueado
  }
}

Future<Map<String, dynamic>?> fetchUserData() async {
  final userId = await getUserId();
  if (userId != null) {
    final userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return userDoc.data(); // Retorna los datos del usuario si los encuentra
  }
  return null; // Si no se encuentra el usuario
}
