import 'package:flutter/material.dart';
//import 'package:paraflorseer/screens/estadisticas.dart';
//import 'package:paraflorseer/ruta_welcome_screen/agendar_screen.dart';
//import 'package:paraflorseer/screens/register2_screen.dart';
import 'package:paraflorseer/screens/screens.dart';
import 'package:paraflorseer/screens/terminos_condiciones.dart';
import 'package:paraflorseer/widgets/widgets.dart';
import '../ruta_welcome_screen/ruta_welcome_screen.dart'; // Import de todas las pantallas

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const WelcomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      //'/register2': (context) => const Register2Screen(),
      '/recovery_screen': (context) => const RecoveryScreen(),
      '/welcome_screen': (context) => const WelcomeScreen(),
      '/mis_citas_screen': (context) => MisCitasScreen(),
      '/mi_ficha_screen': (context) => MiFichaScreen(),
      '/soporte': (context) => const SoporteScreen(),
      '/notifications': (context) => const NotificationsScreen(),
      '/user': (context) => const UserProfileScreen(),
      '/wellness_screen': (context) => const WellnessScreen(),
      '/guide_screen': (context) => const GuideScreen(),
      '/healing_screen': (context) => const HealingScreen(),
      '/beauty_screen': (context) => const BeautyScreen(),
      '/cleansing_screen': (context) => const CleansingScreen(),
      '/terminos_condiciones': (context) => const TermsAndConditionsScreen(),
      //'/estadisticas': (context) => const DemandStatsScreen(),

      // Ruta para la pantalla de citas
    };
  }
}
