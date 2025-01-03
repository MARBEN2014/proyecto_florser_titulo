import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:paraflorseer/3%20CONTROLADOR/services/bloc/notifications_bloc.dart';
import 'package:paraflorseer/2%20VISTA/themes/app_colors.dart';
import 'package:paraflorseer/3%20CONTROLADOR/utils/auth.dart';
import 'package:paraflorseer/3%20CONTROLADOR/utils/snackbar.dart';
import 'package:paraflorseer/2%20VISTA/widgets/custom_appbar_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKeyPage1 = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();
  bool _isObscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.requestPermission(); // Solicita permisos de notificación
    notificationsBloc
        .onTokenRefresh(); // Configura la escucha de cambios del token
  }

  Future<void> _refreshScreen() async {
    _formKeyPage1.currentState?.reset();
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Previene la navegación hacia atrás
      child: Scaffold(
        appBar: const CustomAppBarLoggedOut(),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            labelStyle:
                                const TextStyle(color: AppColors.primary),
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
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 40.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                                onPressed: () async {
                                  _formKeyPage1.currentState?.save();
                                  if (_formKeyPage1.currentState?.validate() ==
                                      true) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    final v = _formKeyPage1.currentState?.value;
                                    final result =
                                        await _auth.signInEmailAndPassword(
                                      v?['email'],
                                      v?['password'],
                                      context,
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (result['success'] == true) {
                                      if (context.mounted) {
                                        switch (result['role']) {
                                          case 'admin':
                                            Navigator.pushReplacementNamed(
                                                context, '/estadisticas');
                                            break;
                                          case 'therapist':
                                            Navigator.pushReplacementNamed(
                                                context, '/therapist');
                                            break;
                                          case 'user':
                                            Navigator.pushReplacementNamed(
                                                context, '/welcomeLogin');
                                            break;
                                          default:
                                            showSnackBar(context,
                                                'Rol desconocido. Contacta al administrador.');
                                        }
                                      }
                                    } else if (result['message'] != null) {
                                      showSnackBar(context, result['message']);
                                    } else {
                                      showSnackBar(context,
                                          'Ocurrió un error inesperado.');
                                    }
                                  }
                                },
                                child: const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                'assets/facebook.png',
                                width: 80,
                                height: 80,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                'assets/google.png',
                                width: 80,
                                height: 80,
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
      ),
    );
  }
}
