// import 'package:flutter/material.dart';
// import 'package:paraflorseer/descripcion_servicios/descriptions_beauty.dart';
// import 'package:paraflorseer/ruta_welcome_screen/booking_screen.dart';
// import 'package:paraflorseer/themes/app_colors.dart';
// import 'package:paraflorseer/themes/app_text_styles.dart';

// class CustomBodyWidget extends StatelessWidget {
//   final List<String> imagePaths;
//   final List<String> descriptions;
//   final Function(String) onServiceSelected; // Nueva función callback

//   const CustomBodyWidget({
//     Key? key,
//     required this.imagePaths,
//     required this.descriptions,
//     required this.onServiceSelected, // Recibe el callback
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 20),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Servicios de',
//                     style: AppTextStyles.bodyTextStyle.copyWith(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.text,
//                     ),
//                   ),
//                   Text(
//                     '  Belleza',
//                     style: AppTextStyles.bodyTextStyle.copyWith(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             GridView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 10.0,
//                 childAspectRatio: 0.6,
//               ),
//               itemCount: imagePaths.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   height: 350,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: 180,
//                         decoration: const BoxDecoration(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(10)),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(10)),
//                           child: imagePaths[index].startsWith('http')
//                               ? Image.network(
//                                   imagePaths[index],
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 )
//                               : Image.asset(
//                                   imagePaths[index],
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                 ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10.0),
//                         child: Text(
//                           descriptionsBeauty[index],
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.bodyTextStyle,
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Definir los terapeutas y horarios basados en el servicio (descripción)
//                           final String serviceName = descriptionsBeauty[index];
//                           List<String> therapists = [];
//                           List<String> availableTimes = [];
//                           List<String> availableDays = [
//                             'Lunes',
//                             'Martes',
//                             'Miércoles',
//                             'Jueves',
//                             'Viernes'
//                           ];

//                           // Comparar los nombres de servicios de forma precisa
//                           if (serviceName == 'Masaje') {
//                             therapists = ['María González', 'Juan Pérez'];
//                             availableTimes = [
//                               '10:00 AM',
//                               '12:00 PM',
//                               '4:00 PM'
//                             ];
//                           } else if (serviceName == 'yoga') {
//                             therapists = ['Laura vasquez', 'Carlos verdejo'];
//                             availableTimes = [
//                               '14:00 AM',
//                               '15:00 AM',
//                               '16:00 PM'
//                             ];
//                           } else if (serviceName == 'Relajante') {
//                             therapists = ['Laura Gómez', 'Carlos Ruiz'];
//                             availableTimes = ['9:00 AM', '11:00 AM', '3:00 PM'];
//                           } else if (serviceName == 'capilar nutritivo') {
//                             therapists = ['Ana López', 'Pedro Díaz'];
//                             availableTimes = ['1:00 PM', '5:00 PM', '7:00 PM'];
//                           } else {
//                             print("Servicio no reconocido");
//                           }

//                           // Navegar a la pantalla de BookingScreen con los argumentos
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BookingScreen(
//                                 serviceName: serviceName,
//                                 therapists: therapists,
//                                 availableTimes: availableTimes,
//                                 availableDays: availableDays,
//                               ),
//                             ),
//                           );

//                           // Llamamos al callback cuando se selecciona un servicio
//                         },
//                         child: const Text('Agendar Cita'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.secondary,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 20.0),
//                           textStyle: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           fixedSize: const Size(150, 40),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
