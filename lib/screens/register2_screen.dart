// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:paraflorseer/screens/screens.dart';
// import 'package:paraflorseer/themes/app_colors.dart';
// import 'package:paraflorseer/widgets/bottom_nav_bar.dart';
// import 'package:paraflorseer/widgets/custom_app_bar.dart';

// class Register2Screen extends StatefulWidget {
//   const Register2Screen({super.key});

//   @override
//   _Register2ScreenState createState() => _Register2ScreenState();
// }

// class _Register2ScreenState extends State<Register2Screen> {
//   final _formKeyPage2 = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _birthDateController = TextEditingController();
//   final TextEditingController _rutController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _phoneController =
//       TextEditingController(text: ' +569 '); // Prellenar con +569 y espacio

//   DateTime? _selectedDate;
//   String? _selectedSex;

//   // Función para capitalizar la primera letra de cada palabra
//   String capitalize(String value) {
//     if (value.isEmpty) return value;
//     return value
//         .split(' ')
//         .map((word) => word.isNotEmpty
//             ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
//             : word)
//         .join(' ');
//   }

//   // Función para formatear el RUT automáticamente
//   String formatRut(String rut) {
//     String cleanedRut = rut.replaceAll(RegExp(r'[^0-9kK]'), '');
//     if (cleanedRut.length < 2) return cleanedRut;

//     String verifier = cleanedRut.substring(cleanedRut.length - 1);
//     String digits = cleanedRut.substring(0, cleanedRut.length - 1);

//     StringBuffer formattedRut = StringBuffer();
//     for (int i = 0; i < digits.length; i++) {
//       if (i > 0 && (digits.length - i) % 3 == 0) {
//         formattedRut.write('.');
//       }
//       formattedRut.write(digits[i]);
//     }

//     return '${formattedRut.toString()}-$verifier';
//   }

//   Future<void> _refreshPage() async {
//     // Simulación de tiempo de espera para la acción de refresco
//     await Future.delayed(const Duration(seconds: 2));
//     // Aquí puedes agregar más lógica si es necesario
//   }

//   void _register() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.primary, // Fondo del color primario
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.check_circle,
//                   color: AppColors.secondary, // Ícono del color secundario
//                   size: 50,
//                 ),
//                 const SizedBox(height: 16.0),
//                 const Text(
//                   '¡Registro completado con éxito!',
//                   style: TextStyle(
//                     color: AppColors.secondary, // Texto del color secundario
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Primero cerramos el cuadro de diálogo
//                     Navigator.of(context).pop();
//                     // Luego navegamos a la página de UserProfileScreen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const UserProfileScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: AppColors.primary,
//                     backgroundColor: AppColors
//                         .secondary, // Texto del botón del color primario
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKeyPage2,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 16.0),
//                   child: Text(
//                     'Continuar con el registro...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nombres',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tus nombres';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _firstNameController.text = capitalize(value);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Apellidos',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tus apellidos';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _lastNameController.text = capitalize(value);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16.0),

//                 TextFormField(
//                   controller: _birthDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Fecha de nacimiento',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     final date = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedDate ?? DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (date != null) {
//                       setState(() {
//                         _selectedDate = date;
//                         _birthDateController.text =
//                             "${date.day}/${date.month}/${date.year}";
//                       });
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Rut con formato y dígito verificador
//                 TextFormField(
//                   controller: _rutController,
//                   decoration: const InputDecoration(
//                     labelText: 'RUT (sin puntos ni guion)',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu RUT';
//                     }
//                     return null;
//                   },
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(9),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _rutController.text = formatRut(value);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Dirección',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu dirección';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Teléfono',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor ingresa tu teléfono';
//                     }
//                     return null;
//                   },
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(11),
//                   ],
//                 ),
//                 const SizedBox(height: 16.0),
//                 DropdownButtonFormField<String>(
//                   value: _selectedSex,
//                   decoration: const InputDecoration(
//                     labelText: 'Sexo',
//                     labelStyle: TextStyle(color: AppColors.text),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.primary),
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                     ),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: 'M', child: Text('Masculino')),
//                     DropdownMenuItem(value: 'F', child: Text('Femenino')),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedSex = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Por favor selecciona tu sexo';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     minimumSize: const Size(150, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_formKeyPage2.currentState!.validate()) {
//                       _register();
//                     }
//                   },
//                   child: const Text(
//                     'Registrar',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBar(),
//     );
//   }
// }
