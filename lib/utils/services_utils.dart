// import 'package:intl/intl.dart';

// // Función que calcula los días válidos según los días de la semana seleccionados
// List<String> getAvailableDays(int year, int month, List<String> weekDays) {
//   List<String> validDays = [];
//   DateTime startDate = DateTime(year, month, 1);
//   int daysInMonth = DateTime(year, month + 1, 0).day;

//   // Iteramos sobre todos los días del mes
//   for (int day = 1; day <= daysInMonth; day++) {
//     DateTime currentDay = DateTime(year, month, day);
//     String dayOfWeek =
//         DateFormat('EEEE').format(currentDay); // Obtenemos el día de la semana

//     // Si el día de la semana está en las opciones disponibles, lo agregamos
//     if (weekDays.contains(dayOfWeek)) {
//       validDays.add(DateFormat('dd/MM/yyyy')
//           .format(currentDay)); // Agregamos la fecha en formato dd/MM/yyyy
//     }
//   }
//   return validDays;
// }

// // Función que actualiza los días disponibles en el mapa de servicios
// void updateServiceData(Map<String, Map<String, dynamic>> servicesData) {
//   DateTime now = DateTime.now();
//   int currentMonth = now.month;
//   int currentYear = now.year;

//   // Iteramos sobre los servicios y actualizamos sus días disponibles
//   servicesData.forEach((service, data) {
//     List<String> availableDays = List.from(data['availableDays']);

//     // Filtramos los días disponibles según el mes actual
//     List<String> validDays =
//         getAvailableDays(currentYear, currentMonth, availableDays);

//     // Actualizamos los días disponibles para el servicio
//     if (servicesData[service] != null) {
//       servicesData[service]!['availableDays'] = validDays;
//     }
//   });
// }
