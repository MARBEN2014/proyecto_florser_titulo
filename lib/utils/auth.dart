// creacion de una cuenta y el inicio de sesionde una cuenta

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:paraflorseer/preferencias/pref_usuarios.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//metodo para la creacion de la cuenta
  Future createAccount(String correo, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: correo, password: pass);
      print(userCredential.user);
      return (userCredential.user?.uid);
      //se guarda el id del usuario
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 1;
        // para saber si el correoya esta en uso en la app
      } else if (e.code == 'email-already-in use') {
        print('The account already exist for that email');
        return 2;
      }
      // si error no esta en la logica de arriba mostrara un error general
    } catch (e) {
      print(e);
    }
  }

// para iniciar sesion

  Future singInEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // se crea un uid unicom para cada usuario
      //obtener el usuario
      final a = userCredential.user;
      if (a?.uid != null) {
        return a?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      }
    }
  }

  // // Método para cerrar sesión
  // Future<void> signOut() async {
  //   await _auth.signOut(); // Cierra la sesión en Firebase
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('is_logged_in', false);
  //   PreferenciasUsuarios().ultimaPagina =
  //       '/login'; // Restablecer a la pantalla de inicio de sesión
  // }
}
