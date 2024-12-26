import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/TherapyRankingScreen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/adminDeleteUser.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/adminsearchUserScreen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/createUserscreen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/gestionterapeutas.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/indexCruduser.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/indexrolesadmin.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/phonescreen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/progresodeBarras.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/registeruser_screen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/soporteadmin.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/terminosAdmin.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/userAdmin.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/datos_importantes.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/histoyforuser.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/horas_terapeutas_screen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/terminos%20_condiciones_therapist.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/userprofile_therapist.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_user/historyScreen.dart';
//import 'package:paraflorseer/screens/estadisticas.dart';
//import 'package:paraflorseer/ruta_welcome_screen/agendar_screen.dart';
//import 'package:paraflorseer/screens/register2_screen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_user/screens.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/soporte_screen_therapist.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_admin/stadistic_screen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_user/terminos_condiciones.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_therapist.dart/therapist_screen.dart';
import 'package:paraflorseer/2%20VISTA/screens/screen_user/welcomeScreenLogin.dart';
//import 'package:paraflorseer/screens/screen_user/updatepasswordScreen.dart';
import 'package:paraflorseer/1%20MODELO/notifications_screen.dart';

//import 'package:paraflorseer/widgets/widgets.dart';
import '../ruta_welcome_screen/ruta_welcome_screen.dart'; // Import de todas las pantallas

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    // var userId;
    return {
      '/': (context) => const WelcomeScreen(),
      '/index': (context) => const IndexScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      //'/register2': (context) => const Register2Screen(),
      '/recovery_screen': (context) => const RecoveryScreen(),
      '/welcome_screen': (context) => const WelcomeScreen(),
      '/mis_citas_screen': (context) => MisCitasScreen(),
      '/mi_ficha_screen': (context) => MiFichaScreen(),
      '/soporte': (context) => const SoporteScreen(),
      '/notifications': (context) => const NotificationsScreen(),
      '/user': (context) => const UserProfileScreen(userId: ''),
      '/wellness_screen': (context) => const WellnessScreen(),
      '/guide_screen': (context) => const GuideScreen(),
      '/healing_screen': (context) => const HealingScreen(),
      '/beauty_screen': (context) => const BeautyScreen(),
      '/cleansing_screen': (context) => const CleansingScreen(),
      '/terminos_condiciones': (context) => const TermsAndConditionsScreen(),
      '/ranking': (context) => TherapyRankingScreen(),
      '/estadisticas': (context) => EstadisticasScreen(),
      '/therapist': (context) => TherapistScreen(),
      '/soporte_terapeuta': (context) => SoporteScreenTherapist(),
      '/condiciones _terapeuta': (context) => TerminosCondicionesTherapist(),
      '/user_terapeuta': (context) => UserprofileTherapist(),
      '/horas_terapeuta': (context) => HorasTerapeutasScreen(),
      '/datos_terapeutas': (context) => TherapistsPhoneScreen(),
      '/create_user': (context) => CreateUserScreen(),
      '/register_userAdmin': (context) => RegisterUserScreen(userId: ''),
      '/indexCruduser': (context) => IndexCrudUser(),
      '/gestion_roles': (context) => IndexRolesAdmin(),
      '/gestion_terapeutas': (context) => GestionTerapeutasScreen(),
      '/telefonos': (context) => Phonescreen(),
      '/Progreso de citas': (context) => ProgresoDeCitasScreen(),
      '/searchUser': (context) => AdminFindUserScreen(),
      '/deleteUser': (context) => AdminDeleteUserScreen(),
      '/soporte_admin': (context) => SoporteAdmin(),
      '/terminos_admin': (context) => TerminosAdmin(),
      '/user_admin': (context) => UserProfileScreenAdmin(userId: ''),
      '/history': (context) => HistorialCitasScreen(),
      '/history_user': (context) => HistoryForUserScreen(),
      '/welcomeLogin': (context) => WelcomeScreenLogin(),
      //'/actualizar_pass': (context) => UpdatePasswordScreen(),

      //'/estadisticas': (context) => const DemandStatsScreen(),

      // Ruta para la pantalla de citas
    };
  }
}
