import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:paraflorseer/preferencias/pref_usuarios.dart';
import 'package:paraflorseer/themes/app_colors.dart';
import 'package:paraflorseer/utils/auth.dart';
import 'package:paraflorseer/utils/snackbar.dart';
//import 'package:paraflorseer/widgets/custom_appbar_back.dart';
import 'package:paraflorseer/widgets/custom_appbar_welcome.dart';
//import 'package:paraflorseer/widgets/custom_appbar_logo.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKeyPage1 = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();
  bool _isObscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailVerified = false;

  Future<void> _refreshScreen() async {
    _formKeyPage1.currentState?.reset();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWelcome(),
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
                    'Comienza Verificando al usuario',
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La contraseña es obligatoria';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_-])[A-Za-z\d@$!%*?&_-]{6,}$')
                              .hasMatch(value)) {
                            return 'La contraseña debe contener al menos:\n'
                                '- Una letra minúscula\n'
                                '- Una letra mayúscula\n'
                                '- Un número\n'
                                '- Un símbolo especial (@, \$, !, %, *, ?, &,_,-)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
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
                          var prefs = PreferenciasUsuarios();

                          _formKeyPage1.currentState?.save();
                          if (_formKeyPage1.currentState?.validate() == true) {
                            final v = _formKeyPage1.currentState?.value;

                            bool isVerified = await _auth.createAccount(
                              v?['email'],
                              v?['password'],
                              context,
                            );

                            if (isVerified) {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                prefs.ultimouid = user.uid;

                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(user.uid)
                                    .set({
                                  'email': v?['email'],
                                  'password': v?['password'],
                                  'role': 'user',
                                });

                                Navigator.pushReplacementNamed(
                                    context, '/register_userAdmin');
                              }
                            } else {
                              showSnackBar(context,
                                  "El correo no fue verificado o hubo un error.");
                            }
                          }
                        },
                        child: const Text(
                          'Verificar Correo Elcetrónico',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.secondary),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (!_isEmailVerified)
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
                            await _auth.resendVerificationEmail(context);
                          },
                          child: const Text(
                            'Reenviar correo de verificación',
                            style: TextStyle(
                                fontSize: 18, color: AppColors.secondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
