import 'package:flutter/material.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart'; // Import del AppBar personalizado
import 'package:paraflorseer/widgets/bottom_nav_bar.dart'; // Import del Bottom Navigation Bar
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:email_validator/email_validator.dart'; // Paquete para validar correos electrónicos

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _isEmailSent = false;
// Controla el tamaño y estado del label
  bool _isFocused = false; // Controla el estado de enfoque del TextField

  // Función para validar y enviar el correo de recuperación
  void _sendRecoveryEmail() {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'El correo electrónico no puede estar vacío.';
        _isEmailSent = false;
      });
    } else if (!EmailValidator.validate(email)) {
      setState(() {
        _errorMessage = 'Por favor, ingrese un correo electrónico válido.';
        _isEmailSent = false;
      });
    } else {
      // Simular envío de correo
      if (email == 'diegovasquez21@gmail.com') {
        setState(() {
          _errorMessage = '';
          _isEmailSent = true;
        });
        _showConfirmationDialog();
      } else {
        setState(() {
          _errorMessage = 'El correo no coincide con la cuenta.';
          _isEmailSent = false;
        });
      }
    }
  }

  // Mostrar cuadro de diálogo flotante cuando el correo se envía correctamente
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Text(
            'Correo enviado',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Se ha enviado un correo de recuperación.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Función para refrescar la pantalla
  Future<void> _refreshScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _emailController.clear(); // Restablecer el campo de correo
      _errorMessage = ''; // Limpiar el mensaje de error
      _isEmailSent = false; // Restablecer el estado de correo enviado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(), // Uso del AppBar personalizado
      body: RefreshIndicator(
        onRefresh: _refreshScreen, // Refrescar pantalla al deslizar
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Recuperar Contraseña',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Ingrese su correo electrónico para recibir las instrucciones de recuperación de contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de correo electrónico con borde redondeado y cambio de color dinámico
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: SizedBox(
                  width: 350,
                  height: 60,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isFocused = hasFocus; // Controla el enfoque del campo
// Cambia el tamaño del label
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: _isFocused
                              ? AppColors
                                  .primary // Borde primario si está enfocado
                              : Colors.black, // Borde negro si no está enfocado
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                              color: _isFocused
                                  ? AppColors
                                      .primary // Texto primario si está enfocado
                                  : Colors
                                      .black, // Texto negro si no está enfocado
                            ),
                            border: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Mensaje de error justo debajo del campo de correo
              if (_errorMessage.isNotEmpty && !_isEmailSent) ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // Botón de Recuperar Contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _sendRecoveryEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Recuperar Contraseña',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height:
                      200), // Añadir más espacio al final para permitir scroll
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const BottomNavBar(), // Uso del Bottom Navigation Bar
    );
  }
}
