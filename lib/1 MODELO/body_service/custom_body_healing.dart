import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar paquete para formatear el número
import 'package:paraflorseer/1%20MODELO/modals/map_healing.dart'; // Cambiado a map_healing
import 'package:paraflorseer/1%20MODELO/ruta_welcome_screen/booking_screen.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_text_styles.dart';
import 'package:paraflorseer/1%20MODELO/descripcions_servicios/descriptions_healing.dart'; // Cambiado a descriptions_healing
import 'package:paraflorseer/1%20MODELO/image_services/image_healing.dart'; // Cambiado a image_healing
import 'package:paraflorseer/3%20CONTROLADOR/utils/obtenerUserandNAme.dart'; // Asegúrate de importar la función fetchUserName

class CustomBodyHealing extends StatelessWidget {
  const CustomBodyHealing({super.key});

  // Obtén la referencia al usuario actual de Firebase
  get user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future:
          fetchUserName(), // Llamamos a la función para obtener el nombre del usuario
      builder: (context, snapshot) {
        // Si estamos esperando la respuesta, mostramos un indicador de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Si hay un error, mostramos el error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Si todo está bien, mostramos el contenido
        String userName = snapshot.data ??
            'Usuario'; // Usamos 'Usuario' si no se obtiene el nombre

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // Título de la sección de sanación
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Servicios de',
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        '  Sanación',
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Mostrar el nombre del usuario debajo del título
                Text(
                  'Hola, $userName', // Aquí mostramos el nombre del usuario
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),

                // Este espacio puede ser personalizado con más widgets o secciones
                Text(
                  'Aquí puedes encontrar los mejores servicios de sanación.',
                  style: AppTextStyles.bodyTextStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),

                // Grid de servicios
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: descriptionsHealing
                      .length, // Cambiado a descriptionsHealing
                  itemBuilder: (context, index) {
                    return Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 160,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: imageHealing[index].startsWith(
                                      'http') // Cambiado a imageHealing
                                  ? Image.network(
                                      imageHealing[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Image.asset(
                                      imageHealing[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  descriptionsHealing[
                                      index], // Cambiado a descriptionsHealing
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyTextStyle
                                      .copyWith(fontSize: 14.3),
                                ),
                                const SizedBox(height: 5),
                                // Mostrar el precio del servicio en el formato ##.###
                                Text(
                                  '\$${_formatPrice(servicesData[descriptionsHealing[index]]?['price'])}',
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Obtener el nombre del servicio seleccionado
                              final String serviceName = descriptionsHealing[
                                  index]; // Cambiado a descriptionsHealing

                              // Obtener los detalles del servicio desde el mapa
                              final serviceData = servicesData[
                                  serviceName]; // Utilizando el mapa de sanación

                              // Verificar si el servicio está en el mapa
                              if (serviceData != null) {
                                // Extraer los terapeutas, horarios y días del servicio
                                List<String> therapists =
                                    serviceData['therapists'];
                                List<String> availableTimes =
                                    serviceData['availableTimes'];
                                List<String> availableDays =
                                    serviceData['availableDays'];

                                // Navegar a la pantalla de BookingScreen con los argumentos correctos
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookingScreen(
                                      serviceName: serviceName,
                                      therapists: therapists,
                                      availableTimes: availableTimes,
                                      availableDays: availableDays,
                                    ),
                                  ),
                                );
                              } else {
                                print("Servicio no reconocido");
                              }
                            },
                            child: const Text('Agendar Cita'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              fixedSize: const Size(150, 40),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Función para formatear el precio en formato ##.###
  String _formatPrice(dynamic price) {
    if (price is int) {
      return NumberFormat("#,###", "es_CL").format(price); // Para enteros
    } else if (price is double) {
      return NumberFormat("#,###", "es_CL")
          .format(price); // Para números con decimales
    }
    return "0"; // En caso de que no sea un número válido
  }
}
