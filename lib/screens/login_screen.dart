import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
//import 'package:paraflorseer/screens/screens.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/utils/auth.dart';
import 'package:paraflorseer/utils/snackbar.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyPage1 = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();
  bool _isObscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _refreshScreen() async {
    _formKeyPage1.currentState?.reset();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilder(
                  key: _formKeyPage1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'email',
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(color: AppColors.text),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                        ),
                        validator: ValidationBuilder()
                            .email('Ingresa un correo electrónico válido')
                            .required('El correo electrónico es obligatorio')
                            .build(),
                      ),
                      const SizedBox(height: 16.0),
                      FormBuilderTextField(
                        name: 'password',
                        controller: _passwordController,
                        obscureText: _isObscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: AppColors.primary),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscurePassword = !_isObscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: ValidationBuilder()
                            .minLength(6,
                                'La contraseña debe tener al menos 6 caracteres')
                            .required('La contraseña es obligatoria')
                            .build(),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () async {
                          _formKeyPage1.currentState?.save();
                          if (_formKeyPage1.currentState?.validate() == true) {
                            final v = _formKeyPage1.currentState?.value;
                            print(v?['email']);
                            print(v?['password']);
                            var result = await _auth.singInEmailAndPassword(
                                v?['email'], v?['password']);
                            print(
                                'Resultado de la creación de cuenta: $result');

                            //
                            if (result == 1) {
                              showSnackBar(
                                  context, '¡Error en el usuario o contraseña');
                            } else if (result == 2) {
                              showSnackBar(
                                  context, 'error en el usuario o contraseña');
                            } else if (result != null) {
                              Navigator.popAndPushNamed(
                                  context, '/welcome_screen');
                            }
                          }
                        },

                        //
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Acción para iniciar sesión con Facebook
                            },
                            child: Image.asset(
                              'assets/facebook.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // Acción para iniciar sesión con Google
                            },
                            child: Image.asset(
                              'assets/google.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/recovery_screen');
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Si no eres usuario, "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'regístrate',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
