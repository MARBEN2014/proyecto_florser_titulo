import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para interactuar con la base de datos.
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth para autenticar al usuario.
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para UI.
import 'package:paraflorseer/screens/welcome_screen.dart'; // Pantalla de bienvenida para redirigir al usuario tras reservar.
import 'package:table_calendar/table_calendar.dart'; // Calendario interactivo para seleccionar fechas.
import 'package:paraflorseer/themes/app_colors.dart'; // Colores personalizados de la app.
import 'package:paraflorseer/themes/app_text_styles.dart'; // Estilos de texto personalizados.
import 'package:paraflorseer/utils/obtenerUserandNAme.dart'; // Utilidad para obtener el nombre del usuario.
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Barra de navegación personalizada.
//import 'package:intl/intl.dart'; // Importa intl para manejar la localización.

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final List<String> therapists;
  final List<String> availableTimes;
  final List<String> availableDays;

  const BookingScreen({
    super.key,
    required this.serviceName,
    required this.therapists,
    required this.availableTimes,
    required this.availableDays,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedTherapist;
  String? selectedTime;
  DateTime? selectedDate;
  String? userName;

  final DateTime _now = DateTime.now();
  DateTime _firstAvailableDay = DateTime.now();
  DateTime _lastAvailableDay = DateTime.now().add(const Duration(days: 28));

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _firstAvailableDay = _now;
    _lastAvailableDay =
        _now.add(const Duration(days: 28)); // 28 días disponibles
  }

  Future<void> _getUserDetails() async {
    String? fetchedUserName = await fetchUserName();
    setState(() {
      userName = fetchedUserName ?? 'Usuario';
    });
  }

  Future<void> _saveBookingToUserSubcollection() async {
    if (selectedTherapist == null ||
        selectedTime == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecciona todos los campos')),
      );
      return;
    }

    Future<bool> _isTimeSlotAvailable(
        String therapist, DateTime selectedDate, String selectedTime) async {
      try {
        final appointmentsRef = FirebaseFirestore.instance
            .collection('reservations')
            .doc(therapist) // Documento del terapeuta
            .collection('appointments'); // Subcolección de citas

        final snapshot = await appointmentsRef
            .where('date',
                isEqualTo:
                    Timestamp.fromDate(selectedDate)) // Fecha como Timestamp
            .where('time', isEqualTo: selectedTime) // Hora como String
            .get();

        return snapshot.docs.isEmpty; // Retorna true si no hay citas
      } catch (e) {
        print('Error al verificar la disponibilidad: $e');
        return false;
      }
    }

    // Verificar disponibilidad del horario
    bool isAvailable = await _isTimeSlotAvailable(
        selectedTherapist!, selectedDate!, selectedTime!);

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El horario seleccionado no está disponible')),
      );
      return;
    }

    // Si el horario está disponible, guardar la reserva
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuario no autenticado");

      final userReservationsRef = FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('Reservas');

      final formattedDate =
          "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate?.month.toString().padLeft(2, '0')}/${selectedDate?.year}";

      // Guardar en la subcolección del usuario
      await userReservationsRef.add({
        'service_name': widget.serviceName,
        'therapist': selectedTherapist,
        'time': selectedTime,
        'day': formattedDate,
        'user_name': userName,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Guardar también en la subcolección del terapeuta
      final therapistAppointmentsRef = FirebaseFirestore.instance
          .collection('reservations')
          .doc(selectedTherapist) // Documento del terapeuta
          .collection('appointments');

      await therapistAppointmentsRef.add({
        'service_name': widget.serviceName,
        'user_id': user.uid,
        'date': Timestamp.fromDate(selectedDate!),
        'time': selectedTime,
        'therapist': selectedTherapist,
      });

      // Mostrar mensaje de confirmación
      _showConfirmationDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la cita: $e')),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.secondary,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                '¡Cita confirmada!',
                style: AppTextStyles.appBarTextStyle.copyWith(
                  color: AppColors.secondary,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tu cita con $selectedTherapist el ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year} a las $selectedTime ha sido confirmada.',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showNotificationButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selección de terapeuta
            DropdownButton<String>(
              value: selectedTherapist,
              hint: const Text("Selecciona un terapeuta"),
              isExpanded: true,
              items: widget.therapists.map((therapist) {
                return DropdownMenuItem<String>(
                  value: therapist,
                  child: Text(therapist),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTherapist = value;
                });
              },
            ),
            const SizedBox(height: 20),

            TableCalendar(
              focusedDay: _now,
              firstDay: _firstAvailableDay,
              lastDay: _lastAvailableDay,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                // No permitir seleccionar sábado o domingo
                if (selectedDay.weekday != DateTime.saturday &&
                    selectedDay.weekday != DateTime.sunday) {
                  setState(() {
                    selectedDate = selectedDay;
                  });
                }
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  // Deshabilitar sábado y domingo
                  if (day.weekday == DateTime.saturday ||
                      day.weekday == DateTime.sunday) {
                    return null; // No se mostrará nada en estos días
                  }

                  // Mostrar días disponibles de lunes a viernes
                  if (day.weekday >= DateTime.monday &&
                      day.weekday <= DateTime.friday &&
                      day.isAfter(_now.subtract(const Duration(days: 1))) &&
                      day.isBefore(
                          _lastAvailableDay.add(const Duration(days: 1)))) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }
                  return null;
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Calendario con idioma español

            const SizedBox(height: 20),

            // Horarios disponibles
            DropdownButton<String>(
              value: selectedTime,
              hint: const Text("Selecciona un horario"),
              isExpanded: true,
              items: widget.availableTimes.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Botón confirmar
            ElevatedButton(
              onPressed: selectedTherapist != null &&
                      selectedTime != null &&
                      selectedDate != null
                  ? _saveBookingToUserSubcollection
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
              ),
              child: const Text('Confirmar Cita'),
            ),
          ],
        ),
      ),
    );
  }
}
