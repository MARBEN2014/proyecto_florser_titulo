import 'package:flutter/material.dart';
//import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bra_admin.dart';
//import 'package:paraflorseer/widgets/custom_appbar_back.dart';
import 'package:paraflorseer/widgets/custom_appbar_welcome.dart'; // Import del Bottom Navigation Bar

class TerminosAdmin extends StatelessWidget {
  const TerminosAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWelcome(),
      // Título de la pantalla

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '''TÉRMINOS DE USO - FLORSER
NO UTILICE ESTA APLICACIÓN EN CASO DE EMERGENCIA
Si tiene una emergencia de salud, por favor diríjase de inmediato a un centro de atención médica.

                          BIENVENIDO A FLORSER
El uso de esta aplicación móvil y los servicios ofrecidos a través de ella están condicionados a la aceptación de los términos de uso descritos a continuación. Al acceder o utilizar nuestra aplicación, usted acepta estos términos, así como la legislación aplicable en la República de Chile. Todas las transacciones, interacciones y efectos jurídicos que se realicen a través de esta plataforma se regirán por estas reglas y por la legislación vigente.

                          CONDICIONES GENERALES
Los términos y condiciones aquí descritos aplican a todos los servicios provistos a través de la aplicación FlorSer, incluyendo pero no limitándose a la reserva de citas para terapias alternativas, acceso a información de terapeutas y la interacción con nuestras herramientas de gestión de bienestar. Estos términos también aplican a cualquier otro servicio futuro que sea incorporado a la plataforma.

                        ACEPTACIÓN DE LOS TÉRMINOS
Cualquier persona que desee utilizar la aplicación y sus servicios deberá aceptar estos términos. Si no está de acuerdo con alguna parte de estos términos, debe abstenerse de utilizar la aplicación. El uso de FlorSer implica su aceptación expresa de estos términos y condiciones.

                        USO DE LOS SERVICIOS
Los servicios ofrecidos a través de FlorSer, incluyendo la reserva de citas y acceso a información sobre terapias y terapeutas, son proporcionados para facilitar su bienestar físico, mental y espiritual. Sin embargo, estos servicios no reemplazan en ningún caso una evaluación médica o profesional. FlorSer actúa únicamente como intermediario para gestionar la interacción entre usted y los profesionales de terapias alternativas.

                        RESPONSABILIDAD LIMITADA
FlorSer no es responsable de la calidad o resultados de las terapias o servicios ofrecidos por los terapeutas asociados a la plataforma. Cualquier recomendación, terapia o tratamiento es responsabilidad exclusiva del terapeuta que usted elija. FlorSer no asume responsabilidad alguna por daños, perjuicios o inconvenientes que puedan surgir de la relación profesional entre usted y el terapeuta seleccionado.

                        EXCLUSIÓN DE GARANTÍAS
FlorSer no garantiza que la información contenida en la aplicación esté siempre actualizada, completa o libre de errores. Tampoco garantizamos que los servicios se presten sin interrupciones o fallos, aunque haremos lo posible por minimizar cualquier inconveniente.

                        MODIFICACIONES 
                                      A 
                            LOS TÉRMINOS
FlorSer se reserva el derecho de modificar estos términos y condiciones en cualquier momento. Cualquier cambio será notificado a través de la aplicación, y el uso continuado de los servicios tras la notificación implicará su aceptación de dichos cambios.

                        CONTACTO
Para cualquier consulta relacionada con estos términos de uso, puede ponerse en contacto con el equipo de FlorSer a través de los canales de atención indicados en la aplicación.''',
            style: TextStyle(
              fontSize: 16,
              height: 1.5, // Mejora la legibilidad del texto
            ),
            textAlign: TextAlign.justify, // Justificar el texto
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarAdmin(),
    );
  }
}
