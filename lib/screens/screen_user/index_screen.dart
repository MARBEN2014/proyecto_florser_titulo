import 'package:flutter/material.dart';
import 'package:paraflorseer/screens/login_screen.dart';
//import 'package:paraflorseer/themes/app_theme.dart'; // Importa el archivo de tema
import 'package:paraflorseer/themes/app_colors.dart'; // Importa colores
import 'package:paraflorseer/themes/app_text_styles.dart'; // Importa estilos de texto
//import 'welcome_screen.dart'; // Asegúrate de importar la pantalla de bienvenida

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporizador para navegar a WelcomeScreen después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });

    return Scaffold(
      backgroundColor: AppColors.primary, // Fondo gris claro
      appBar: AppBar(
        title: Text(
          //ingresar texto sobre la appa
          '',
          style: AppTextStyles.appBarTextStyle, // Estilo del texto del AppBar
        ),
        backgroundColor: AppColors.primary, // Color morado
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(
                '"Nunca dejes de aprender,\nporque la vida nunca deja de enseñar"',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.text,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para crear la transición de desvanecimiento
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        final tween = Tween<double>(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        final opacity = tween.animate(curvedAnimation);

        return FadeTransition(
          opacity: opacity,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 500), // Duración de la transición
    );
  }
}
