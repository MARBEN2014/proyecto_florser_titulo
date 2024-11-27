import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/themes/app_text_styles.dart';
import 'package:paraflorseer/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/widgets/custom_appbar_welcome.dart';
import 'package:flutter/widgets.dart';
import 'package:paraflorseer/widgets/refresh.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0; // Para rastrear la imagen actual del carrusel

  // Método para refrescar los datos (simulación)
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    // Aquí puedes incluir lógica para refrescar el contenido
  }

  // Método que crea un Container con imagen y descripciones
  Widget _buildImageContainer(
      String imageUrl, List<String> descriptions, String routeName) {
    bool isNetworkImage =
        imageUrl.startsWith('http'); // Verificar si es una URL de red

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, routeName); // Navegar a la pantalla correspondiente
      },
      child: Column(
        children: [
          Container(
            width: 250,
            height: 140,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isNetworkImage
                    ? NetworkImage(imageUrl) // Imagen de red
                    : AssetImage(imageUrl) as ImageProvider, // Imagen local
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.5),
                  spreadRadius: 10,
                  blurRadius: 15,
                  offset: const Offset(7, 8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: descriptions.map((desc) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 50),
                    const Icon(Icons.task_alt, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          desc,
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista de imágenes (incluye una imagen local en assets)
    final List<String> imgList = [
      'https://sesdermaskincenter.es/wp-content/uploads/2023/03/Lifting-Japones-Tratamiento-facial-2.jpg',
      'http://bienestaryser.com.mx/uploads/6/9/4/8/69487023/lectura-tarot_orig.jpg',
      'https://img.freepik.com/fotos-premium/revitalizar-su-piel-experiencia-clinica-belleza-moderna_886588-57010.jpg?w=740',
      'https://img.freepik.com/fotos-premium/visualizacion-curacion-energia-equilibrio-chakra-limpieza-aura-medicina-alternativa-cuidado-holistico_407474-38829.jpg?w=740',
      'https://img.freepik.com/premium-photo/stack-towels-with-flowers-flower-top_715950-20070.jpg?w=360',
    ];

    // Lista de descripciones
    final List<List<String>> descriptions = [
      [
        "Atención personalizada",
        "Terapias alternativas certificadas",
        "Horarios flexibles"
      ],
      [
        "Ambiente relajante",
        "Terapeutas profesionales",
        "Materiales 100% naturales"
      ],
      [
        "Técnicas innovadoras",
        "Resultados garantizados",
        "Adaptado a tus necesidades"
      ],
      [
        "Servicios especializados",
        "Atención integral",
        "Satisfacción garantizada"
      ],
      ["Relajación total", "Cuidado personalizado", "Innovación constante"],
    ];

    // Lista de textos para mostrar arriba del carrusel
    final List<String> carouselTexts = [
      "BIENESTAR",
      "GUÍA",
      "BELLEZA",
      "SANACIÓN",
      "LIMPIEZA",
    ];

    // Lista de rutas de navegación para cada imagen
    final List<String> routeNames = [
      '/wellness_screen',
      '/guide_screen',
      '/beauty_screen',
      '/healing_screen',
      '/cleansing_screen',
    ];

    final double buttonWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWelcome(),
      body: RefreshableWidget(
        // Aquí usamos el widget de refresco
        onRefresh: _refreshData, // Función que se ejecuta al refrescar
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Texto que cambia con el carrusel
              Text(
                carouselTexts[_currentIndex],
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              //Carrusel de imágenes utilizando el método _buildImageContainer
              CarouselSlider.builder(
                itemCount: imgList.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return _buildImageContainer(
                      imgList[index], descriptions[index], routeNames[index]);
                },
                options: CarouselOptions(
                  height: 320,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 1),

              // Botón de Iniciar Sesión
              // SizedBox(
              //   width: buttonWidth,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/login');
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primary,
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 50, vertical: 10),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //     ),
              //     child: Text(
              //       'Iniciar Sesión',
              //       style: AppTextStyles.bodyTextStyle.copyWith(
              //         color: AppColors.secondary,
              //       ),
              //     ),
              //   ),

              //),
              // const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pushNamed(context, '/recovery_screen');
              //   },
              //   child: Text(
              //     '¿Olvidaste tu contraseña?',
              //     style: AppTextStyles.bodyTextStyle.copyWith(
              //       color: AppColors.text,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: 'Si no eres usuario, ',
              //         style: AppTextStyles.bodyTextStyle.copyWith(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 14,
              //         ),
              //       ),
              //       WidgetSpan(
              //         alignment: PlaceholderAlignment.middle,
              //         child: GestureDetector(
              //           onTap: () {
              //             Navigator.pushNamed(context, '/register');
              //           },
              //           child: Text(
              //             'regístrate',
              //             style: AppTextStyles.bodyTextStyle.copyWith(
              //               color: AppColors.primary,
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarUser(),
    );
  }
}
