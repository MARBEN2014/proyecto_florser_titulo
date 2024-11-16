import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:paraflorseer/preferencias/pref_usuarios.dart';
//import 'package:paraflorseer/screens/screens.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/utils/auth.dart';
//import 'package:paraflorseer/utils/snackbar.dart';
import 'package:paraflorseer/widgets/custom_app_bar.dart';
//import '../widgets/bottom_nav_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    'Regístrate',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                FormBuilder(
                  key: _formKeyPage1,
                  autovalidateMode: AutovalidateMode
                      .onUserInteraction, // Validación en tiempo real
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'email', // nombre del campo correo electrónico
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

                      //

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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña es obligatoria';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          // Verificación adicional para incluir mayúsculas, minúsculas, símbolos y números
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_-])[A-Za-z\d@$!%*?&_-]{6,}$')
                              .hasMatch(value)) {
                            return 'La contraseña debe contener al menos:\n'
                                '- Una letra minúscula\n'
                                '- Una letra mayúscula\n'
                                '- Un número\n'
                                '- Un símbolo especial (@, \$, !, %, *, ?, &,_,-)';
                          }
                          return null; // Si pasa todas las validaciones
                        },
                      ),

                      const SizedBox(height: 16.0),
                      const SizedBox(height: 30.0),

                      //
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
                          var prefs = PreferenciasUsuarios();
                          //showSnackBar(context, 'Mensaje de prueba');

                          //validar formulario, los datos son ingresados corectamenta
                          //se inicia el proceso autenticaión
                          _formKeyPage1.currentState?.save();
                          if (_formKeyPage1.currentState?.validate() == true) {
                            final v = _formKeyPage1.currentState?.value;
                            print(v?['email']);
                            print(v?['password']);

                            // la respuesta se almacena en resultado
                            var result = await _auth.createAccount(
                                v?['email'], v?['password'], context);
                            print(
                                'Resultado de la creación de cuenta: $result');

                            // Obtener el UID del usuario recién creado

                            // movimento de traspaso de informacion al crear
                            prefs.ultimouid = result;
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(result)
                                .set({
                              // sentencia para guradar el usario en la base de datos de firebase
                              'email': v?['email'],
                              'password': v?['password'],
                              'role':
                                  'user', // campo donde se genra de forma predetreminada el rol de usario
                            });
                            Navigator.pushReplacementNamed(context, '/user');
                          }
                        },
                        child: const Text(
                          '¡Registrarse!',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.secondary),
                        ),
                      ),

                      ///
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      //bottomNavigationBar: const BottomNavBar(),
    );
  }
}
