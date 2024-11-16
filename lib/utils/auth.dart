import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paraflorseer/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para la creación de la cuenta
  Future createAccount(String correo, String pass, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: correo, password: pass);

      // Verificar si el usuario fue creado exitosamente
      if (userCredential.user != null) {
        // Enviar el correo de verificación
        await userCredential.user?.sendEmailVerification();
        showSnackBar(context,
            "Correo de verificación enviado. Por favor, revisa tu bandeja de entrada.");

        print("Correo de verificación enviado a $correo");

        // Retornar el UID del usuario creado
        return userCredential.user?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 1; // Contraseña débil
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(
            context, " El correo ya está en uso. Intenta con uno diferente.");
        print('The account already exists for that email');
        return 2; // El correo ya está en uso
      }
    } catch (e) {
      print(e);
    }
  }

  // Método para iniciar sesión con roles
  Future<Map<String, dynamic>> signInEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Autenticar con Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      // Verificar si el correo está verificado
      if (user != null && !user.emailVerified) {
        showSnackBar(
            context, "Correo no verificado. Revisa tu bandeja de entrada.");
        return {
          "success": false,
          "message": "Correo no verificado. Revisa tu bandeja de entrada."
        };
      }

      // Verificar el uid del usuario
      print("UID del usuario autenticado: ${user?.uid}"); // Depuración

      // Si la autenticación es exitosa, recuperar el rol del usuario desde Firestore
      if (user?.uid != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(user?.uid).get();

        // Depuración: Verificar si el documento del usuario existe
        print(
            "Documento del usuario obtenido: ${userDoc.exists}"); // Depuración

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Depuración: Verificar los datos del usuario
          print("Datos del usuario desde Firestore: $userData"); // Depuración

          String? role = userData['role']; // Recuperar el rol del usuario

          // Depuración: Verificar el rol
          print("Rol del usuario: $role"); // Depuración

          if (role != null) {
            showSnackBar(context, "Sesión iniciada como $role.");
            return {"success": true, "uid": user?.uid, "role": role};
          } else {
            showSnackBar(context, "Rol no asignado.");
            return {
              "success": false,
              "message": "Rol no asignado. Contacta al administrador."
            };
          }
        } else {
          // El documento no existe
          showSnackBar(context, "Usuario no encontrado en la base de datos.");
          return {
            "success": false,
            "message": "Usuario no encontrado en la base de datos."
          };
        }
      }

      return {"success": false, "message": "No se pudo iniciar sesión."};
    } on FirebaseAuthException catch (e) {
      // Manejo de errores
      if (e.code == 'user-not-found') {
        return {"success": false, "message": "Usuario no encontrado."};
      } else if (e.code == 'wrong-password') {
        showSnackBar(
            context, "Contraseña incorrecta. Ingresa una contraseña válida.");
        return {"success": false, "message": "Contraseña incorrecta."};
      } else {
        return {
          "success": false,
          "message": e.message ?? "Ocurrió un error inesperado."
        };
      }
    }
  }
}












































  // Método para iniciar sesión
  // Future signInEmailAndPassword(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);

  //     // Obtener el usuario autenticado
  //     User? user = userCredential.user;

  //     // Si el correo no está verificado, mostrar un mensaje y no permitir el inicio de sesión
  //     if (user != null && !user.emailVerified) {
  //       showSnackBar(
  //           context, " Correo no verificado, revisa tu bandeja de entrada .");
  //       print("Correo no verificado. Por favor, revisa tu correo.");

  //       return {
  //         "success": false,
  //         "message": "Correo no verificado. Revisa tu bandeja de entrada."
  //       };
  //     }

  //     // Si el correo está verificado, continuar con el inicio de sesión
  //     if (user?.uid != null) {
  //       showSnackBar(context, "Sesion inicida de manera satisfactoria ");
  //       return {"success": true, "uid": user?.uid};
  //     }

  //     return {"success": false, "message": "No se pudo iniciar sesión."};
  //   } on FirebaseAuthException catch (e) {
  //     // Manejo de errores de inicio de sesión
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //       return {"success": false, "message": "Usuario no encontrado."};
  //     } else if (e.code == 'wrong-password') {
  //       showSnackBar(
  //           context, "Contraseña incorrecta. Ingresa una contraseña valida");
  //       print('Wrong password provided for that user.');
  //       return {"success": false, "message": "Contraseña incorrecta."};
  //     } else {
  //       return {
  //         "success": false,
  //         "message": e.message ?? "Ocurrió un error inesperado."
  //       };
  //     }
  //   }
  // }




  // Método para cerrar sesión (comentado por ahora)
  // Future<void> signOut() async {
  //   await _auth.signOut(); // Cierra la sesión en Firebase
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('is_logged_in', false);
  //   PreferenciasUsuarios().ultimaPagina =
  //       '/login'; // Restablecer a la pantalla de inicio de sesión
  // }

