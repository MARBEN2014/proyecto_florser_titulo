// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:paraflorseer/themes/app_colors.dart';
// import 'package:paraflorseer/widgets/custom_app_bar.dart';
// import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';

// class UpdatePasswordScreen extends StatefulWidget {
//   @override
//   _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
// }

// class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   String _errorMessage = '';
//   String? _userName;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   // Obtener los datos del usuario
//   Future<void> _fetchUserData() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('user')
//           .doc(user.uid)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           _userName = userDoc.data()?['name'] ?? 'Usuario';
//         });
//       }
//     }
//   }

//   // Función para actualizar la contraseña
//   Future<void> _updatePassword() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       setState(() {
//         _errorMessage = 'Las contraseñas no coinciden';
//       });
//       return;
//     }

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await user.updatePassword(_passwordController.text);
//         await user.reload();
//         setState(() {
//           _errorMessage = 'Contraseña actualizada correctamente';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error al actualizar la contraseña';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondary,
//       appBar: const CustomAppBar(
//         showNotificationButton: true,
//         title: 'Actualizar Contraseña',
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   _userName != null ? 'Hola, $_userName' : 'Hola, Usuario',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Actualizar tu contraseña:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Campo para nueva contraseña
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Nueva Contraseña',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
//                   ),
//                 ),
//               ),

//               // Campo para confirmar contraseña
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: TextField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Confirmar Contraseña',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Botón para actualizar la contraseña
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Ejecuta la lógica de actualización de contraseña (si aplica)
//                     _updatePassword();

//                     // Redirige a la página especificada
//                     Navigator.pushNamed(context, '/login');
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 15,
//                     ),
//                   ),
//                   child: const Text(
//                     'Actualizar Contraseña',
//                     style: TextStyle(fontSize: 16, color: AppColors.secondary),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBarUser(),
//     );
//   }
// }
