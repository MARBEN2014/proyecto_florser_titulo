import 'package:flutter/material.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_app_bar.dart';
import 'package:paraflorseer/2%20VISTA/widgets/bottom_nav_bar_user.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _isEmailSent = false;
  bool _isFocused = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendRecoveryEmail() async {
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
      try {
        await _auth.sendPasswordResetEmail(email: email);
        setState(() {
          _errorMessage = '';
          _isEmailSent = true;
        });
        _showConfirmationDialog();
      } catch (e) {
        setState(() {
          _errorMessage =
              'Hubo un error al enviar el correo. Verifique su correo electrónico y vuelva a intentarlo.';
          _isEmailSent = false;
        });
      }
    }
  }

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

  Future<void> _refreshScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _emailController.clear();
      _errorMessage = '';
      _isEmailSent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        showNotificationButton: false,
        title: '',
      ),
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
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

              // Campo de correo electrónico mejorado visualmente
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                child: SizedBox(
                  width: double.infinity,
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isFocused = hasFocus;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Sombras hacia abajo
                          ),
                        ],
                        border: Border.all(
                          color: _isFocused ? AppColors.primary : Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                              color:
                                  _isFocused ? AppColors.primary : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(
                              Icons.email,
                              color:
                                  _isFocused ? AppColors.primary : Colors.grey,
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      // Envía el correo de recuperación y redirige a la pantalla de actualización
                      _sendRecoveryEmail();
                      Navigator.pushNamed(context, '/login');
                    },
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

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarUser(),
    );
  }
}
