import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_therapist.dart';

import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_welcome.dart'; // Import del Bottom Navigation Bar

class TerminosCondicionesTherapist extends StatelessWidget {
  const TerminosCondicionesTherapist({super.key});

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
            ''' TÉRMINOS DE USO - FLORSER PARA TERAPEUTAS
NO UTILICE ESTA APLICACIÓN EN CASO DE EMERGENCIA
FlorSer no está diseñada para gestionar emergencias. Si se enfrenta a una situación de emergencia médica, póngase en contacto con los servicios de urgencia o acuda al centro asistencial más cercano.

BIENVENIDO A FLORSER
El uso de esta plataforma móvil como herramienta de gestión profesional está condicionado a la aceptación de los términos descritos a continuación. Al utilizar nuestra aplicación, usted, como terapeuta asociado, acepta cumplir con estas condiciones y con la legislación vigente en la República de Chile.

CONDICIONES GENERALES
Estos términos aplican a todas las funcionalidades disponibles para los terapeutas en FlorSer, incluyendo pero no limitándose a:

Gestión de su agenda de citas.
Acceso y actualización de su perfil profesional.
Comunicación con los usuarios de la plataforma.
Registro de información relacionada con los servicios prestados.
Cualquier nueva funcionalidad futura también estará sujeta a estos términos.

ACEPTACIÓN DE LOS TÉRMINOS
El registro y uso de FlorSer como terapeuta implica su aceptación expresa de los términos aquí establecidos. Si no está de acuerdo con alguna parte, debe abstenerse de utilizar la aplicación.

USO DE LOS SERVICIOS
La aplicación FlorSer está diseñada para facilitar la interacción profesional entre los terapeutas asociados y los usuarios que buscan terapias alternativas. Como terapeuta, usted es responsable de:

Gestionar de manera precisa y actualizada su disponibilidad de horarios.
Brindar información clara y veraz sobre los servicios ofrecidos.
Ofrecer terapias en cumplimiento con las normativas legales y éticas vigentes.
FlorSer es únicamente una herramienta intermediaria; la relación terapéutica entre usted y los usuarios es de su exclusiva responsabilidad.

RESPONSABILIDAD LIMITADA
FlorSer no se hace responsable de los resultados de las terapias que usted ofrezca a través de la plataforma ni de cualquier conflicto que pueda surgir con los usuarios. Usted, como terapeuta, asume toda la responsabilidad sobre la calidad y eficacia de los servicios prestados.

EXCLUSIÓN DE GARANTÍAS
FlorSer no garantiza la ausencia de interrupciones o errores en los servicios tecnológicos de la plataforma. Sin embargo, trabajamos continuamente para asegurar la estabilidad y funcionalidad de nuestras herramientas.

MODIFICACIONES A LOS TÉRMINOS
Nos reservamos el derecho de modificar estos términos en cualquier momento. Cualquier cambio será notificado a través de la aplicación, y su uso continuado de los servicios implicará la aceptación de los nuevos términos.

CONTACTO
Si tiene preguntas o necesita asistencia técnica, puede comunicarse con el equipo de soporte de FlorSer a través de los canales oficiales indicados en la aplicación. ''',
            style: TextStyle(
              fontSize: 16,
              height: 1.5, // Mejora la legibilidad del texto
            ),
            textAlign: TextAlign.justify, // Justificar el texto
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarTherapist(),
    );
  }
}
